#!/bin/bash
make_system_dlkm() {
if [ -f cuttlefish/system_dlkm.img ]; then
 if [ ! -d backup ]; then
  mkdir backup
 fi
 mv cuttlefish/system_dlkm.img backup/system_dlkm.img.old
fi
mke2fs -t ext2 -d cuttlefish/system_dlkm cuttlefish/system_dlkm.img 300M
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    make_system_dlkm
fi
