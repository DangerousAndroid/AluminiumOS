#!/bin/bash
make_vendor() {
log_info "Searching for backup"
if [ -f cuttlefish/vendor.img ]; then
 if [ ! -d backup ]; then
  mkdir backup
 fi
 mv cuttlefish/vendor.img backup/vendor.img.old
fi
mke2fs -t ext4 -O ext_attr,has_journal,dir_index,sparse_super -d ./cuttlefish/vendor cuttlefish/vendor.img 1300M
log_success "Vendor image built"
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    ROOT_DIR=$(pwd)
    . colors.sh || exit 255
    . logger.sh || exit 255
    make_vendor
fi
