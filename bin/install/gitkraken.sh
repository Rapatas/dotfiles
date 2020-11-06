#!/bin/sh

cd /dev/shm/
wget \
  -O gitkraken_latest.deb \
  "https://release.gitkraken.com/linux/gitkraken-amd64.deb"
sudo apt-get install -y gitkraken_latest.deb
