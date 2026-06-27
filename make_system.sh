#!/bin/bash
make_system() {
log_info "Searching for backups"
if [ -f alos.img ]; then
 if [ ! -d backup ]; then
  mkdir backup
 fi
 mv alos.img backup/alos.img.old
fi
unpack_alos_files
mke2fs -t ext4 -O ext_attr,has_journal,dir_index,sparse_super alos.img 6G
e2fsdroid -e -S ./alos-gsi/system/etc/selinux/plat_file_contexts -f ./alos-gsi -a / alos.img
log_success "System image built"
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    ROOT_DIR=$(pwd)
    . colors.sh || exit 255
    . logger.sh || exit 255
    . unpack_alos_files.sh || exit 255
    make_system
fi
