#!/bin/bash
boot_with_trusty() {
DISK="super_disk.img"
KERNEL="./comet/boot/kernel"
RAMDISK="./comet/vendor_boot/alos.cpio"
DTB="./dtb/alos.dtb"
CORES="12"
MEM="16G"
TRUSTY_BOOT="bl1.bin"
echo "Launching AluminiumOS (Build CP1A.260305.018) with Trusty TEE..."
$ROOT_DIR/bin/qemu-system-aarch64 \
  -M virt,gic-version=3,secure=on,virtualization=on \
  -cpu max,sve=off \
  -smp $CORES \
  -m $MEM \
  -accel tcg,thread=multi,tb-size=1024 \
  -bios $TRUSTY_BOOT \
  -semihosting-config enable=on,target=native \
  -kernel "$KERNEL" \
  -device loader,file="$RAMDISK",addr=0x44000000,force-raw=on \
  -dtb "$DTB" \
  -drive file=./RPMB_DATA,if=none,id=rpmb_drive,format=raw,cache=unsafe,aio=threads \
  -device virtio-blk-pci,drive=rpmb_drive,id=rpmb-disk \
  -device qemu-xhci,id=xhci,addr=05.0 \
  -drive file="$DISK",if=none,id=super_drive,format=raw,cache=unsafe,aio=threads \
  -device virtio-blk-pci,drive=super_drive,id=super-disk,addr=04.0 \
  -append "earlycon=pl011,0x09000000 console=ttyAMA0 root=/dev/super rw init=/init androidboot.hardware=zumapro androidboot.boot_devices=4010000000.pcie,pci0000:00/0000:00:04.0 androidboot.selinux=permissive androidboot.lcd_density=160 androidboot.super_partition=super loglevel=0 androidboot.force_normal_boot=1 androidboot.vbmeta.device_state=unlocked androidboot.verifiedbootstate=orange kvm-arm.mode=none" \
  -device virtio-tablet-pci \
  -device virtio-gpu-gl-pci,id=gpu0,addr=06.0,blob=true,max_outputs=1 \
  -display gtk,gl=on \
  -device virtio-keyboard-pci \
  -netdev user,id=net0,hostfwd=tcp::5555-:5555 \
  -device virtio-net-pci,netdev=net0 \
  -serial mon:stdio \
  -serial file:./logs/tee.log \
  -device virtio-serial-pci,id=virtio-serial0 \
  -device virtserialport,name=com.android.emulator.secure_env,id=vc_secure_env \
  -monitor none
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    boot_with_trusty
fi
