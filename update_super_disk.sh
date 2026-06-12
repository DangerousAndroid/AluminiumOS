#!/bin/bash
update_super_disk() {
sudo losetup -Pf super_disk.img
LOOP_DEV=$(losetup -a | grep "super_disk.img" | awk -F: '{print $1}' | head -n 1)
if [ -z "$LOOP_DEV" ]; then
    log_echo "Error: Could not map super_disk.img to a loop device."
    exit 1
fi
sudo dd if=super_alos.img of="${LOOP_DEV}p5" bs=4M status=progress
sync
sudo losetup -d "$LOOP_DEV"
rm -rf super_alos.img
log_success "Super updated in disk!"
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    . colors.sh || exit 255
    . logger.sh || exit 255
    update_super_disk
fi
