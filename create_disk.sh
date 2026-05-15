SUPER_IMAGE=super_alos.img
read -p "Start? It will ocuppy in the process +20gb" -n1
dd if=/dev/zero of=super_disk.img bs=1M count=13000
sgdisk -n 1:2048:+64M   -c 1:"boot"          super_disk.img
sgdisk -n 2:0:+16M      -c 2:"dtbo"          super_disk.img
sgdisk -n 3:0:+8M       -c 3:"vbmeta"        super_disk.img
sgdisk -n 4:0:+8M       -c 4:"vbmeta_system" super_disk.img
sgdisk -n 5:0:0         -c 5:"super"         super_disk.img
sudo losetup -Pf super_disk.img
LOOP_DEV=$(losetup -a | grep "super_disk.img" | awk -F: '{print $1}' | head -n 1)
echo "Disk mapped to $LOOP_DEV."
sudo dd if=$SUPER_IMAGE of="${LOOP_DEV}p5" bs=4M status=progress
sudo losetup -d "$LOOP_DEV"
echo "Done!"
