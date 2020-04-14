#!/bin/sh

echo "Must run in tty[0-9]"

case $(tty) in /dev/tty[0-9]*)
    
    sudo apt install -y git

    git clone --bare git@github.com:rapatas/dotfiles.git ~/.dotfiles/.git

    git --git-dir="$HOME/.dotfiles/.git" --work-tree="$HOME" checkout -f
    git --git-dir="$HOME/.dotfiles/.git" --work-tree="$HOME" submodule update --init

    rm -rf ~/.cache/*

    reboot
    
esac


