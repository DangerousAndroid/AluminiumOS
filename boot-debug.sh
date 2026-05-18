#!/bin/bash
DISK="super_disk.img"
KERNEL="./p9pf/boot/kernel"
RAMDISK="./p9pf/vendor_boot/alos.cpio"
DTB="./dtb/alos.dtb"
CORES="12"
MEM="16G"
TRUSTY_BOOT="bl1.bin"
#######TODO, move this block ouside this file###########
if [ ! -d logs ]; then
 echo "Logs dir not created"
 mkdir -p logs
fi
rm -f ./logs/tee.log
touch ./logs/tee.log
#########################################################
echo "Launching AluminiumOS (Build CP1A.260305.018) with Trusty TEE..."
qemu-system-aarch64 \
  -M virt,gic-version=3,secure=on,virtualization=on \
  -cpu max \
  -smp $CORES \
  -m $MEM \
  -accel tcg,thread=multi \
  -bios $TRUSTY_BOOT \
  -semihosting-config enable=on,target=native \
  -kernel "$KERNEL" \
  -initrd "$RAMDISK" \
  -drive file=./RPMB_DATA,if=none,id=rpmb_drive,format=raw \
  -device virtio-blk-pci,drive=rpmb_drive,id=rpmb-disk \
  -device qemu-xhci,id=xhci,addr=05.0 \
  -drive file="$DISK",if=none,id=super_drive,format=raw \
  -device usb-storage,bus=xhci.0,drive=super_drive,id=super-disk \
  -append "earlycon=pl011,0x09000000 console=ttyAMA0 root=/dev/super rw init=/init androidboot.hardware=zumapro androidboot.boot_devices=4010000000.pcie androidboot.boot_devices=pci0000:00/0000:00:05.0 androidboot.selinux=permissive androidboot.lcd_density=160 androidboot.super_partition=super androidboot.force_normal_boot=1 androidboot.vbmeta.device_state=unlocked androidboot.verifiedbootstate=orange loglevel=8 init_debug_loglevel=8 androidboot.init_rc_debug=1 androidboot.logd.kernel=true" \
  -device virtio-gpu-gl-pci \
  -display gtk,gl=on \
  -device virtio-tablet-pci \
  -device virtio-keyboard-pci \
  -netdev user,id=net0 \
  -device virtio-net-pci,netdev=net0 \
  -serial stdio \
  -serial file:./logs/tee.log \
  -device virtio-serial-pci,id=virtio-serial0 \
  -device virtserialport,name=com.android.emulator.secure_env,id=vc_secure_env \
  -monitor none
