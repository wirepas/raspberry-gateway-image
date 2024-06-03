#!/bin/bash -e

echo "Create wirepas folder on boot"
install -v -d "${ROOTFS_DIR}/boot/wirepas"

echo "Add docker compose to home folder"
install -m 755 files/docker-compose.yml	"${ROOTFS_DIR}/home/${FIRST_USER_NAME}/"

echo "Add systemd service to start Gateway at boot time"
install -m 644 files/wirepasGatewayUpdate.service	"${ROOTFS_DIR}/etc/systemd/system/"

echo "Add systemd service to configure sink at boot time"
install -m 644 files/wirepasSinkConfigurator.service	"${ROOTFS_DIR}/etc/systemd/system/"

echo "Add script to preload images without docker installed"
install -m 755 files/download-frozen-image-v2.sh  "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/"

echo "Add mosquitto config to accept ws connection"
install -m 644 files/config_ws_tcp.conf	"${ROOTFS_DIR}/etc/mosquitto/conf.d/"

echo "Execute install script"
on_chroot << EOF
systemctl enable wirepasGatewayUpdate.service

systemctl enable wirepasSinkConfigurator.service

EOF
