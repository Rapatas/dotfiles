#!/bin/bash

# Delete hist commands from .bashrc
sed -i '/HISTSIZE=/d' ~/.bashrc
sed -i '/HISTFILESIZE=/d' ~/.bashrc

# Extend sudo timeout so it can last while the next apt is running
sudo sh -c "echo \"Defaults timestamp_timeout=120\" > /etc/sudoers.d/timeout"
sudo chmod 0440 /etc/sudoers.d/timeout

sudo apt install -y etckeeper

cat ~/.dotfiles/package-list >> ~/temp
xargs -a <(sed '/^#.*$/d' ~/temp) sudo apt install -y
rm ~/temp

~/.tmux/plugins/tpm/bin/install_plugins

~/bin/install/ulauncher.sh
~/bin/install/signal.sh
~/bin/install/fzf.sh
~/bin/install/ranger_devicons.sh
~/bin/install/vim.sh

~/bin/scripts/keygen.sh

# Reset the sudo timeout to 15 mins
sudo rm /etc/sudoers.d/timeout