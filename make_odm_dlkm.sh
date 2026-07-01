#!/bin/bash
make_odm_dlkm() {
if [ -f cuttlefish/odm_dlkm.img ]; then
 if [ ! -d backup ]; then
  mkdir backup
 fi
 mv cuttlefish/odm_dlkm.img backup/odm_dlkm.img.old
fi
mke2fs -t ext4 -O ext_attr,has_journal,dir_index,sparse_super cuttlefish/odm_dlkm.img 360M
e2fsdroid -e -S ./alos-gsi/system/etc/selinux/plat_file_contexts -f ./cuttlefish/odm_dlkm -a /odm_dlkm cuttlefish/odm_dlkm.img
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    make_odm_dlkm
fi
