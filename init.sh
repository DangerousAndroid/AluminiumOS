#!/bin/bash
## This script its the main script that will execute everything in the project ##

# load helper scripts WITHOUT loops
. vars.sh || exit 255
. get_info.sh || exit 255
. logger.sh || exit 255
. create_disk.sh || exit 255
. modify_trusty.sh || exit 255
. boot_debug.sh || exit 255
. boot_no_trusty.sh || exit 255
. boot_trusty.sh || exit 255
. clean_boot_hals.sh || exit 255
. clean_boot_hals_2.sh || exit 255
. create_disk.sh || exit 255
. create_metadata.sh || exit 255
. create_userdata.sh || exit 255
. make_vendor.sh || exit 255
. make_super.sh || exit 255
. mount_alos.sh || exit 255
. move_keymint.sh || exit 255
. move_trusty.sh || exit 255
. sed_keystore.sh || exit 255
. unpack_trusty.sh || exit 255
. update_fstab.sh || exit 255
. update_metadata.sh || exit 255
. update_super_disk.sh || exit 255
. update_userdata.sh || exit 255
. make_system_dlkm.sh || exit 255
. make_system_ext.sh || exit 255
. make_vendor_dlkm.sh || exit 255
. make_product.sh || exit 255
. colors.sh || exit 255
. unpack_alos_files.sh || exit 255

# Help menu
show_help() {
 info "---------HELP MENU----------"
 info "USAGE: $0 [-p] [-t]"
 info_continue "-h" " shows this menu"
 info_continue "-l" " will use the logger"
 info_continue "-b" " builds the files locally"
 info_continue "-t" " boot with trusty"
 info_continue '-n' " boots without trusty"
 info_continue "-d" " use debug boot"
 info_continue "-v" " builds images"
 info_continue "-p" " applies paches"
 info_continue "-u" " update images"
 info "---------------------------"
}
# Title function
title() {
echo ""                                                                        
info "  ▄▄▄▄   ▄▄                                               ▄▄▄▄▄    ▄▄▄▄▄▄▄ "
error "▄██▀▀██▄ ██                ▀▀        ▀▀                 ▄███████▄ █████▀▀▀ "
success "███  ███ ██ ██ ██ ███▄███▄ ██  ████▄ ██  ██ ██ ███▄███▄ ███   ███  ▀████▄  "
info "███▀▀███ ██ ██ ██ ██ ██ ██ ██  ██ ██ ██  ██ ██ ██ ██ ██ ███▄▄▄███    ▀████ "
error "███  ███ ██ ▀██▀█ ██ ██ ██ ██▄ ██ ██ ██▄ ▀██▀█ ██ ██ ██  ▀█████▀  ███████▀ "                                                                                             
}
# Init scripts for the first time running it
init_first_time() {
 QEMU=$(which qemu-system-aarch64 2>/dev/null)
 if [ -z $QEMU ]; then
  log_error "QEMU not installed, installing it"
  case $MANAGER in 
  apt)
  	log_info "Installing qemu via apt"
 	sudo apt install qemu-system-arm qemu-efi-aarch64 
  ;;
  pacman)
  	log_info "Installing qemu via pacman"
 	sudo pacman -S qemu-system-aarch64 
  ;;
  yum)
  	log_info "Installing qemu via yum"
 	sudo yum install qemu
  ;;
  dnf)
  	log_info "Installing qemu via dnf"
 	sudo dnf install qemu
  ;;
  zypper)
  	log_info "Installing qemu via zypper"
  	# This commands are from the opensuse official page (https://software.opensuse.org/download/package?package=qemu-guest-agent&project=Virtualization)
 	sudo zypper addrepo https://download.opensuse.org/repositories/Virtualization/openSUSE_Slowroll/Virtualization.repo
	sudo zypper refresh
	sudo zypper install qemu-guest-agent
  ;;
  snap)
 	log_error "SNAP package wont work at 100%, please install it from another package manager or download it manually"
  ;;
  flatpak)
 	log_error "FLATPAK package wont work at 100%, please install it from another package manager or download it manually"
  ;;
  *)
  	log_error "Unkown package manager"
  ;;
  esac
 fi
 touch logs/.init_first_time
}

