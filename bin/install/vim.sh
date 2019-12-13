#!/bin/sh

# All plugins

curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 

vim -c 'PlugInstall' -c 'qa!'

# YCM
sudo apt install -y build-essential python-dev python3-dev
cd ~/.vim/bundle/YouCompleteMe/
./install.py --clang-completer
