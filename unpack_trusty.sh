#!/bin/bash
unpack_trusty() {
if [ -f secure/lk.bin ]; then
 echo "File already extracted"
 exit
fi
if [ ! -f secure/lk.bin.zip ]; then
 echo "Please download the trusty subsystem!"
 exit
fi
cd secure
unzip lk.bin.zip
cd ..
if [ ! -f secure/lk.bin ]; then
 echo "Unkown error during the extraction!"
 exit
fi
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    unpack_trusty
fi
