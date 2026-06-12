#!/bin/bash
create_userdata() {
truncate -s +4G super_disk.img
sgdisk -e super_disk.img
sgdisk -n 7:0:0 -c 7:"userdata" super_disk.img
dd if=/dev/zero of=userdata.img bs=1M count=4096
mkfs.ext4 -F userdata.img
update_userdata
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    . update_userdata.sh || exit 255
    create_userdata
fi
