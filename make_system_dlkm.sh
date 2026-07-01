#!/bin/bash
make_system_dlkm() {
if [ -f cuttlefish/system_dlkm.img ]; then
 if [ ! -d backup ]; then
  mkdir backup
 fi
 mv cuttlefish/system_dlkm.img backup/system_dlkm.img.old
fi
mke2fs -t ext4 -O ext_attr,has_journal,dir_index,sparse_super cuttlefish/system_dlkm.img 20M
e2fsdroid -e -S ./alos-gsi/system/etc/selinux/plat_file_contexts -f cuttlefish/system_dlkm -a /system_dlkm cuttlefish/system_dlkm.img
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    make_system_dlkm
fi
