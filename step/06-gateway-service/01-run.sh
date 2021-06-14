#!/bin/bash -e

echo "Create wirepas folder on boot"
install -v -d  "${ROOTFS_DIR}/boot/wirepas"

echo "Add docker compose to home folder"
install -m 755 files/docker-compose.yml	"${ROOTFS_DIR}/home/${FIRST_USER_NAME}/"

echo "Add systemd service to start Gateway at boot time"
install -m 755 files/wirepasGatewayUpdate.service	"${ROOTFS_DIR}/etc/systemd/system/"

echo "Execute install script"
on_chroot << EOF
systemctl enable wirepasGatewayUpdate.service

# To speed up first build, checkout latest tag
docker-compose -f /home/${FIRST_USER_NAME}/docker-compose.yml pull
EOF