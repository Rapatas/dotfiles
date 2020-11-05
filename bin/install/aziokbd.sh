#!/bin/sh

sudo apt-get -y install \
  mercurial \
  build-essential \
  linux-headers-generic \
  dkms

cd /dev/shm/
hg clone https://bitbucket.org/Swoogan/aziokbd
cd aziokbd
sudo ./install.sh dkms
