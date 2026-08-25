# Dir vars
ROOT=$(pwd)
MAGISKBOOT=$ROOT/bin/magiskboot
# Init script vars
DOWNLOAD_PREMAKE=1
LOGGER=1
#Cmdline vars
CMDLINE_DEBUG="persist.sys.angle.backend=2 persist.graphics.egl=angle ro.hardware.egl=angle ro.hardware.vulkan=pastel ro.board.platform=android earlycon=pl011,0x09000000 console=ttyAMA0 rw init=/init androidboot.boot_devices=4010000000.pcie,pci0000:00/0000:00:04.0,virtio3 androidboot.selinux=permissive androidboot.lcd_density=160 androidboot.super_partition=super loglevel=8 init_debug_loglevel=8 androidboot.init_rc_debug=1 androidboot.logd.kernel=true androidboot.force_normal_boot=1 androidboot.vbmeta.device_state=unlocked androidboot.verifiedbootstate=orange kvm-arm.mode=none androidboot.first_stage_console=1 printk.devkmsg=on androidboot.veritymode=disabled loop.max_loop=256 ro.apex.updatable=false apexd.no_early_apex=true androidboot.vendor.apex.com.android.hardware.graphics.composer=com.android.hardware.graphics.composer.ranchu.apex stack_depot_disable=on cgroup_disable=pressure kasan.stacktrace=off androidboot.vendor.apex.com.android.hardware.keymint=com.android.hardware.keymint.rust_nonsecure.apex androidboot.vendor.apex.com.android.hardware.gatekeeper=com.android.hardware.gatekeeper.nonsecure.apex androidboot.vendor.apex.com.google.emulated.camera.provider.hal=com.google.emulated.camera.provider.hal.apex androidboot.hardware.egl=angle androidboot.hardware.gralloc=gbm androidboot.hardware.hwcomposer=ranchu androidboot.hardware.vulkan=pastel androidboot.config.hwcomposer=ranchu androidboot.hardware=zuma androidboot.fstab_suffix=zuma ro.crypto.state=unencrypted ro.zygote=zygote64 ro.zygote.disable_gl_preload=1 dalvik.vm.boot-dex2oat-threads=16 dalvik.vm.dex2oat-threads=16 dalvik.vm.dex2oat-filter=verify dalvik.vm.image-dex2oat-filter=verify dalvik.vm.systemservercompilerfilter=verify dalvik.vm.usejit=true dalvik.vm.usejitprofiles=false debug.sf.nobootanimation=1 androidboot.bootcontrol=none"
CMDLINE="persist.sys.angle.backend=2 persist.graphics.egl=angle ro.hardware.egl=angle ro.hardware.vulkan=pastel ro.board.platform=android earlycon=pl011,0x09000000 console=ttyAMA0 rw init=/init androidboot.boot_devices=4010000000.pcie,pci0000:00/0000:00:04.0,virtio3 androidboot.selinux=permissive androidboot.lcd_density=160 androidboot.super_partition=super androidboot.hardware=zuma loglevel=0 androidboot.force_normal_boot=1 androidboot.vbmeta.device_state=unlocked androidboot.verifiedbootstate=orange kvm-arm.mode=none androidboot.first_stage_console=1 printk.devkmsg=on androidboot.veritymode=enforcing loop.max_loop=256 ro.apex.updatable=false apexd.no_early_apex=true androidboot.vendor.apex.com.android.hardware.graphics.composer=com.android.hardware.graphics.composer.ranchu.apex stack_depot_disable=on cgroup_disable=pressure kasan.stacktrace=off androidboot.vendor.apex.com.android.hardware.keymint=com.android.hardware.keymint.rust_nonsecure.apex androidboot.vendor.apex.com.android.hardware.gatekeeper=com.android.hardware.gatekeeper.nonsecure.apex androidboot.vendor.apex.com.google.emulated.camera.provider.hal=com.google.emulated.camera.provider.hal.apex androidboot.hardware.egl=angle androidboot.hardware.gralloc=gbm androidboot.hardware.hwcomposer=ranchu androidboot.hardware.vulkan=pastel androidboot.config.hwcomposer=ranchu ro.crypto.state=unencrypted androidboot.fstab_suffix=zuma ro.zygote=zygote64 ro.zygote.disable_gl_preload=1 dalvik.vm.boot-dex2oat-threads=16 dalvik.vm.dex2oat-threads=16 dalvik.vm.dex2oat-filter=verify dalvik.vm.image-dex2oat-filter=verify dalvik.vm.systemservercompilerfilter=verify dalvik.vm.usejit=true dalvik.vm.usejitprofiles=false debug.sf.nobootanimation=1 androidboot.bootcontrol=none"
# Qemu vars
DISK="super_disk.img"
KERNEL="./cuttlefish/boot/kernel"
RAMDISK="./comet/vendor_boot/alos.cpio"
DTB="./dtb/alos.dtb"
CORES="16"
MEM="16G"
# Super building vars
SUPER_IMAGE=super_alos.img
# Get info vars
X86=0
ARM=0
