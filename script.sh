#!/bin/bash
## This script its the main script that will execute everything in the project ##

# load helper scripts
. create_disk.sh | exit 255


# Colors section
blue() {
 echo -ne "\033[0;34m"
 echo -n
 echo -e "\033[0m"
}
red() {
 echo -ne "\033[0;31m"
 echo -n "$1"
 echo -e "\033[0m"
}
green() {
 echo -ne "\033[0;32m"
 echo -n "$1"
 echo -e "\033[0m"
}
yellow() {
 echo -ne "\033[1;33m"
 echo -n "$1"
 echo -e "\033[0m"
}


