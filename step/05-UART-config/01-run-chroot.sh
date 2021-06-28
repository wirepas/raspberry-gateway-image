#!/bin/bash

echo "Do modification for rpi hat (to take control of /dev/ttyAMA0 instead of onboard bluetooth chip"
if grep -Fq "console=serial0,115200 console=tty1" /boot/cmdline.txt
then
  sed -i 's/console=serial0,115200 console=tty1 //g' /boot/cmdline.txt
else
  echo "Cannot update cmdline.txt"
  exit 1
fi

if test -f /boot/config.txt
then
  echo "dtoverlay=pi3-disable-bt" >> /boot/config.txt
  echo "dtoverlay=pi3-miniuart-bt" >> /boot/config.txt
else
  echo "Cannot update config.txt"
  exit 1
fi

echo "disable related services"
systemctl disable hciuart.service
