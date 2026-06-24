#!/bin/bash
update_ctf_fstab() {
cd cuttlefish/vendor_boot
# Cuttlefish fstabs (name)
$MAGISKBOOT cpio alos.cpio "add 0750 first_stage_ramdisk/system/etc/fstab.cutf_cvm fstab.cutf_cvm"
# Cuttelefish fstabs (platform)
$MAGISKBOOT cpio alos.cpio "add 0750 first_stage_ramdisk/system/etc/fstab.vsoc_arm64 fstab.vsoc_arm64"
# Add default.prop
#magiskboot cpio alos.cpio "add 0750 prop.default prop.default"
# Add comet default.prop
$MAGISKBOOT cpio alos.cpio "add 0750 prop.default prop.comet.default"
cd $ROOT_DIR
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    . vars.sh || exit 255
    update_ctf_fstab
fi
