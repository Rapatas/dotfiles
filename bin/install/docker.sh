#!/bin/sh

sudo apt-get remove -y docker docker-engine docker.io containerd runc

sudo apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88

if [ "$(uname -m)" = "x86_64" ]; then 
  sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
else 
  sudo add-apt-repository \
    "deb [arch=arm64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
fi

sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER

if [ "$(uname -m)" = "x86_64" ]; then 

  sudo curl \
    -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose

  sudo curl \
    -L https://raw.githubusercontent.com/docker/compose/1.26.2/contrib/completion/bash/docker-compose \
    -o /etc/bash_completion.d/docker-compose

else

  sudo apt-get install -y libffi-dev libssl-dev python3 python3-pip python3-dev
  sudo apt-get remove -y python-configparser

  # ETA 22min.
  sudo pip3 -v install docker-compose 

fi
