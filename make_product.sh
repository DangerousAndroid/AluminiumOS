#!/bin/bash
make_product() {
if [ -f cuttlefish/product.img ]; then
 if [ ! -d backup ]; then
  mkdir backup
 fi
 mv cuttlefish/product.img backup/product.img.old
fi
unpack_webview
mke2fs -t ext4 -O ext_attr,has_journal,dir_index,sparse_super cuttlefish/product.img 360M
e2fsdroid -e -S ./cuttlefish/product/etc/selinux/product_file_contexts -f ./cuttlefish/product -a /product cuttlefish/product.img
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    . unpack_webview.sh || exit 255
    make_product
fi
