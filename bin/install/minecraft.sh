#!/bin/sh

cd /dev/shm/
wget \
  -O minecraft.deb \
  https://launcher.mojang.com/download/Minecraft.deb
sudo apt-get install -y ./minecraft.deb
