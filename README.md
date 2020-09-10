# Raspberry gateway image

WIP 
The purpose of this repository is to create automatically a raspberry image containing all the needed files for a Wirepas gateway.

## How to setup a raspberry Wirepas gateway

You need a raspberry board connected to internet. It can be through ethernet cable or you can configure the Wifi at first boot.

### Download image
Go to the release tab and download the right image
### Flash image
Flash the image with etcher for example (link)
### Customize
Plug the sdcard to your PC to access boot partition (can be seen on any OS).
From templates folder, copy both .env files to reflect your settings to /boot/wirepas/
Put the SDcard into your raspberry and boot.

## How it works
### How is this image built
### How does it work in practice
