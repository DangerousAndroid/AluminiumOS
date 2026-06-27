#!/bin/bash
create_disk() {
echo "Creating empty disk image..."
dd if=/dev/zero of=super_disk.img bs=1M count=13000 status=progress
echo "Partitioning disk..."
sgdisk -n 1:2048:+64M   -c 1:"boot"          super_disk.img
sgdisk -n 2:0:+16M      -c 2:"dtbo"          super_disk.img
sgdisk -n 3:0:+8M       -c 3:"vbmeta"        super_disk.img
sgdisk -n 4:0:+8M       -c 4:"vbmeta_system" super_disk.img
sgdisk -n 5:0:0         -c 5:"super"         super_disk.img
echo "Writing super image to disk (offset 97M)..."
dd if=super_alos.img of=super_disk.img bs=1M seek=97 conv=notrunc status=progress
log_success "Done!"
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    . vars.sh || exit 255
    . colors.sh || exit 255
    . logger.sh || exit 255
    create_disk
fi
