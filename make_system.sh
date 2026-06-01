#!/bin/bash
make_system() {
if [ -f alos.img ]; then
 if [ ! -d backup ]; then
  mkdir backup
 fi
 mv alos.img backup/alos.img.old
fi
mke2fs -t ext2 -d ./alos alos.img 6G
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    make_system
fi
