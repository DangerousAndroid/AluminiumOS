#!/bin/bash
create_disk() {
echo "Creating empty disk image..."
dd if=/dev/zero of=super_disk.img bs=1M count=15500 status=progress
echo "Partitioning disk..."
if command -v sgdisk >/dev/null 2>&1; then
  sgdisk -n 1:2048:+64M   -c 1:"boot"          super_disk.img
  sgdisk -n 2:0:+16M      -c 2:"dtbo"          super_disk.img
  sgdisk -n 3:0:+8M       -c 3:"vbmeta"        super_disk.img
  sgdisk -n 4:0:+8M       -c 4:"vbmeta_system" super_disk.img
  sgdisk -n 5:0:+12288M   -c 5:"super"         super_disk.img
  sgdisk -n 6:0:+1024M    -c 6:"metadata"      super_disk.img
  sgdisk -n 7:0:0         -c 7:"userdata"      super_disk.img
else
  sfdisk super_disk.img <<EOF
label: gpt
unit: sectors

super_disk.img1 : start=2048, size=131072, name="boot"
super_disk.img2 : size=32768, name="dtbo"
super_disk.img3 : size=16384, name="vbmeta"
super_disk.img4 : size=16384, name="vbmeta_system"
super_disk.img5 : size=25165824, name="super"
super_disk.img6 : size=2097152, name="metadata"
super_disk.img7 : name="userdata"
EOF
fi
echo "Writing super image to disk (offset 97M)..."
dd if=super_alos.img of=super_disk.img bs=1M seek=97 conv=notrunc status=progress
if [ -f metadata.img ]; then
  echo "Writing metadata image to disk (offset 12385M)..."
  dd if=metadata.img of=super_disk.img bs=1M seek=12385 conv=notrunc status=progress
fi
if [ -f userdata.img ]; then
  echo "Writing userdata image to disk (offset 13409M)..."
  dd if=userdata.img of=super_disk.img bs=1M seek=13409 conv=notrunc status=progress
fi
log_success "Done!"
}
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    . vars.sh || exit 255
    . colors.sh || exit 255
    . logger.sh || exit 255
    create_disk
fi
