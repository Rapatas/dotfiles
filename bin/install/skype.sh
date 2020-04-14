#!/bin/sh

wget -O ~/skype.deb https://go.skype.com/skypeforlinux-64.deb

sudp apt install -y ~/skype.deb

rm ~/skype.deb
