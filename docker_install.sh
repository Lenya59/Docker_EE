#!/bin/bash

sudo su -

# BEGIN ########################################################################
echo -e "-- ------------------ --\n"
echo -e "-- BEGIN BOOTSTRAPING --\n"
echo -e "-- ------------------ --\n"

# BOX ##########################################################################
echo -e "-- Updating packages list\n"

apt-get update

# SET UP REPOSITORY
echo -e "-- allow apt to use a repository over HTTPS\n"

apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

echo -e "-- set enviromental variables\n"
DOCKER_EE_URL="https://storebits.docker.com/ee/trial/sub-ef46651c-aff5-40ea-a1a8-ac7be6223618"
DOCKER_EE_VERSION=18.09

# Docker’s official GPG key
curl -fsSL "${DOCKER_EE_URL}/ubuntu/gpg" | sudo apt-key add -


# SET UP the stable repository
add-apt-repository \
   "deb [arch=$(dpkg --print-architecture)] $DOCKER_EE_URL/ubuntu \
   $(lsb_release -cs) \
   stable-$DOCKER_EE_VERSION"

#Install Docker EE
echo -e "-- Docker_EE installing\n"

apt-get update

apt-get install docker-ee docker-ee-cli containerd.io

groupadd docker
usermod -aG docker $(whoami)

systemctl enable docker
systemctl status docker
