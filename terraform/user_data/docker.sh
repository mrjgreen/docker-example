#!/bin/bash
set -e

#################
# Install Docker
#################

# Install packages to allow apt to use a repository over HTTPS:
apt-get install -yq apt-transport-https ca-certificates curl software-properties-common
# Add Docker’s official GPG key:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# Verify that the key fingerprint is: 9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88
apt-key fingerprint 0EBFCD88
# Add the stable repo
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
# Update now we have added the repo
apt-get update -q
# Install docker
apt-get install -yq docker-ce=17.03.1~ce-0~ubuntu-xenial

# Install compose
curl -L "https://github.com/docker/compose/releases/download/1.11.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod a+x /usr/local/bin/docker-compose

# Start docker on boot
systemctl enable docker
