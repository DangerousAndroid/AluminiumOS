#!/bin/bash

set -e

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
