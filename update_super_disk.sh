#!/bin/bash
update_super_disk() {
echo "Unsparsing super image..."
simg2img super_alos.img super_raw.img
echo "Writing super image to disk (offset 97M)..."
dd if=super_raw.img of=super_disk.img bs=1M seek=97 conv=notrunc status=progress
sync
rm -rf super_alos.img super_raw.img
log_success "Super updated in disk!"
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    ROOT_DIR=$(pwd)
    . colors.sh || exit 255
    . logger.sh || exit 255
    update_super_disk
fi
