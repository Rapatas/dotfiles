#!/bin/sh

sudo apt-get install -y \
  libfftw3-dev \
  libasound2-dev \
  libncursesw5-dev \
  libpulse-dev \
  libtool

cd /dev/shm/
git clone https://github.com/karlstav/cava.git cava
cd cava
./autogen.sh
./configure
make
sudo make install
