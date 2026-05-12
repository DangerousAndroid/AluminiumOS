#!/bin/bash
GSI="alos.img"
KERNEL="./p9pf/boot/kernel"
RAMDISK="./p9pf/init_boot/ramdisk.cpio.img"
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
  -drive file="$GSI",if=virtio,format=raw,readonly=on \
  -append "root=/dev/vda rw init=/init console=ttyAMA0 androidboot.hardware=virtio androidboot.boot_devices=pci0000:00/0000:00:05.0 androidboot.selinux=permissive androidboot.lcd_density=160" \
  -device virtio-gpu-gl-pci \
  -display gtk,gl=on \
  -device virtio-tablet-pci \
  -device virtio-keyboard-pci \
  -netdev user,id=net0 \
  -device virtio-net-pci,netdev=net0 \
  -serial stdio
