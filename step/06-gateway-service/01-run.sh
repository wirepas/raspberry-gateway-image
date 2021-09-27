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

echo "Execute install script"
on_chroot << EOF
systemctl enable wirepasGatewayUpdate.service

systemctl enable wirepasSinkConfigurator.service

cd /home/${FIRST_USER_NAME}
# Download all images to speed up first boot and generate tar file out of it
./download-frozen-image-v2.sh transport_service wirepas/gateway_transport_service:latest
tar -cC 'transport_service' -f transport_service.tar .
rm -rf transport_service

./download-frozen-image-v2.sh sink_service wirepas/gateway_sink_service:latest
tar -cC 'sink_service' -f sink_service.tar .
rm -rf sink_service

./download-frozen-image-v2.sh dbus_service wirepas/gateway_dbus_service:latest
tar -cC 'dbus_service' -f dbus_service.tar .
rm -rf dbus_service

rm download-frozen-image-v2.sh

EOF