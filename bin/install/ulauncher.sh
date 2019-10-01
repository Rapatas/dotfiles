#!/bin/sh

cd
wget -O ulauncher.deb https://github.com/Ulauncher/Ulauncher/releases/download/4.4.0.r1/ulauncher_4.4.0.r1_all.deb
sudo dpkg -i ulauncher.deb
sudo apt install -f -y
sudo dpkg -i ulauncher.deb
rm ulauncher.deb
