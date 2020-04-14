#!/bin/sh

wget -O ~/slack-desktop-4.4.2-amd64.deb https://downloads.slack-edge.com/linux_releases/slack-desktop-4.4.2-amd64.deb

sudo apt install -y ~/slack-desktop-4.4.2-amd64.deb

rm ~/slack-desktop-4.4.2-amd64.deb
