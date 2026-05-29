#!/bin/bash
mount_alos() {
if [ ! -d system_mount ]; then
 mkdir system_mount
fi
sudo mount -o loop alos.img system_mount
read -p "Make all your modifications and then press enter"
sudo umount alos.img
rm -rf system_mount
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    mount_alos
fi
