#!/bin/bash
mount_alos() {
if [ ! -d mount ]; then
 mkdir mount
fi
sudo mount -o loop alos.img mount
read -p "Make all your modifications and then press enter"
sudo umount alos.img
rm -rf mount
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    mount_alos
fi
