#!/bin/bash
update_metadata() {
sudo losetup -Pf super_disk.img
LOOP_DEV=$(losetup -a | grep "super_disk.img" | awk -F: '{print $1}' | head -n 1)
if [ -z "$LOOP_DEV" ]; then
    echo "Error: Could not map super_disk.img to a loop device."
    exit 1
fi
sudo dd if=metadata.img of="${LOOP_DEV}p6" bs=4M status=progress
sync
sudo losetup -d "$LOOP_DEV"
echo "Super updated in disk!"
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    update_metadata
fi
