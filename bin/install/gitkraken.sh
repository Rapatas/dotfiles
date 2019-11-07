#!/bin/sh

cd
wget -O gitkraken_latest.deb "https://release.gitkraken.com/linux/gitkraken-amd64.deb"
sudo dpkg -i gitkraken_latest.deb
sudo apt install -f
rm gitkraken_latest.deb
