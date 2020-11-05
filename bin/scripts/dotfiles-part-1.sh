#!/bin/sh

sudo apt install -y git

sudo systemctl isolate multi-user.target
git clone --bare git@github.com:rapatas/dotfiles.git ~/.dotfiles/.git

git --git-dir="$HOME/.dotfiles/.git" --work-tree="$HOME" checkout -f
git --git-dir="$HOME/.dotfiles/.git" --work-tree="$HOME" submodule update --init

rm -rf ~/.cache/*

reboot
