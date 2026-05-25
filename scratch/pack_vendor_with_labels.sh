#!/bin/bash
set -e

echo "1. Creating compatible ext4 filesystem for vendor.img..."
mke2fs -t ext4 -O ^metadata_csum,^metadata_csum_seed,^orphan_file,^64bit -F -d ./p9pf/vendor p9pf/vendor.img 1300M

echo "2. Mounting vendor.img..."
mkdir -p mnt_vendor
sudo mount -o loop p9pf/vendor.img mnt_vendor

echo "3. Applying SELinux labels using python helper..."
# Trap to ensure we unmount even if the python script fails
trap 'echo "Unmounting vendor.img..."; sudo umount mnt_vendor || true; rmdir mnt_vendor || true' EXIT

sudo python3 scratch/label_vendor.py mnt_vendor p9pf/vendor/etc/selinux/vendor_file_contexts

echo "4. Done! vendor.img compiled and labeled successfully."
