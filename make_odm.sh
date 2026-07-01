#!/bin/bash
make_odm() {
if [ -f cuttlefish/odm.img ]; then
 if [ ! -d backup ]; then
  mkdir backup
 fi
 mv cuttlefish/odm.img backup/odm.img.old
fi
cat ./alos-gsi/system/etc/selinux/plat_file_contexts ./cuttlefish/odm/etc/selinux/odm_file_contexts > combined_odm_fc.tmp
mke2fs -t ext4 -O ext_attr,has_journal,dir_index,sparse_super cuttlefish/odm.img 360M
e2fsdroid -e -S combined_odm_fc.tmp -f ./cuttlefish/odm -a /odm cuttlefish/odm.img
rm -f combined_odm_fc.tmp
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    make_odm
fi
