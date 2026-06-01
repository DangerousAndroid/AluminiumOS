#!/bin/bash
make_vendor_dlkm() {
if [ -f cuttlefish/vendor_dlkm.img ]; then
 if [ ! -d backup ]; then
  mkdir backup
 fi
 mv cuttlefish/vendor_dlkm.img backup/vendor_dlkm.img.old
fi
mke2fs -t ext2 -d ./cuttlefish/vendor_dlkm cuttlefish/vendor_dlkm.img 5M
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    make_vendor_dlkm
fi
