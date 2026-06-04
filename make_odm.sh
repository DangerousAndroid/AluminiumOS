#!/bin/bash
make_odm() {
if [ -f cuttlefish/odm.img ]; then
 if [ ! -d backup ]; then
  mkdir backup
 fi
 mv cuttlefish/odm.img backup/odm.img.old
fi
mke2fs -t ext2 -d ./cuttlefish/odm cuttlefish/odm.img 360M
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    make_odm
fi
