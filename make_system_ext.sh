#!/bin/bash
make_system_ext() {
if [ -f cuttlefish/system_ext.img ]; then
 if [ ! -d backup ]; then
  mkdir backup
 fi
 mv cuttlefish/system_ext.img backup/vendor.img.old
fi
mke2fs -t ext2 -d ./cuttlefish/system_ext cuttlefish/system_ext.img 1300M
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    make_system_ext
fi
