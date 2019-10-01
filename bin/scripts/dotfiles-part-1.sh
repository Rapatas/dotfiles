#!/bin/sh

echo "Must run in tty[0-9]"

case $(tty) in /dev/tty[0-9]*)
    
    sudo apt install -y git

    git clone --bare https://github.com/rapatas/dotfiles ~/.dotfiles/.git

    git --git-dir="$HOME/.dotfiles/.git" --work-tree="$HOME" checkout -f
    git --git-dir="$HOME/.dotfiles/.git" --work-tree="$HOME" submodules init
    git --git-dir="$HOME/.dotfiles/.git" --work-tree="$HOME" submodules update

    rm -rf ~/.cache/*

    reboot
    
esac


