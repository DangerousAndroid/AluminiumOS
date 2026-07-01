#!/bin/bash
make_vendor() {
log_info "Searching for backup"
if [ -f cuttlefish/vendor.img ]; then
 if [ ! -d backup ]; then
  mkdir backup
 fi
 mv cuttlefish/vendor.img backup/vendor.img.old
fi
 cat ./alos-gsi/system/etc/selinux/plat_file_contexts ./cuttlefish/vendor/etc/selinux/vendor_file_contexts > combined_vendor_fc.tmp
 mke2fs -t ext4 -O ext_attr,has_journal,dir_index,sparse_super cuttlefish/vendor.img 1300M
 e2fsdroid -e -S combined_vendor_fc.tmp -f ./cuttlefish/vendor -a /vendor cuttlefish/vendor.img
 rm -f combined_vendor_fc.tmp
 log_success "Vendor image built"
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    ROOT_DIR=$(pwd)
    . colors.sh || exit 255
    . logger.sh || exit 255
    make_vendor
fi