# Log functions
create_logs() {
if [ ! -d logs ]; then
 mkdir logs
fi
if [ ! -f logs/script.log ]; then
 touch logs/script.log
 log_info "Hii, logs are created, enjoy the project!"
fi
}

make_logger() {
 if [ "$LOGGER" = "1" ]; then
  cat <<'EOF' > logger.sh
log_info() {
  echo ""
  info "$1"
  [ -d logs ] && echo "[INFO]: $1" >> logs/script.log
}
log_error() {
  echo ""
  error "$1"
  [ -d logs ] && echo "[ERROR]: $1" >> logs/script.log
}
log_success() {
  echo ""
  success "$1"
  [ -d logs ] && echo "[SUCCESS]: $1" >> logs/script.log
}
EOF
 else
  cat <<'EOF' > logger.sh
log_info() { echo ""; }
log_error() { echo ""; }
log_success() { echo ""; }
EOF
 fi
}
# Main functions

use_debug_boot() {
log_info "Booting in debug mode"
if [ ! -f super_disk.img ] || [ ! -f boot_debug.sh ]; then
 log_error "Images or script are missing in the project root folder"
 exit 255
fi
boot_debug
}

no_trusty() {
log_info "Booting without trusty"
if [ ! -f super_disk.img ] || [ ! -f boot_no_trusty.sh ]; then
 log_error "Images or script are missing in the project root folder"
 exit 255
fi
boot_without_trusty
}

use_trusty() {
log_info "Booting with trusty"
if [ ! -f super_disk.img ] || [ ! -f boot_trusty.sh ]; then
 log_error "Images or script are missing in the project root folder"
 exit 255
fi
if [ $DOWNLOAD_PREMAKE = 1 ]; then
 unpack_trusty
 move_trusty
else 
 if [ ! -d trusty_source ]; then
   read -p "This will download trusty source code, apply patches and build it because you choose no download the premake files, continue?" -n 1
   mkdir trusty_source
   cd trusty_source
   repo init -u https://android.googlesource.com/trusty/manifest -b main --depth=1
   repo sync
   cd ..
 fi
 modify_trusty
 trusty_source/trusty/vendor/google/aosp/scripts/build.py qemu-generic-arm64-test-debug
 cp trusty_source/build_root/build-qemu-generic-arm64-test-debug/atf/qemu/debug/bl1.bin .
 cp trusty_source/build_root/build-qemu-generic-arm64-test-debug/atf/qemu/debug/bl2.bin .
 cp trusty_source/build_root/build-qemu-generic-arm64-test-debug/test-runner/external/trusty/bootloader/test-runner/test-runner.bin	 .
 cp trusty_source/build_root/build-qemu-generic-arm64-test-debug/atf/qemu/debug/fdts/tos_fw_config.bin .
 cp trusty_source/build_root/build-qemu-generic-arm64-test-debug/lk.bin .
 cp trusty_source/build_root/build-qemu-generic-arm64-test-debug/atf/qemu/debug/metadata.img .
 cp trusty_source/build_root/build-qemu-generic-arm64-test-debug/atf/qemu/debug/RPMB_DATA .
 mv test-runner.bin bl33.bin
 mv lk.bin bl32.bin
 move_keymint
 read -p "Compilation completed, delete source code? [y/n]" ANSWER -n 1
 case $ANSWER in
 y|Y)
  log_info "Deleting trusty source code"
  rm -rf trusty_source
 ;;
 n|N)
  log_info "Not deleting trusty source code"
  ;;
 *)
  log_error "Answer unrecognized, not deleting trusty source code"
  ;;
 esac
fi
boot_with_trusty
}

