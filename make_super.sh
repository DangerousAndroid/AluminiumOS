#!/bin/bash
make_super() {
if [ -f super_alos.img ]; then
 if [ ! -d backup ]; then
   mkdir backup
 fi
 mv super_alos.img backup/super_alos.img.old
fi
lpmake \
    --metadata-size 65536 \
    --super-name super \
    --metadata-slots 2 \
    --device super:12884901888 \
    --group google_dynamic_partitions:12884901888 \
    --partition system:readonly:$(stat -c%s alos.img):google_dynamic_partitions \
    --image system=./alos.img \
    --partition vendor:readonly:$(stat -c%s p9pf/vendor.img):google_dynamic_partitions \
    --image vendor=p9pf/vendor.img \
    --partition product:readonly:0:google_dynamic_partitions \
    --partition odm:readonly:0:google_dynamic_partitions \
    --partition system_ext:readonly:0:google_dynamic_partitions \
    --partition system_dlkm:readonly:0:google_dynamic_partitions \
    --partition vendor_dlkm:readonly:0:google_dynamic_partitions \
    --output super_alos.img
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    make_super
fi
