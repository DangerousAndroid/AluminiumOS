#!/bin/bash
boot_debug() {
DISK="super_disk.img"
KERNEL="./cuttlefish/boot/kernel"
RAMDISK="./comet/vendor_boot/debug.cpio"
DTB="./dtb/alos.dtb"
CORES="12"
MEM="16G"
echo "Launching AluminiumOS (Build CP1A.260305.018) without Trusty TEE..."
qemu-system-aarch64 \
  -M virt,gic-version=3 \
  -cpu max,sve=off \
  -smp $CORES \
  -m $MEM \
  -accel tcg,thread=multi \
  -kernel "$KERNEL" \
  -initrd "$RAMDISK" \
  -dtb "$DTB" \
  -device qemu-xhci,id=xhci,addr=05.0 \
  -drive file="$DISK",if=none,id=super_drive,format=raw \
  -device virtio-blk-pci,drive=super_drive,id=super-disk,addr=04.0 \
  -append "earlycon=pl011,0x09000000 console=ttyAMA0 rw init=/init androidboot.boot_devices=a003e00.virtio,a003000.virtio,a000000.virtio,virtio0,virtio1,virtio2,virtio3 androidboot.selinux=permissive androidboot.lcd_density=160 androidboot.super_partition=super loglevel=8 init_debug_loglevel=8 androidboot.init_rc_debug=1 androidboot.logd.kernel=true androidboot.force_normal_boot=1 androidboot.vbmeta.device_state=unlocked androidboot.verifiedbootstate=orange kvm-arm.mode=none androidboot.first_stage_console=1 androidboot.init_fatal_reboot_target=console androidboot.veritymode=eio" \
  -device virtio-tablet-pci \
  -device virtio-gpu-gl-pci \
  -display gtk,gl=on \
  -device virtio-keyboard-pci \
  -serial mon:stdio \
  -device virtio-serial-pci,id=virtio-serial0 \
  -device virtserialport,name=com.android.emulator.secure_env,id=vc_secure_env \
  -monitor none
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    boot_debug
fi
