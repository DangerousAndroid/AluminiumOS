#!/bin/bash
DISK="super_disk.img"
KERNEL="./p9pf/boot/kernel"
RAMDISK="./p9pf/vendor_boot/alos.cpio"
DTB="./dtb/alos.dtb"
CORES="12"
MEM="16G"

echo "Launching AluminiumOS (Build CP1A.260305.018)..."
qemu-system-aarch64 \
  -M virt,gic-version=3 \
  -cpu max \
  -smp $CORES \
  -m $MEM \
  -accel tcg,thread=multi \
  -kernel "$KERNEL" \
  -initrd "$RAMDISK" \
  -dtb "$DTB" \
  -device qemu-xhci,id=xhci,addr=05.0 \
  -drive file="$DISK",if=none,id=super_drive,format=raw \
  -device usb-storage,bus=xhci.0,drive=super_drive,id=super-disk \
  -append "earlycon=pl011,0x09000000 console=ttyAMA0 root=/dev/super rw init=/init androidboot.hardware=zumapro androidboot.boot_devices=4010000000.pcie androidboot.boot_devices=pci0000:00/0000:00:05.0 androidboot.selinux=permissive androidboot.lcd_density=160 androidboot.super_partition=super androidboot.force_normal_boot=1 androidboot.vbmeta.device_state=unlocked androidboot.verifiedbootstate=orange" \
  -device virtio-gpu-gl-pci \
  -display gtk,gl=on \
  -device virtio-tablet-pci \
  -device virtio-keyboard-pci \
  -netdev user,id=net0 \
  -device virtio-net-pci,netdev=net0 \
  -serial stdio \
  -monitor none
