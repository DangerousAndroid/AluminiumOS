#!/bin/bash
update_fstab() {
cd cuttlefish/vendor_boot
# Cuttlefish fstabs
magiskboot cpio alos.cpio "add 0750 first_stage_ramdisk/system/etc/fstab.cf.ext4.cts fstab.cf.ext4.cts" && magiskboot cpio alos.cpio "add 0750 first_stage_ramdisk/system/etc/fstab.cf.ext4.hctr2 fstab.cf.ext4.hctr2" && magiskboot cpio alos.cpio "add 0750 first_stage_ramdisk/system/etc/fstab.cf.f2fs.cts fstab.cf.f2fs.cts" && magiskboot cpio alos.cpio "add 0750 first_stage_ramdisk/system/etc/fstab.cf.f2fs.hctr2 fstab.cf.f2fs.hctr2"
# Comet/zuma fstabs
magiskboot cpio alos.cpio "add 0750 first_stage_ramdisk/system/etc/fstab.zuma fstab.zuma" && magiskboot cpio alos.cpio "add 0750 first_stage_ramdisk/system/etc/fstab.zuma-fips fstab.zuma-fips" && magiskboot cpio alos.cpio "add 0750 first_stage_ramdisk/system/etc/fstab.zumapro fstab.zumapro" && magiskboot cpio alos.cpio "add 0750 first_stage_ramdisk/system/etc/fstab.zumapro-fips fstab.zumapro-fips" && magiskboot cpio alos.cpio "add 0750 first_stage_ramdisk/system/etc/recovery.fstab recovery.fstab"
cd $ROOT_DIR
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    ROOT_DIR=$(pwd)
    update_fstab
fi
