#!/bin/bash

echo "Do modification for rpi hat (to take control of /dev/ttyAMA0 instead of onboard bluetooth chip"

raspi-config nonint do_serial_hw 0
raspi-config nonint do_serial_cons 1

if test -f /boot/firmware/config.txt
then
  echo "dtoverlay=pi3-disable-bt" >> /boot/firmware/config.txt
  echo "dtoverlay=pi3-miniuart-bt" >> /boot/firmware/config.txt
else
  echo "Cannot update config.txt"
  exit 1
fi

echo "disable related services"
systemctl disable hciuart.service
