#!/bin/bash
update_fstab() {
cd comet/vendor_boot
# Cuttlefish fstabs (stock ones)
#magiskboot cpio alos.cpio "add 0750 first_stage_ramdisk/system/etc/fstab.cf.ext4.cts fstab.cf.ext4.cts" && magiskboot cpio alos.cpio "add 0750 first_stage_ramdisk/system/etc/fstab.cf.ext4.hctr2 fstab.cf.ext4.hctr2" && magiskboot cpio alos.cpio "add 0750 first_stage_ramdisk/system/etc/fstab.cf.f2fs.cts fstab.cf.f2fs.cts" && magiskboot cpio alos.cpio "add 0750 first_stage_ramdisk/system/etc/fstab.cf.f2fs.hctr2 fstab.cf.f2fs.hctr2"
# Comet/zuma fstabs (deprecated due to using cuttlefish ones now but still usable witb comet vendor)
$MAGISKBOOT cpio alos.cpio "add 0750 first_stage_ramdisk/system/etc/fstab.zuma fstab.zuma" && $MAGISKBOOT cpio alos.cpio "add 0750 first_stage_ramdisk/system/etc/fstab.zuma-fips fstab.zuma-fips" && $MAGISKBOOT cpio alos.cpio "add 0750 first_stage_ramdisk/system/etc/fstab.zumapro fstab.zumapro" && $MAGISKBOOT cpio alos.cpio "add 0750 first_stage_ramdisk/system/etc/fstab.zumapro-fips fstab.zumapro-fips" && $MAGISKBOOT cpio alos.cpio "add 0750 first_stage_ramdisk/system/etc/recovery.fstab recovery.fstab"
# Cuttelefish fstabs (modified ones)
$MAGISKBOOT cpio alos.cpio "add 0750 first_stage_ramdisk/system/etc/fstab.vsoc_arm64 fstab.vsoc_arm64"
log_success "Fstab updated"
cd $ROOT
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    . vars.sh || exit 255
    . colors.sh || exit 255
    . logger.sh || exit 255
    update_fstab
fi
