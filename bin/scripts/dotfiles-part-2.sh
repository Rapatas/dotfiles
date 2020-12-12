#!/bin/bash

# Set the correct user info only for the dotfiles repository.
dotfiles config user.name "Andy Rapatas"
dotfiles config user.email "15367779+Rapatas@users.noreply.github.com"

# Setup bash to use XDG paths.
echo '
confdir=\${XDG_CONFIG_HOME:-\$HOME/.config}/bash
[ -d "$confdir" ] && [ "\$0" = "bash" ] && source "\$confdir"/bashrc
unset confdir
' | sudo tee /etc/profile.d/bash_in_xdg_config_home.sh > /dev/null

echo '
confdir=\${XDG_CONFIG_HOME:-\$HOME/.config}/bash
[ -d "$confdir" ] && [ "\$0" = "bash" ] && source "\$confdir"/bash_logout
unset confdir
' | sudo tee /etc/bash.bash_logout > /dev/null

if ! $(grep -q '.config/bash/bashrc' /etc/bash.bashrc); then
  echo '[ -f $HOME/.config/bash/bashrc ] && source $HOME/.config/bash/bashrc' \
    | sudo tee -a /etc/bash.bashrc
fi

mkdir -p $XDG_DATA_HOME/bash
mkdir -p $HOME/.config/bash
mv ~/.bashrc $HOME/.config/bash/bashrc

sudo sed -i 's/^\(USERXSESSION=\).*$/\1\$XDG_CACHE_HOME\/X11\/xsession/g'      /etc/X11/Xsession
sudo sed -i 's/^\(USERXSESSIONRC=\).*$/\1\$XDG_CACHE_HOME\/X11\/xsessionrc/g'  /etc/X11/Xsession
sudo sed -i 's/^\(ALTUSERXSESSION=\).*$/\1\$XDG_CACHE_HOME\/X11\/xresources/g' /etc/X11/Xsession
sudo sed -i 's/^\(ERRFILE=\).*$/\1\$XDG_CACHE_HOME\/X11\/xsession-errors/g'    /etc/X11/Xsession
sudo sed -i 's/^\(USRRESOURCES=\).*$/\1\$XDG_CONFIG_HOME\/X11\/xresources/g'   /etc/X11/Xsession

# Delete hist commands from .bashrc
sed -i '/HISTSIZE=\|HISTFILESIZE=\|HISTCONTROL=/d' $HOME/.config/bash/bashrc

# Extend sudo timeout so it can last while the next apt is running
sudo sh -c "echo \"Defaults timestamp_timeout=120\" > /etc/sudoers.d/timeout"
sudo chmod 0440 /etc/sudoers.d/timeout

sudo apt-get update
sudo apt-get install -y etckeeper
sudo apt-get upgrade -y

xargs -a <(sed '/^#.*$/d' ~/.dotfiles/package-list) sudo apt-get install -y
xargs -a <(sed '/^#.*$/d' ~/.dotfiles/snap-list) sudo snap install

~/bin/install/conan.sh
~/bin/install/fzf.sh
~/bin/install/ranger_devicons.sh
~/bin/install/signal.sh
~/bin/install/slack.sh
~/bin/install/steam.sh
~/bin/install/tild-ah.sh
~/bin/install/typora.sh
~/bin/install/ulauncher.sh
~/bin/install/vim.sh
~/bin/install/wally.sh

tmux start-server
tmux new-session -d
~/.tmux/plugins/tpm/scripts/install_plugins.sh
tmux new-session "vim -c 'Tmuxline lightline' -c 'TmuxlineSnapshot! ~/.tmux/theme_snapshot' -c 'q'"
tmux kill-server

#~/bin/scripts/keygen.sh

# Reset the sudo timeout to default
sudo rm /etc/sudoers.d/timeout

reboot
