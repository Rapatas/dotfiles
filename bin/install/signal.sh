#!/bin/sh

curl -s https://updates.signal.org/desktop/apt/keys.asc | sudo apt-key add -
echo "deb [arch=amd64] https://updates.signal.org/desktop/apt-get xenial main" | sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
sudo apt-get update
sudo apt-get install -y signal-desktop
