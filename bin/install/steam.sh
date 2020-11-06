#!/bin/sh

cd /dev/shm/
wget \
  -O steam.deb \
  https://steamcdn-a.akamaihd.net/client/installer/steam.deb
sudo apt-get install -y steam.deb
