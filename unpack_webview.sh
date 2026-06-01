#!/bin/bash
unpack_webview() {
 WEBVIEW_ZIP=cuttlefish/files/webview.apk.zip
 WEBVIEW_DIR=cuttlefish/product/app/webview
 if [ -f $WEBVIEW_DIR/webview.apk ]; then
  echo "APK already unpacked, nothing to do"
  return 0
 fi
 if [ ! -f $WEBVIEW_APK ]; then
  echo "Webview zip not found"
  exit 255
 fi
 unzip -o $WEBVIEW_ZIP -d $WEBVIEW_DIR
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    unpack_webview
fi
