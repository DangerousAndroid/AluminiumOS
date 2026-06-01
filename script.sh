#!/bin/bash
## This script its the main script that will execute everything in the project ##

# Init comprobations
TRUSTY=0
DEBUG=0
ROOT_DIR=$(pwd)
MAGISKBOOT=bin/magiskboot

if [ "$1" = "-d" ] || [ "$2" = "-d" ]; then
 DEBUG=1
fi
if [ "$1" = "-t" ] || [ "$2" = "-t" ]; then
 TRUSTY=1
fi
if [ ! -d logs ]; then
 mkdir logs
 touch logs/script.log
fi

# Init logger function
log() {
 echo "$1" >> logs/script.log
}
echo "-----------INIT ALOS SCRIPT-----------" >> logs/script.log
date >> logs/script.log

# load helper scripts WITHOUT loops
. create_disk.sh || exit 255
. apply_modifications || exit 255
. boot_debug.sh || exit 255
. boot_no_trusty.sh || exit 255
. boot_trusty.sh || exit 255
. celan_boot_hals.sh || exit 255
. clean_boot_hals_2.sh || exit 255
. create_disk.sh || exit 255
. create_metadata.sh || exit 255
. create_userdata.sh || exit 255
. make_vendor.sh || exit 255
. make_super.sh || exit 255
. mount_alos.sh || exit 255
. move_keymint.sh || exit 255
. move_trusty.sh || exit 255
. sed_keystore.sh || exit 255
. unpack_trusty.sh || exit 255
. update_fstab.sh || exit 255
. update_metadata.sh || exit 255
. update_super_disk.sh || exit 255
. update_userdata.sh || exit 255
. update_system_dlkm.sh || exit 255
. make_system_dlkm.sh || exit 255
. make_system_ext.sh || exit 255
. make_vendor_dlkm.sh || exit 255
. make_product.sh || exit 255
. update_modules.sh || exit 255
. colors.sh || exit 255

# Init scripts for the first time running it

init() {
 QEMU=$(which qemu-system-aarch64)
 if [ -z $QEMU ]; then
  #TODO install qemu via package manager
  echo "QEMU not installed, installing it"
 fi
}

#WIP, rest of the code will be added soon
