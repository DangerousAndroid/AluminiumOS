#!/bin/bash
make_system() {
log_info "Searching for backups"
if [ -f alos.img ]; then
 if [ ! -d backup ]; then
  mkdir backup
 fi
 mv alos.img backup/alos.img.old
fi
unpack_alos_files
mke2fs -t ext4 -O ext_attr,has_journal,dir_index,sparse_super alos.img 6G
cat ./alos-gsi/system/etc/selinux/plat_file_contexts \
    ./alos-gsi/system/system_ext/etc/selinux/system_ext_file_contexts \
    ./alos-gsi/system/product/etc/selinux/product_file_contexts > ./cuttlefish/unified_plat_file_contexts
sed -i 's@^/system_ext/@/(system_ext|system/system_ext)/@' ./cuttlefish/unified_plat_file_contexts
sed -i 's@^/product/@/(product|system/product)/@' ./cuttlefish/unified_plat_file_contexts
echo "/(system_ext|system/system_ext)/bin/rpmb_dev\.desktop\.system u:object_r:rpmb_dev_system_exec:s0" >> ./cuttlefish/unified_plat_file_contexts
echo "/(system_ext|system/system_ext)/bin/rpmb_dev\.system u:object_r:rpmb_dev_system_exec:s0" >> ./cuttlefish/unified_plat_file_contexts
echo "/(system_ext|system/system_ext)/bin/storageproxyd\.system u:object_r:storageproxyd_system_exec:s0" >> ./cuttlefish/unified_plat_file_contexts
echo "/\.git.* u:object_r:rootfs:s0" >> ./cuttlefish/unified_plat_file_contexts
echo "/\.gitignore u:object_r:rootfs:s0" >> ./cuttlefish/unified_plat_file_contexts
echo "/git\.sh u:object_r:rootfs:s0" >> ./cuttlefish/unified_plat_file_contexts
echo "/README\.md u:object_r:rootfs:s0" >> ./cuttlefish/unified_plat_file_contexts
echo "/.* u:object_r:system_file:s0" >> ./cuttlefish/unified_plat_file_contexts
mkdir -p /tmp/alos_overlay
rsync -a ./alos-gsi/ /tmp/alos_overlay/

# Inject mknod /dev/loop-control before apexd-bootstrap in init.rc
sed -i '/exec_start apexd-bootstrap/i \    exec u:r:init:s0 root root -- /system/bin/bootstrap/linker64 /system/bin/toybox mknod /dev/loop-control c 10 237\n    exec u:r:init:s0 root root -- /system/bin/bootstrap/linker64 /system/bin/toybox chmod 0660 /dev/loop-control' /tmp/alos_overlay/system/etc/init/hw/init.rc
sed -i '/onrestart restart zygote/d' /tmp/alos_overlay/system/etc/init/hw/netd.rc /tmp/alos_overlay/system/etc/init/netd.rc 2>/dev/null || true
sed -i 's@/system/bin/vold@/system/bin/toybox true@' /tmp/alos_overlay/system/etc/init/vold.rc 2>/dev/null || true
sed -i '/service vold/a \    oneshot' /tmp/alos_overlay/system/etc/init/vold.rc 2>/dev/null || true
sed -i 's@/system/bin/apexd --snapshotde@/system/bin/toybox true@' /tmp/alos_overlay/system/etc/init/apexd.rc 2>/dev/null || true
cat << 'EOF_VDC' > /tmp/alos_overlay/system/bin/vdc
#!/system/bin/sh
exit 0
EOF_VDC
chmod 755 /tmp/alos_overlay/system/bin/vdc
echo "ro.control_privapp_permissions=disable" >> /tmp/alos_overlay/system/build.prop
echo "service.adb.tcp.port=5555" >> /tmp/alos_overlay/system/build.prop
mkdir -p /tmp/alos_overlay/system/etc/permissions
cat << 'EOF_PERM' > /tmp/alos_overlay/system/etc/permissions/privapp-permissions-photos.xml
<?xml version="1.0" encoding="utf-8"?>
<permissions>
    <privapp-permissions package="com.google.android.apps.photos">
        <permission name="android.permission.WRITE_MEDIA_STORAGE"/>
    </privapp-permissions>
</permissions>
EOF_PERM

e2fsdroid -e -S ./cuttlefish/unified_plat_file_contexts -f /tmp/alos_overlay -a / alos.img
rm -rf /tmp/alos_overlay
log_success "System image built"
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    ROOT_DIR=$(pwd)
    . colors.sh || exit 255
    . logger.sh || exit 255
    . unpack_alos_files.sh || exit 255
    make_system
fi
