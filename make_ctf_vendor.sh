#!/bin/bash
make_ctf_vendor() {
if [ -f cuttlefish/vendor.img ]; then
 if [ ! -d backup ]; then
  mkdir backup
 fi
 mv cuttlefish/vendor.img backup/vendor.img.old
fi
mke2fs -t ext2 -d ./cuttlefish/vendor cuttlefish/vendor.img 1300M
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    make_ctf_vendor
fi
