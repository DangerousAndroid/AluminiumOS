#!/bin/bash
create_vendor() {
VENDOR_FILES=p9pf/vendor
if [ -f p9pf/vendor.img ]; then
 if [ ! -d backup ]; then
  mkdir backup
 fi
 mv p9pf/vendor.img backup/vendor.img.old
fi
mke2fs -t ext2 -d ./p9pf/vendor p9pf/vendor.img 1300M
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    create_vendor
fi
