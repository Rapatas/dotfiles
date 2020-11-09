#!/bin/sh

cd /dev/shm/
wget \
  -O skype.deb \
  https://go.skype.com/skypeforlinux-64.deb
sudo apt-get install -y ./skype.deb
