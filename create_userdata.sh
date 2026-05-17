#!/bin/bash
truncate -s +4G super_disk.img
sgdisk -e super_disk.img
sgdisk -n 7:0:0 -c 7:"userdata" super_disk.img
dd if=/dev/zero of=userdata.img bs=1M count=4096
mkfs.ext4 -F userdata.img
