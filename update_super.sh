#!/bin/bash
sudo losetup -Pf super_disk.img
LOOP_DEV=$(losetup -a | grep "super_disk.img" | awk -F: '{print $1}' | head -n 1)
if [ -z "$LOOP_DEV" ]; then
    echo "Error: Could not map super_disk.img to a loop device."
    exit 1
fi
sudo dd if=super_alos.img of="${LOOP_DEV}p5" bs=4M status=progress
sync
sudo losetup -d "$LOOP_DEV"
echo "Super updated in disk!"
