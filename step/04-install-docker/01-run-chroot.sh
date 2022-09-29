#!/bin/bash

echo "Getting get-docker.sh script"
curl -fsSL https://get.docker.com -o get-docker.sh

echo "Executing the script"
sh get-docker.sh

echo "Add main user do docker group"
usermod -aG docker ${FIRST_USER_NAME}
