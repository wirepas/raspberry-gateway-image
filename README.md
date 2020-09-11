# Raspberry gateway image
 
The purpose of this repository is to create automatically a raspberry image containing all the needed files to setup a Wirepas gateway.

# How it works?

## create_image.sh
The entry point for this repository is the [create_image.sh](create_image.sh) script.
This script downloads an official Raspberry pi image and mounts it as a loopback to modify some files and add new ones.

Here is the list of modifications done:

1. Enabling ssh by default
An empty file ssh is copied under /boot/ to enable ssh connection.
Default login/password are not modified and must be modified in case this gateway is deployed on a public network.

2. Modification to use /dev/ttyAMA0
Raspberry pi has a real uart that is by default used for th eon board bluetooth chip.
/boot/cmdline.txt and /boot/config.txt are modified to release it.

3. Add multiple systemd job files to create a Wirepas gateway
They are described in next chapter

4. Install a mosquitto broker in order to ease a simple testing (this broker can be used to see the gateway traffic)

## Systemd services

### wirepasFirstboot.service
This service  is in charge of calling the [firstboot.sh](firstboot.sh) script to install the gateway.
It requires a connection to internet in order to work.
It will be started in loop every 10 sec until it succeede (ie, a connection to internet is available).
When it has successfully run (it takes 3 to 5 minutes), following systemd job are started and the rpi is rebooted.
It will never run agin.

The script [firstboot.sh](firstboot.sh) could be used on any debian based linux to install a Wirepas gateway.

### wirepasSink1.service
This service manages the Wirepas Sink Service and is configured with the keys WM_GW_SINK_* from [gateway.env](templates/gateway.env) file.
This file must be copied under /boot/wirepas/ for the service to find it.

### wirepasTransport.service
This service manages the Wirepas Transport Service and is configured with the same [gateway.env](templates/gateway.env) file.
This file must be copied under /boot/wirepas/ for the service to find it.

To use the internal gateway broker installed previously, the following config can be done:
'''
WM_SERVICES_MQTT_HOSTNAME=localhost
WM_SERVICES_MQTT_PORT=1883
WM_SERVICES_MQTT_USERNAME=
WM_SERVICES_MQTT_PASSWORD=
WM_SERVICES_MQTT_FORCE_UNSECURE=true
'''

### wirepasConfigurator.service
This service can configure the sink parameters with values contained in [sink.env](templates/sink.env) file.
This service will run only if the file sink.env is copied in /boot/wirepas


# How are released image built?

Images under [release tab](https://github.com/wirepas/raspberry-gateway-image/releases) are automatically build with github actions repository is tagged. 

