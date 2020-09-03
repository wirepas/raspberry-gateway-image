#!/bin/bash

# Reference base image
REF_IMAGE_URL="https://downloads.raspberrypi.org/"
REF_IMAGE_NAME="raspios_lite_armhf_latest"

# Get raspberry image
wget ${REF_IMAGE_URL}${REF_IMAGE_NAME}
unzip ${REF_IMAGE_NAME}

# Get image file name
IMAGE_FILE=$(ls *.img)

ls -l ${IMAGE_FILE}

# Mount the image to update it
TMP=$(mktemp -d)
LOOP=$(losetup --show -fP "${IMAGE_FILE}")
mount ${LOOP}p2 $TMP
mount ${LOOP}p1 $TMP/boot/

# copy Wirepas binaries and copy all scripts from repo
# Create wirepas folder to test
mkdir $TMP/home/pi/wirepas

echo "File before copy"
ls -l wirepasSink1.service
cat wirepasSink1.service
cp wirepasSink1.service $TMP/etc/systemd/system/wirepasSink1.service
echo "File once copied"
ls -l $TMP/etc/systemd/system/wirepasSink1.service
cat $TMP/etc/systemd/system/wirepasSink1.service
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

echo "Files copied, unmounting image"
# Check file content:
cat 

# Umount partitions
umount $TMP/boot/
umount $TMP
rmdir $TMP

ls -l ${IMAGE_FILE}

# Zip back the image to be saved as artefact
zip rpi_wirepas_gw ${IMAGE_FILE}