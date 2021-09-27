# Raspberry gateway image

The purpose of this repository is to create automatically a ready to use RaspberryPi image containing all the needed files to setup a Wirepas gateway.
This image allows to easily configure the Wirepas sink and transport services as well as sink parameters from files located in the FAT32 boot partition of the RaspberryPi which can be easily edited.
Other Raspeberry Pi parameters like Network settings, Wi-Fi and others setting are not modified by the image.

## How it works?

This image is based on Wirepas Gateway docker images that can be found on DockerHub.
The Raspberry base image is built with [RPi-Distro/pi-gen tool](https://github.com/RPi-Distro/pi-gen)

## How to customize gateway

TO BE MODIFIED

### wirepasSink1.service
This service manages the Wirepas Sink Service and is configured with the keys WM_GW_SINK_* from [gateway.env](templates/gateway.env) file.
This file must be copied under /boot/wirepas/ for the service to find it (after the image has been flashed to the SD-Card).

### wirepasTransport.service
This service manages the Wirepas Transport Service and is configured with the same [gateway.env](templates/gateway.env) file.
This file must be copied under /boot/wirepas/ for the service to find it (after the image has been flashed to the SD-Card).

To use the local MQTT broker installed previously, the following config can be done:
```ini
WM_SERVICES_MQTT_HOSTNAME=localhost
WM_SERVICES_MQTT_PORT=1883
WM_SERVICES_MQTT_USERNAME=
WM_SERVICES_MQTT_PASSWORD=
WM_SERVICES_MQTT_FORCE_UNSECURE=true
```

### wirepasConfigurator.service
This service can configure the sink parameters with values contained in [sink.env](templates/sink.env) file.
This service will run only if the file sink.env is copied in /boot/wirepas/ (after the image has been flashed to the SD-Card).

After a successful execution, the file is renamed sink.success in the SD-Card and won’t be executed again. You can edit this file later on and rename it as sink.env.
At next reboot the gateway will configure the sink again with these new parameters.


# How are released image built?

Images under [release tab](https://github.com/wirepas/raspberry-gateway-image/releases) are automatically build with github actions repository is tagged.

