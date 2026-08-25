#!/bin/bash
make_system_ext() {
if [ -f cuttlefish/system_ext.img ]; then
 if [ ! -d backup ]; then
  mkdir backup
 fi
 mv cuttlefish/system_ext.img backup/vendor.img.old
fi
mke2fs -t ext4 -O ext_attr,has_journal,dir_index,sparse_super cuttlefish/system_ext.img 600M
e2fsdroid -e -S ./cuttlefish/unified_plat_file_contexts -f ./alos-gsi/system/system_ext -a /system_ext cuttlefish/system_ext.img
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    make_system_ext
fi
