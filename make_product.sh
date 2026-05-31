#!/bin/bash
make_product() {
if [ -f cuttlefish/product.img ]; then
 if [ ! -d backup ]; then
  mkdir backup
 fi
 mv cuttlefish/product.img backup/product.img.old
fi
if [ ! -f cuttlefish/product/app/webview/webview.apk ]; then
 unzip -o cuttlefish/product/app/webview/webview.apk.zip -d cuttlefish/product/app/webview
fi
mke2fs -t ext2 -d ./cuttlefish/product cuttlefish/product.img 1300M
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    make_product
fi
