#!/bin/bash
make_super() {
if [ -f super_alos.img ]; then
 if [ ! -d backup ]; then
   mkdir backup
 fi
 mv super_alos.img backup/super_alos.img.old
fi
# System ext and product are inncesary due to being inside system
lpmake \
    --metadata-size 65536 \
    --super-name super \
    --metadata-slots 2 \
    --device super:12884901888 \
    --group google_dynamic_partitions:12884901888 \
    --partition system:readonly:$(stat -c%s alos.img):google_dynamic_partitions \
    --image system=./alos.img \
    --partition vendor:readonly:$(stat -c%s cuttlefish/vendor.img):google_dynamic_partitions \
    --image vendor=cuttlefish/vendor.img \
    --partition product:readonly:0:google_dynamic_partitions \
    --partition system_ext:readonly:0:google_dynamic_partitions \
    --partition odm_dlkm:readonly:$(stat -c%s cuttlefish/odm_dlkm.img):google_dynamic_partitions \
    --image odm_dlkm=cuttlefish/odm_dlkm.img \
    --partition system_dlkm:readonly:$(stat -c%s cuttlefish/system_dlkm.img):google_dynamic_partitions \
    --image system_dlkm=cuttlefish/system_dlkm.img \
    --partition vendor_dlkm:readonly:$(stat -c%s cuttlefish/vendor_dlkm.img):google_dynamic_partitions \
    --image vendor_dlkm=cuttlefish/vendor_dlkm.img \
    --output super_alos.img
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    make_super
fi
