#!/bin/sh

sudo add-apt-repository ppa:bluetooth/bluez
sudo apt-get update
sudo apt-get install -y --reinstall bluez
