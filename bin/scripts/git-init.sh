#!/bin/sh

if [ $# != 2 ]; then
  echo "Usage: ./git-init.sh proj_group proj-name"
  exit 1
fi

proj_group=$1
proj_name=$2

sudo mkdir -p /home/git/$proj_group/$proj_name.git
sudo chown git:git /home/git/$proj_group/$proj_name.git
sudo -u git git --git-dir=/home/git/$proj_group/$proj_name.git init --bare
