#!/bin/bash
boot_without_trusty() {
DISK="super_disk.img"
KERNEL="./p9pf/boot/kernel"
RAMDISK="./p9pf/vendor_boot/alos.cpio"
DTB="./dtb/alos.dtb"
CORES="12"
MEM="16G"
echo "Launching AluminiumOS (Build CP1A.260305.018) without Trusty TEE..."
# This version uses the general qemu bin from the package manager
qemu-system-aarch64 \
  -M virt,gic-version=3 \
  -cpu max,sve=off \
  -smp $CORES \
  -m $MEM \
  -accel tcg,thread=multi \
  -kernel "$KERNEL" \
  -device loader,file="$RAMDISK",addr=0x44000000,force-raw=on \
  -dtb "$DTB" \
  -drive file=./RPMB_DATA,if=none,id=rpmb_drive,format=raw \
  -device virtio-blk-pci,drive=rpmb_drive,id=rpmb-disk \
  -device qemu-xhci,id=xhci,addr=05.0 \
  -drive file="$DISK",if=none,id=super_drive,format=raw \
  -device usb-storage,bus=xhci.0,drive=super_drive,id=super-disk \
  -append "earlycon=pl011,0x09000000 console=ttyAMA0 root=/dev/super rw init=/init androidboot.hardware=zumapro androidboot.boot_devices=4010000000.pcie androidboot.boot_devices=pci0000:00/0000:00:05.0 androidboot.selinux=permissive androidboot.lcd_density=160 androidboot.super_partition=super loglevel=3	 androidboot.force_normal_boot=1 androidboot.vbmeta.device_state=unlocked androidboot.verifiedbootstate=orange kvm-arm.mode=none" \
  -device virtio-tablet-pci \
   -device virtio-gpu-gl-pci \
  -display gtk,gl=on \
  -device virtio-keyboard-pci \
  -serial mon:stdio \
  -serial file:./logs/tee.log \
  -device virtio-serial-pci,id=virtio-serial0 \
  -device virtserialport,name=com.android.emulator.secure_env,id=vc_secure_env \
  -monitor none
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    boot_without_trusty
fi
