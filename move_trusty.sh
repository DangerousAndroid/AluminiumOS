#!/bin/bash
move_trusty() {
if [ -f trusty/lk.bin.zip ]; then
 echo "Extracting lk zip"
 cd trusty
 unzip lk.bin.zip
 cd ..
 rm -rf lk.bin.zip
fi
for i in bl1.bin bl2.bin bl31.bin bl33.bin lk.bin RMPB_DATA tos_fw_config.dtb; do
 if [ -f $i ]; then
  echo "$i already copied!"
  continue
 elif [ -f lk.bin ]; then
  continue
 else
  cp trusty/$i .
 fi
done
if [ -f lk.bin ]; then
 mv lk.bin b32.bin 
fi
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    move_trusty
fi
