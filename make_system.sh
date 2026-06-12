#!/bin/bash
make_system() {
if [ -f alos.img ]; then
 if [ ! -d backup ]; then
  mkdir backup
 fi
 mv alos.img backup/alos.img.old
fi
unpack_alos_files
mke2fs -t ext4 -O ext_attr,has_journal,dir_index,sparse_super -d ./alos-gsi alos.img 6G
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    ROOT_DIR=$(pwd)
    . colors.sh || exit 255
    . unpack_alos_files.sh || exit 255
    make_system
fi
