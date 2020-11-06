#!/bin/bash

# Set the correct user info only for the dotfiles repository.
dotfiles config user.name "Andy Rapatas"
dotfiles config user.email "15367779+Rapatas@users.noreply.github.com"

# Delete hist commands from .bashrc
sed -i '/HISTSIZE=\|HISTFILESIZE=\|HISTCONTROL=/d' ~/.bashrc

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
