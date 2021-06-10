#!/bin/bash

echo "Getting get-docker.sh script"
curl -fsSL https://get.docker.com -o get-docker.sh

echo "Executing the script"
sh get-docker.sh

echo "Add main user do docker group"
usermod -aG docker ${FIRST_USER_NAME}

echo "Install docker compose"
pip3 install docker-compose

echo "Add docker compose installed path to the PATH"
echo "PATH=$PATH:~/.local/bin" >> /home/${FIRST_USER_NAME}/.bashrc
