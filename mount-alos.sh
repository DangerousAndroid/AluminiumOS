#!/bin/bash
if [ ! -d system_mount ]; then
 mkdir system_mount
fi
sudo mount -o loop alos.img system_mount
read -p "Make all your modifications and then press enter"
sudo umount alos.img
rm -rf system_mount
