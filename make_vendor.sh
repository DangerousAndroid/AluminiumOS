#!/bin/bash
make_vendor() {
if [ -f comet/vendor.img ]; then
 if [ ! -d backup ]; then
  mkdir backup
 fi
 mv comet/vendor.img backup/vendor.img.old
fi
mke2fs -t ext2 -d ./comet/vendor comet/vendor.img 1300M
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    make_vendor
fi
