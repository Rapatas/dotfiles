#!/bin/sh

set -e

# Remove previous vim installation.
sudo apt-get remove --purge vim vim-runtime vim-gnome vim-tiny vim-gui-common
sudo apt-get install -y liblua5.1-dev luajit libluajit-5.1 python-dev ruby-dev libperl-dev libncurses5-dev libatk1.0-dev libx11-dev libxpm-dev libxt-dev
sudo rm -rf /usr/local/share/vim /usr/bin/vim

# Download latest vim.
git clone https://github.com/vim/vim ~/vimtemp
cd ~/vimtemp
git pull && git fetch
cd src
make distclean
cd ..

# Build latest vim.
./configure \
--enable-multibyte \
--enable-perlinterp=dynamic \
--enable-rubyinterp=dynamic \
--with-ruby-command=/usr/bin/ruby \
--enable-pythoninterp=dynamic \
--with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \
--enable-python3interp \
--with-python3-config-dir=/usr/lib/python3.6/config-3.6m-x86_64-linux-gnu \
--enable-luainterp \
--with-luajit \
--enable-cscope \
--enable-gui=auto \
--with-features=huge \
--with-x \
--enable-fontset \
--enable-largefile \
--disable-netbeans \
--with-compiledby="yourname" \
--enable-fail-if-missing
make -j $(nproc) 
sudo make install

# YCM dependencies.
sudo apt-get install -y \
  build-essential \
  python-dev \
  python3-dev
sudo bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"

# YCM build dependencies.
sudo apt-get install g++-8
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 700 --slave /usr/bin/g++ g++ /usr/bin/g++-7
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 800 --slave /usr/bin/g++ g++ /usr/bin/g++-8

curl \
    -f \
    -L \
    -o ~/.config/vim/autoload/plug.vim \
    --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -c 'PlugInstall' -c 'qa!'

cd ~/.config/vim/plugged/YouCompleteMe

# If you installed llvm manually using the provided script, run 
# `./install.py --clang-completer --system-libclang` instead
# Skip the wget command
./install.py --clangd-completer
