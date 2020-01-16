#!/bin/sh

sudo apt install -y python3 python3-pip
sudo pip3 install conan
conan profile update settings.compiler.libcxx=libstdc++11 default
