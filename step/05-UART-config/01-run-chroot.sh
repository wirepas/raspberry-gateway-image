#!/bin/bash

echo "Disable BT"
dtoverlay disable-bt


echo "disable related services"
systemctl disable hciuart.service
