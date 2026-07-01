#!/bin/bash
make_vendor_dlkm() {
if [ -f cuttlefish/vendor_dlkm.img ]; then
 if [ ! -d backup ]; then
  mkdir backup
 fi
 mv cuttlefish/vendor_dlkm.img backup/vendor_dlkm.img.old
fi
mke2fs -t ext4 -O ext_attr,has_journal,dir_index,sparse_super cuttlefish/vendor_dlkm.img 5M
e2fsdroid -e -S ./alos-gsi/system/etc/selinux/plat_file_contexts -f ./cuttlefish/vendor_dlkm -a /vendor_dlkm cuttlefish/vendor_dlkm.img
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    make_vendor_dlkm
fi
