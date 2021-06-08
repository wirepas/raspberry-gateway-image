#!/bin/bash

echo "Getting get-docker.sh script"
curl -fsSL https://get.docker.com -o get-docker.sh

echo "Executing the script"
sh get-docker.sh
