#!/bin/sh

sudo apt install -y openssl libssl-dev

cd
wget https://github.com/Kitware/CMake/releases/download/v3.16.5/cmake-3.16.5.tar.gz
tar -xzf ~/cmake-3.16.5.tar.gz 

cd ~/cmake-3.16.5
# Enable openssl
sed -i 's/cmake_options="-DCMAKE_BOOTSTRAP=1"/cmake_options="-DCMAKE_BOOTSTRAP=1 -DCMAKE_USE_OPENSSL=ON"/' bootstrap
mkdir build
cd build

../bootstrap
sudo make install

cd
rm -rf cmake-3.16.5 cmake-3.16.5.tar.gz 
