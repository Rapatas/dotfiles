#!/bin/sh

sudo apt-get install libpam-google-authenticator fail2ban

cd /etc/ssh
sudo rm ssh_host_*key
# sudo ssh-keygen -t ed25519 -f ssh_host_ed25519_key -N "" < /dev/null
sudo ssh-keygen -t rsa -b 4096 -f ssh_host_rsa_key -N "" < /dev/null
sudo groupadd ssh-user

# Run per user:
# sudo usermod -a -G ssh-user <username>
# google-authenticator

