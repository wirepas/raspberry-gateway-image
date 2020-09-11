#!/bin/bash

# Reference base image
if [ "$2" == "lite"]
then
  REF_IMAGE_NAME="raspios_lite_armhf_latest"
else
  REF_IMAGE_NAME="raspios_armhf_latest"
fi
echo "Base image is $REF_IMAGE_NAME

REF_IMAGE_URL="https://downloads.raspberrypi.org/"

# Get raspberry image
wget ${REF_IMAGE_URL}${REF_IMAGE_NAME}
unzip ${REF_IMAGE_NAME}

# Get image file name
IMAGE_FILE=$(ls *.img)

# Mount the image to update it
TMP=$(mktemp -d)
LOOP=$(losetup --show -fP "${IMAGE_FILE}")
mount ${LOOP}p2 $TMP
mount ${LOOP}p1 $TMP/boot/

# copy Wirepas binaries and copy all scripts from repo
# Create wirepas folder to test
mkdir $TMP/home/pi/wirepas

cp wirepasSink1.service $TMP/etc/systemd/system/wirepasSink1.service
cp wirepasTransport.service $TMP/etc/systemd/system/wirepasTransport.service
cp wirepasConfigurator.service $TMP/etc/systemd/system/wirepasConfigurator.service

# Copy script to be executed only the first time:
cp firstboot.sh $TMP/home/pi/wirepas
chmod +x $TMP/home/pi/wirepas/firstboot.sh

# Add systemd job to execute it at first boot
cp wirepasFirstboot.service $TMP/etc/systemd/system/wirepasFirstboot.service
# Enable this service manually
ln -s $TMP/lib/systemd/system/wirepasFirstboot.service $TMP/etc/systemd/system/multi-user.target.wants

# Create wirepas folder in boot
mkdir $TMP/boot/wirepas

# Enable ssh
touch $TMP/boot/ssh

# Do modification for rpi hat (to take control of /dev/ttyAMA0 instead of onboard bluetooth chip
if grep -Fq "console=serial0,115200 console=tty1" $TMP/boot/cmdline.txt
then
  sed -i 's/console=serial0,115200 console=tty1 //g' $TMP/boot/cmdline.txt
else
  echo "Cannot update cmdline.txt"
  exit 1
fi

if test -f $TMP/boot/config.txt
then
  echo "dtoverlay=pi3-disable-bt" >> $TMP/boot/config.txt
  echo "dtoverlay=pi3-miniuart-bt" >> $TMP/boot/config.txt
else
  echo "Cannot update config.txt"
  exit 1
fi

echo "Files copied, unmounting image"

# Umount partitions
umount $TMP/boot/
umount $TMP
rmdir $TMP

# Rename the .img file
mv ${IMAGE_FILE} ${1}.img

# Zip back the image to be saved as artefact
zip ${1}.zip ${1}.img
