#!/bin/sh

wget \
  -O ~/minecraft.deb \
  https://launcher.mojang.com/download/Minecraft.deb

sudo apt install -y ~/minecraft.deb
rm ~/minecraft.deb
