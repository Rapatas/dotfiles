#!/bin/sh

mkdir ~/.ssh
chmod 700 ~/.ssh
ssh-keygen -t rsa -b 4096 -o -a 10 -f "$HOME/.ssh/$USER@$HOSTNAME.rsa" -C "$USER@$HOSTNAME.rsa" -N ""
