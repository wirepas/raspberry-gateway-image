#!/bin/bash -e

install -v -d  "${ROOTFS_DIR}/boot/wirepas"

install -m 755 files/docker-compose.yml	"${ROOTFS_DIR}/home/${FIRST_USER_NAME}/"

install -m 755 files/wirepasGatewayUpdate.service	"${ROOTFS_DIR}/etc/systemd/system/"

on_chroot << EOF
systemctl enable wirepasGatewayUpdate.service
EOF