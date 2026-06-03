#!/bin/bash
unpack_alos_files() {
APEX_DIR=alos/system/product/apex
SATIN_DIR=alos/system/product/priv-app/satin
cd $APEX_DIR
if [ -f satin.tar.xz.ab ] && [ -f satin.tar.xz.aa ]; then
  cat "satin.tar.xz.aa" "satin.tar.xz.ab" | tar -xJf -
else
 error "Satin splits missing"
fi
cd $ROOT_DIR && cd $APEX_DIR
if [ -f scom.google.android.gmssystem.prodvic.tar.xzab ] && [ -f com.google.android.gmssystem.prodvic.tar.xzaa ]; then
  cat "com.google.android.gmssystem.prodvic.tar.xzaa" "com.google.android.gmssystem.prodvic.tar.xzab" | tar -xJf -
else
 error "Apex splits missing"
fi
cd $ROOT_DIR
}
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
   $ROOT_DIR=$(pwd)
   . colors.sh || exit 255
   unpack_alos_files
fi
