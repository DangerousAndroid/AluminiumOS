#!/bin/bash
boot_debug() {
echo "Launching AluminiumOS (Build CP1A.260305.018) without Trusty TEE..."
qemu-system-aarch64 \
  -M virt,gic-version=3 \
  -cpu max,sve=off \
  -smp $CORES \
  -m $MEM \
  -accel tcg,thread=multi,tb-size=4096 \
  -kernel "$KERNEL" \
  -initrd "$RAMDISK" \
  -dtb "$DTB" \
  -device qemu-xhci,id=xhci,addr=05.0 \
  -drive file="$DISK",if=none,id=super_drive,format=raw,cache=unsafe,aio=threads \
  -device virtio-blk-pci,drive=super_drive,id=super-disk,addr=04.0 \
  -device virtio-gpu-gl-pci,id=gpu0,addr=06.0,blob=true,max_outputs=1 \
  -append "$CMDLINE_DEBUG" \
  -device virtio-tablet-pci \
  -display egl-headless \
  -device virtio-keyboard-pci \
  -serial stdio \
  -device virtio-serial-pci,id=virtio-serial0 \
  -device virtserialport,name=com.android.emulator.secure_env,id=vc_secure_env \
  -netdev user,id=net0,hostfwd=tcp::5557-:5555 \
  -device virtio-net-pci,netdev=net0 \
  -monitor telnet:127.0.0.1:4444,server,nowait \
  -monitor unix:/tmp/qemu-mon.sock,server,nowait
}

# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    . vars.sh || exit 255
    . colors.sh || exit 255
    . logger.sh || exit 255
    boot_debug
fi
