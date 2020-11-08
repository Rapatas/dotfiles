#!/bin/sh

sudo apt-get install -y \
  gtk+3.0 \
  webkit2gtk-4.0 \
  libusb-dev

echo '
# Teensy rules for the Ergodox EZ Original / Shine / Glow
ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"

# STM32 rules for the Planck EZ Standard / Glow
SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", \
    MODE:="0666", \
    SYMLINK+="stm32_dfu"
' | sudo tee /etc/udev/rules.d/50-wally.rules > /dev/null

mkdir -p $HOME/bin/ext/wally/

wget \
  -O ~/bin/ext/wally/wally \
  --no-check-certificate \
  https://configure.ergodox-ez.com/wally/linux

wget \
  -O $HOME/bin/ext/wally/wally.png \
  https://raw.githubusercontent.com/zsa/wally/master/frontend/src/images/icon.png

chmod +x ~/bin/ext/wally/wally

mkdir -p ~/.local/share/applications

echo "
[Desktop Entry]
Encoding=UTF-8
Version=1.0
Type=Application
Terminal=false
Exec=$HOME/bin/ext/wally/wally
Name=Wally
Icon=$HOME/bin/ext/wally/wally.png
Comment=EZ Flash Tool
Categories=System
" > ~/.local/share/applications/wally.desktop

