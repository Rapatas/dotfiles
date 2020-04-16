#!/bin/sh

wget \
  -O ~/steam.deb \
  https://steamcdn-a.akamaihd.net/client/installer/steam.deb

sudo apt install -y ~/steam.deb
rm ~/steam.deb
