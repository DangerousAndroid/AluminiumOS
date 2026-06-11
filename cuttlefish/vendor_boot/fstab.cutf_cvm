# test mount
/dev/block/vda                                           /super                      emmc    defaults                         defaults
#
# Non-dynamic, boot critical partitions
#/dev/block/by-name/boot /boot emmc defaults recoveryonly,first_stage_mount
#/dev/block/by-name/init_boot /init_boot emmc defaults recoveryonly,first_stage_mount
#/dev/block/by-name/vendor_boot /vendor_boot emmc defaults recoveryonly
system /system erofs ro wait,logical,first_stage_mount
system /system ext4 noatime,ro,errors=panic wait,logical,first_stage_mount
# Add all non-dynamic partitions except system, after this comment
/dev/block/by-name/userdata /data ext4 nodev,noatime,nosuid,errors=panic latemount,wait,check,quota,formattable,keydirectory=/metadata/vold/metadata_encryption
/dev/block/by-name/userdata /data ext4 nodev,noatime,nosuid,errors=panic latemount,reservedsize=128M,wait,check,quota,keydirectory=/metadata/vold/metadata_encryption
/dev/block/by-name/metadata /metadata ext4 nodev,noatime,nosuid wait,check,formattable,first_stage_mount
/dev/block/by-name/metadata /metadata ext4 nodev,noatime,nosuid wait,check,first_stage_mount
/dev/block/by-name/misc /misc emmc defaults defaults
# Add all dynamic partitions except system, after this comment
odm /odm erofs ro wait,logical,first_stage_mount
odm /odm ext4 noatime,ro,errors=panic wait,logical,first_stage_mount
# Do not fail on product and system_ext mount for any mixture with other products' system image
product /product erofs ro wait,logical,first_stage_mount,nofail
product /product ext4 noatime,ro,errors=panic wait,logical,first_stage_mount,nofail
system_ext /system_ext erofs ro wait,logical,first_stage_mount
system_ext /system_ext ext4 noatime,ro,errors=panic wait,logical,first_stage_mount
vendor /vendor erofs ro wait,logical,first_stage_mount
vendor /vendor ext4 noatime,ro,errors=panic wait,logical,first_stage_mount
vendor_dlkm /vendor_dlkm erofs ro wait,logical,first_stage_mount
vendor_dlkm /vendor_dlkm ext4 noatime,ro,errors=panic wait,logical,first_stage_mount
odm_dlkm /odm_dlkm erofs ro wait,logical,first_stage_mount
odm_dlkm /odm_dlkm ext4 noatime,ro,errors=panic wait,logical
system_dlkm /system_dlkm erofs ro wait,logical,first_stage_mount
system_dlkm /system_dlkm ext4 noatime,ro,errors=panic wait,logical,first_stage_mount
# ZRAM, SD-Card and virtiofs shares
/dev/block/zram0 none swap defaults zramsize=75%
/dev/block/vdc1 /sdcard vfat defaults recoveryonly
/devices/*/block/vdc auto auto defaults voldmanaged=sdcard1:auto,encryptable=userdata
shared /mnt/vendor/shared virtiofs nosuid,nodev,noatime nofail
