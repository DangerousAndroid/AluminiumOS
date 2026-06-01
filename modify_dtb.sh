#!/bin/bash
modify_dtb() {
DTB=dtb/alos.dtb
DTS=dtb/alos.dts
if [ -z $(which dtc) ]; then
 echo ""
 #TODO install the dtc via package manager
fi
dtc -I dtb -O dts ./$DTB -o ./$DTS
read -p "DTB decompile in DTC, press any key when you finish making changes" -n 1
rm -rf $DTB
dtc -I dts -O dtb ./$DTS -o ./$DTB
rm -rf $DTS
}
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    modify_dtb
fi
