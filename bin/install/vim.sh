#!/bin/sh

# YCM dependencies
sudo apt install -y build-essential python-dev python3-dev g++-8
sudo bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"

# All plugins
curl \
    -f \
    -L \
    -o ~/.vim/autoload/plug.vim \
    --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim -c 'PlugInstall' -c 'qa!'

