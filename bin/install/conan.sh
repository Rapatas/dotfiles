#!/bin/sh

sudo apt-get install -y python3 python3-pip
sudo pip3 install conan
conan profile new default --detect
conan profile update settings.compiler.libcxx=libstdc++11 default
