#!/bin/bash
dd if=/dev/zero of=metadata.img bs=1M count=64
mkfs.ext4 metadata.img
mkdir -p mnt_metadata
sudo mount -o loop metadata.img mnt_metadata
sudo mkdir -p mnt_metadata/aconfig/maps
sudo mkdir -p mnt_metadata/aconfig/boot
sudo chmod -R 777 mnt_metadata/aconfig
sudo umount mnt_metadata
rmdir mnt_metadata
echo "Metadata created!"
sudo losetup -Pf super_disk.img
LOOP_DEV=$(losetup -a | grep "super_disk.img" | awk -F: '{print $1}' | head -n 1)
sudo dd if=metadata.img of="${LOOP_DEV}p6" bs=4M status=progress
sudo losetup -d "$LOOP_DEV"
echo "Metadata Flashed to disk!"
