#!/bin/sh

cd /dev/shm/
wget https://ftp.nluug.nl/pub/graphics/blender/release/Blender2.90/blender-2.90.1-linux64.tar.xz
[ -d "/opt/blender-2.90.1-linux64" ] \
  && sudo rm -rf /opt/blender-2.90.1-linux64
sudo tar \
  -xvf \
  blender-2.90.1-linux64.tar.xz \
  -C /opt/ 

echo '[Desktop Entry]
Name=Blender 2.90.1
Comment=Open source 3D creation. Free to use for any purpose, forever.
Encoding=UTF-8
Exec=/opt/blender-2.90.1-linux64/blender
TryExec=/opt/blender-2.90.1-linux64/blender
Icon=/opt/blender-2.90.1-linux64/blender.svg
StartupNotify=true
Terminal=false
Type=Application
Categories=Graphics
Version=1.0
' | sudo tee /usr/share/applications/blender.desktop

echo "application/x-blender=blender.desktop" \
  | sudo tee -a /usr/share/applications/defaults.list
