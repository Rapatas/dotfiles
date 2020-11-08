#!/bin/sh

cd /dev/shm/
wget \
  -O slack-desktop-4.4.2-amd64.deb \
  https://downloads.slack-edge.com/linux_releases/slack-desktop-4.4.2-amd64.deb
sudo apt-get install -y ./slack-desktop-4.4.2-amd64.deb
