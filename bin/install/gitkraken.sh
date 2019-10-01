#!/bin/sh

cd
wget -O gitkraken_latest.deb "https://release.gitkraken.com/linux/gitkraken-amd64.deb"
sudo gdebi gitkraken_latest.deb
rm gitkraken_latest.deb
