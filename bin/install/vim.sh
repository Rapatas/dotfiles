#!/bin/sh

# All plugins
vim -c 'PluginInstall' -c 'PluginUpdate' -c 'qa!'

# YCM
sudo apt install -y build-essential python-dev python3-dev
cd ~/.vim/bundle/YouCompleteMe/
./install.py --clang-completer
