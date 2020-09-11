# Raspberry gateway image
 
The purpose of this repository is to create automatically a raspberry image containing all the needed files to setup a Wirepas gateway.

## How to setup a raspberry Wirepas gateway

You need a raspberry board connected to internet. It can be through ethernet cable or you can configure the Wifi at first boot.

### Download image

Official images can be found in the [release tab](https://github.com/wirepas/raspberry-gateway-image/releases).
Download the appropriate one and unzip it to get access to the .img file.

### Flash the image

Flash the image (with .img extension) to your SD card. You can do it with [balenaEtcher](https://www.balena.io/etcher/) software for example.

### Customize

Once flashed you can customized your image.
Plug the sdcard to your PC to access the boot partition (can be seen on any OS).

#### Broker settings and serial configuration

The MQTT broker to use by the gateway must be configured.
From [templates folder](templates), copy gateway.env file to /boot/wirepas/ and customize the different settings.

You must also customize the sink service part to reflect the sink you attached to the gateway.
If your sink is flashed from official dualmcu_app release serial baudrate is 125000.
And UART_PORT will depend on the hardware you use.
For example:
Hardware | Port
-------- | --------
Raspberry Pi hat | /dev/ttyAMA0
Nordic Evaluation Kit | /dev/ttyACM0


#### Sink initial settings (optional)
You can give an initial configuration to your sink to immediatly be ready for your deployed network.
From [templates folder](templates), copy sink.env file to /boot/wirepas/ and customize the different settings.

#### Wifi initial settings (optional)
As on any official Rpi image you can customize Wifi settings by adding a file in /boot partition as explained [here](https://www.raspberrypi.org/documentation/configuration/wireless/headless.md)
Alternativly you can configure it later on from the UI or through SSH and raspi-config

## How it works
WIP
### How is this image built
### How does it work in practice
