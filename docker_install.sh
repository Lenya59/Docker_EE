#!/bin/bash

# BEGIN ########################################################################
echo -e "-- ------------------ --\n"
echo -e "-- BEGIN BOOTSTRAPING --\n"
echo -e "-- ------------------ --\n"

# BOX ##########################################################################
echo -e "-- Updating packages list\n"

sudo apt-get update
sudo apt-get upgrade -y

# SET UP REPOSITORY
echo -e "-- allow apt to use a repository over HTTPS\n"

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

echo -e "-- set enviromental variables\n"

DOCKER_EE_URL="https://storebits.docker.com/ee/trial/sub-ef46651c-aff5-40ea-a1a8-ac7be6223618"
DOCKER_EE_VERSION=18.09

# Docker’s official GPG key
sudo curl -fsSL "${DOCKER_EE_URL}/ubuntu/gpg" | sudo apt-key add -

# SET UP the stable repository
sudo add-apt-repository \
   "deb [arch=$(dpkg --print-architecture)] $DOCKER_EE_URL/ubuntu \
   $(lsb_release -cs) \
   stable-$DOCKER_EE_VERSION"

echo -e "-- Updating packages list\n"

sudo apt-get update
sudo apt-get upgrade -y

#Install Docker EE
echo -e "-- Docker_EE installing\n"

sudo apt-get install docker-ee docker-ee-cli containerd.io -y

sudo usermod -aG docker $USER

#Install Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose


sudo systemctl enable docker
sudo systemctl status docker

# END ##########################################################################
echo -e "-- ---------------- --"
echo -e "-- END BOOTSTRAPING --"
echo -e "-- ---------------- --"
