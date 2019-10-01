#!/bin/sh

sudo apt -y install mercurial build-essential linux-headers-generic dkms

cd
hg clone https://bitbucket.org/Swoogan/aziokbd
cd aziokbd
sudo ./install.sh dkms

cd
rm -rf aziokbd
