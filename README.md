# Raspberry gateway image

The purpose of this repository is to create automatically a ready to use Raspberry Pi image containing all the needed files to setup a Wirepas gateway.
This image allows to easily configure the Wirepas sink and transport services as well as sink parameters from files located in the FAT32 boot partition of the Raspberry Pi which can be easily edited.
Other Raspeberry Pi parameters like Network settings, Wi-Fi and others setting are not modified by the image.

## How it works?

The Raspberry base image is built with official [RPi-Distro/pi-gen](https://github.com/RPi-Distro/pi-gen) tool.

On top of it, this image is customized with Docker tool to allow the usage of Wirepas gateway docker images that can be found on DockerHub.


## How to configure the gateway

In a standard configuration with one sink attached to the gateway and the gateway publishing to a single broker, the gateway can be configured with the file [gateway.env](templates/gateway.env).
This file must be adapted to reflect your setup and copied under /boot/wirepas (after the image has been flashed to the SD-Card).

### Gateway version
GATEWAY_TAG key allows you to specify a new version of gateway.
Editing this key will allow you to switch to a newer version in future without the need to reflash the base image. Only a reboot is needed.
If latest tag is used (by default), gateway will be automatically updated at each new release.

### Sink configuration
Keys starting with WM_GW_SINK_* are related to sink configuration.

### Transport configuration
Keys starting with WM_SERVICES_MQTT_* are related to broker configuration

To use the local MQTT broker installed previously, the following config can be set:
```ini
WM_SERVICES_MQTT_HOSTNAME=localhost
WM_SERVICES_MQTT_PORT=1883
WM_SERVICES_MQTT_USERNAME=
WM_SERVICES_MQTT_PASSWORD=
WM_SERVICES_MQTT_FORCE_UNSECURE=true
```

## How to interact locally with gateway
All the following commands, required to be connected to a console on the gateway (through SSH).

## Connecting with SSH
By default, SSH is enabled on this image with following credentials:

Login  | Password
----   | --------
wirepas| wirepas**s**

Hostname is set to **wirepasgw**

## Get the logs
From wirepas user root folder, execute this command:
```bash
docker-compose logs
```

## Observe traffic on dbus
To observe packets received from sink(s) on dbus, execute this command:
```bash
docker run --rm -v wirepas_dbus-volume:/var/run/dbus -ti wirepas/gateway_transport_service wm-dbus-print
```

## Get/set sink(s) configuration
To see the current sink(s) configuration, please execute this command:
```bash
docker run --rm -v wirepas_dbus-volume:/var/run/dbus wirepas/gateway_transport_service wm-node-conf list
```

wm-node-conf allows to configure sink locally too. To see its usage and different options, execute this command:
```bash
docker run --rm -v wirepas_dbus-volume:/var/run/dbus wirepas/gateway_transport_service wm-node-conf
```

For example, following command allows you to stop a sink named sink1:
```bash
docker run --rm -v wirepas_dbus-volume:/var/run/dbus wirepas/gateway_transport_service wm-node-conf set -s sink1 -S False
```

# How are released image built?

Images under [release tab](https://github.com/wirepas/raspberry-gateway-image/releases) are automatically build with github actions when repository is tagged.

