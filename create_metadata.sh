#!/bin/bash
create_metadata() {
truncate -s +1G super_disk.img
sgdisk -e super_disk.img
sgdisk -n 6:0:0 -c 6:"metadata" super_disk.img
dd if=/dev/zero of=metadata.img bs=1M count=1024
mkfs.ext4 -F metadata.img
update_metadata
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    . update_metadata.sh || exit 255
    create_metadata
fi
