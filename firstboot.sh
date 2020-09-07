#!/bin/bash

# Exit on any error. It will be the case if there is no network connection
set -e

# First do what requires to be executed as root
# update apt cache
apt-get update

# Install requirements
apt-get install -y libsystemd-dev python3-dev python3-gi python3-pip

mkdir /home/pi/wirepas/install
cd /home/pi/wirepas/install

# Install python gateway part with a hack to avoid grpc installation (not required)
wget https://github.com/wirepas/gateway/releases/download/v1.3.0/wirepas_gateway-1.3.0.tar.gz
tar -xf wirepas_gateway-1.3.0.tar.gz

# Install wirepas-messaging manually to avoid installing grpcio
sudo -u pi pip3 install protobuf==3.10.0 --user
sudo -u pi pip3 install --no-deps wirepas_messaging==1.2.0 --user

# Install manually gateway too to avoid installing grpcio again
# Remove wirepas-messaging from deps
sed -i.bak '/wirepas_messaging/d' wirepas_gateway-1.3.0/requirements.txt
sudo -u pi pip3 install -r wirepas_gateway-1.3.0/requirements.txt --no-deps wirepas_gateway-1.3.0.tar.gz --user

# Install sink service
wget https://github.com/wirepas/gateway/releases/download/v1.3.0/sinkService-arm.tar.gz
tar -xf sinkService-arm.tar.gz
mv sinkService /home/pi/wirepas/

# To be removed in next release
wget https://raw.githubusercontent.com/wirepas/gateway/master/python_transport/wirepas_gateway/configure_node.py
chmod +x configure_node.py
mv configure_node.py /home/pi/wirepas/

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
