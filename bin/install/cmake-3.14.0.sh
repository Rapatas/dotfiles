#!/bin/sh

sudo apt install -y openssl libssl-dev

wget -O ~/cmake.tar.gz https://github.com/Kitware/CMake/releases/download/v3.14.0/cmake-3.14.0.tar.gz

cd
tar -xzf ~/cmake.tar.gz 

cd ~/cmake
# Enable openssl
sed -i 's/cmake_options="-DCMAKE_BOOTSTRAP=1"/cmake_options="-DCMAKE_BOOTSTRAP=1 -DCMAKE_USE_OPENSSL=ON"/' bootstrap
mkdir build
cd build

../bootstrap

sudo make install

cd
rm -rf cmake cmake.tar.gz 