build_stuff() {
 info "--BUILD MENU--"
 info_continue "Select the number of the image you want to build"
 info_continue "1)" "Disk (needs super)"
 info_continue "2)" "Super (needs system, vendor, system_dlkm and vendor_dlkm)"
 info_continue "3)" "System (ALOS gsi)"
 info_continue "4)" "Vendor"
 info_continue "5)" "System_dlkm"
 info_continue "6)" "Vendor_dlkm"
 info "Once the image finished building you can build other"
 info "---------------"
 read -n 1 IMAGE_SELECTION
 case $IMAGE_SELECTION in
  1)
   if [ -f super_alos.img ]; then
    log_info "Building disk"
    create_disk
   else 
    log_error "Super alos not found in the root dir, please build it"
   fi
  ;;
  2)
   if [ ! -f cuttlefish/system_dlkm.img ] || [ ! -f cuttlefish/vendor_dlkm.img ] || [ ! -f comet/vendor.img ] || [ ! -f alos.img ]; then
    log_error "Some files are missing for building super, check for the imgs in cuttlefish/, comet/ and root dir or build them"
   else
    log_info "Building super"
    make_super
   fi
  ;;
  3)
   log_info "Building system"
   make_system
  ;;
  4)
   log_info "Building vendor"
   make_vendor
  ;;
  5)
   log_info "Building system_dlkm"
   make_system_dlkm
  ;;
  6)
   log_info "Building vendor_dlkm"
   make_vendor_dlkm
  ;;
  *)
   log_error "Unkown option: $IMAGE_SELECTION, use number from 1-6"
   exit 255
  ;;
 esac
 read -p "Do you want to build another one? [y/n]" BUILD_ANOTHER
 case $BUILD_ANOTHER in
 y|Y)
   build_stuff
 ;;
 n|N)
   echo ""
 ;;
 *)
  log_error "Unkown option, assuming no"
 ;;
 esac
}

update_stuff() {
 log_info "Opening update menu"
 info "--UPDATE MENU--"
 info_continue "Select the number of the image you want to update"
 info_continue "1)" " Super"
 info_continue "2)" " Fstab"
 info_continue "3)" " Metadata"
 info_continue "4)" " Userdata"
 info "Once the image finished building you can build other"
 info "---------------"
 read -n 1 UPDATE_SELECTION
 case $UPDATE_SELECTION in
  1)
   if [ -f super_alos.img ]; then
    log_info "Updating super in disk"
    update_super_disk
   else
    log_error "Super Alos not found in root dir, please build it"
   fi
  ;;
  2)
   log_info "Building fstab"
   update_fstab
  ;;
  3)
   log_info "Updating metadata"
   update_metadata
  ;;
  4)
   log_info "Updating Userdata"
   update_userdata
  ;;
  *)
   log_error "Unkown option: "$UPDATE_SELECTION", use number from 1-6"
   exit 255
  ;;
 esac
 read -p "Do you want to build another one? [y/n]" BUILD_ANOTHER
 case $BUILD_ANOTHER in
 y|Y)
   update_stuff
 ;;
 n|N)
   echo ""
 ;;
 *)
  log_error "Unkown option, assuming no"
 ;;
 esac
}

apply_patches() {
 log_info "Applying patches"
 clean_boot_hals
 clean_boot_hals_2
 sed_keystore
}

#########################################################

title
if [ -f logs/init_first_time ]; then
 echo ""
else
 init_first_time
fi

# Get user options
while getopts "plbtndvuh" OPTION; do
    case "$OPTION" in
        p) apply_patches 
        ;;
        l) DOWNLOAD_PREMAKE=1 
        ;;
        b) build_stuff
        ;;
        t) use_trusty
        ;;
        n) no_trusty
        ;;
        d) use_debug_boot
        ;;
        u) update_stuff
        ;;
        l) LOGGER=0
        ;;
        v) DOWNLOAD_PREMAKE=0
        ;;
        h) show_help
        ;;
        *) log_error "$OPTION";  exit 1 
        ;;
    esac
done
make_logger
if [ "$LOGGER" = 1 ]; then
 if [ $OPTIND -eq 1 ]; then
    log_error "No flags provided."
    show_help
    exit
 fi
 create_logs
 echo "-----------INIT ALOS SCRIPT-----------" >> logs/script.log
 date >> logs/script.log
else
  if [ $OPTIND -eq 1 ]; then
    error "No flags provided."
    show_help
    exit
 fi
fi
