#!/bin/bash
update_fstab() {
ROOT_DIR=$(pwd)
cd comet/vendor_boot
magiskboot cpio alos.cpio "add 0750 first_stage_ramdisk/system/etc/fstab.zuma-fips fstab.zuma-fips" && magiskboot cpio alos.cpio "add 0750 first_stage_ramdisk/system/etc/fstab.zuma fstab.zuma" && magiskboot cpio alos.cpio "add 0750 first_stage_ramdisk/system/etc/fstab.zumapro-fips fstab.zumapro-fips" && magiskboot cpio alos.cpio "add 0750 first_stage_ramdisk/system/etc/fstab.zumapro fstab.zumapro" && magiskboot cpio alos.cpio "add 0750 system/etc/recovery.fstab recovery.fstab"
cd $ROOT_DIR
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    update_fstab
fi
