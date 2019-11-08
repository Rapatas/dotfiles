#!/bin/bash

# Delete hist commands from .bashrc
sed -i '/HISTSIZE=/d' ~/.bashrc
sed -i '/HISTFILESIZE=/d' ~/.bashrc
sed -i '/HISTCONTROL=/d' ~/.bashrc

# Extend sudo timeout so it can last while the next apt is running
sudo sh -c "echo \"Defaults timestamp_timeout=120\" > /etc/sudoers.d/timeout"
sudo chmod 0440 /etc/sudoers.d/timeout

sudo apt update

sudo apt install -y etckeeper

sudo apt upgrade -y

xargs -a <(sed '/^#.*$/d' ~/.dotfiles/package-list) sudo apt install -y
xargs -a <(sed '/^#.*$/d' ~/.dotfiles/snap-list) sudo snap install

~/bin/install/ulauncher.sh
~/bin/install/signal.sh
~/bin/install/fzf.sh
~/bin/install/ranger_devicons.sh
~/bin/install/vim.sh

tmux start-server
tmux new-session -d
~/.tmux/plugins/tpm/scripts/install_plugins.sh
tmux new-session "vim -c 'Tmuxline airline' -c 'TmuxlineSnapshot! ~/.tmux/theme_snapshot' -c 'q'"
tmux kill-server

~/bin/scripts/keygen.sh

# Reset the sudo timeout to default
sudo rm /etc/sudoers.d/timeout

reboot
