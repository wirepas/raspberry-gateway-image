#!/bin/bash

# Exit on any error. It will be the case if there is no network connection
set -e

# First do what requires to be executed as root
# update apt cache
apt-get update

# Install requirements
apt-get install -y libsystemd-dev python3-dev python3-gi python3-pip

# Additionnaly add mosquitto broker for easy prototyping
apt-get install -y mosquitto

mkdir /home/pi/wirepas/install
cd /home/pi/wirepas/install

# Install python gateway part
wget https://github.com/wirepas/gateway/releases/download/v1.4.0/wirepas_gateway-1.4.0.tar.gz
sudo -u pi pip3 install wirepas_gateway-1.4.0.tar.gz --user

# Install sink service
wget https://github.com/wirepas/gateway/releases/download/v1.4.0/sinkService-v1.4.0-arm
mv sinkService-v1.4.0-arm /home/pi/wirepas/sinkService
chmod +x /home/pi/wirepas/sinkService

# Get dbus rights file
wget https://raw.githubusercontent.com/wirepas/gateway/master/sink_service/com.wirepas.sink.conf
# Change default user to pi instead of wirepas
sed -i 's/user=\"wirepas\"/user=\"pi\"/g' com.wirepas.sink.conf
# Move it to right place
mv com.wirepas.sink.conf /etc/dbus-1/system.d/

# Enable other services
systemctl enable wirepasSink1.service
systemctl enable wirepasTransport.service
systemctl enable wirepasConfigurator.service

# Rename the script once successful execution to stop execution
mv /home/pi/wirepas/firstboot.sh /home/pi/wirepas/firstboot.sh.done

# Reboot so that other service will be started too
reboot
