#!/bin/bash
sudo losetup -Pf super_disk.img
LOOP_DEV=$(losetup -a | grep "super_disk.img" | awk -F: '{print $1}' | head -n 1)
sudo dd if=userdata.img of="${LOOP_DEV}p7" bs=4M status=progress
sync
sudo losetup -d "$LOOP_DEV"
rm -f userdata.img
echo "Userdata updated!"
