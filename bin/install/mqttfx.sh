#!/bin/sh

cd /dev/shm/
wget \
  -O mqttfx-1.7.1-64bit.deb \
  http://www.jensd.de/apps/mqttfx/1.7.1/mqttfx-1.7.1-64bit.deb
sudo apt-get install -y mqttfx-1.7.1-64bit.deb
