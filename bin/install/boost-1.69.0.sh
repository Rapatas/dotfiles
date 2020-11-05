#!/bin/sh

# Install dependencies
sudo apt-get update
sudo apt-get install -y \
  build-essential \
  g++ \
  python-dev \
  autotools-dev \
  libicu-dev \
  build-essential \
  libbz2-dev \
  libboost-all-dev

# Get source
cd /dev/shm/
wget \
  -O boost_1_69_0.tar.gz \
  https://sourceforge.net/projects/boost/files/boost/1.69.0/boost_1_69_0.tar.gz/download
tar xzvf boost_1_69_0.tar.gz

# Compile
cd boost_1_69_0/
./bootstrap.sh --prefix=/usr/
./b2
sudo ./b2 install
