#!/bin/bash

# Colors section
error() {
 echo -ne "\033[0;31m"
 echo -n "[ERROR] $1"
 echo -e "\033[0m"
}
success() {
 echo -ne "\033[0;32m"
 echo -n "[SUCCESS] $1"
 echo -e "\033[0m"
}
info() {
 echo -ne "\033[1;33m"
 echo -n "[INFO] $1"
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

# Title
title () {
echo ""                                                                        
yellow "  ▄▄▄▄   ▄▄                                               ▄▄▄▄▄    ▄▄▄▄▄▄▄ "
red "▄██▀▀██▄ ██                ▀▀        ▀▀                 ▄███████▄ █████▀▀▀ "
green "███  ███ ██ ██ ██ ███▄███▄ ██  ████▄ ██  ██ ██ ███▄███▄ ███   ███  ▀████▄  "
yellow "███▀▀███ ██ ██ ██ ██ ██ ██ ██  ██ ██ ██  ██ ██ ██ ██ ██ ███▄▄▄███    ▀████ "
red "███  ███ ██ ▀██▀█ ██ ██ ██ ██▄ ██ ██ ██▄ ▀██▀█ ██ ██ ██  ▀█████▀  ███████▀ "                                                                                             
}

# Installer functions
clone_repo() {
if [ -d AluminiumOS ]; then
 info "Cloning on ALOS folder due to stock folder being occupied"
 git clone --recurse-submodules https://github.com/DangerousAndroid/AluminiumOS.git ALOS --depth=1
 DIR=alos
else
 info "Cloning from github"
 git clone --recurse-submodules https://github.com/DangerousAndroid/AluminiumOS.git --depth=1
 DIR=AluminiumOS
fi
}
check_git() {
 info "Checking if git its installed"
 CHECK_GIT=$(command -v git)
 if [ -z $CHECK_GIT ]; then
  error "Please install GIT"
  exit 255
 fi
}
check_manager() {
 info "Checking distro manager"
 for i in apt pacman yum dnf zypper snap flatpak; do
  HAS_MANAGER=$(which $i 2>/dev/null)
   if [ ! -z $HAS_MANAGER ]; then
    MANAGER=$i
    break
   fi
 done
 success "Found $MANAGER"
}
install_qemu() {
 QEMU=$(which qemu-system-aarch64 2>/dev/null)
 if [ -z $QEMU ]; then
  error "QEMU not installed, installing it"
  case $MANAGER in 
  apt)
  	info "Installing qemu via apt"
 	sudo apt install qemu-system-arm qemu-efi-aarch64 
  ;;
  pacman)
  	info "Installing qemu via pacman"
 	sudo pacman -S qemu-system-aarch64 
  ;;
  yum)
  	info "Installing qemu via yum"
 	sudo yum install qemu
  ;;
  dnf)
  	info "Installing qemu via dnf"
 	sudo dnf install qemu
  ;;
  zypper)
  	info "Installing qemu via zypper"
  	# This commands are from the opensuse official page (https://software.opensuse.org/download/package?package=qemu-guest-agent&project=Virtualization)
 	sudo zypper addrepo https://download.opensuse.org/repositories/Virtualization/openSUSE_Slowroll/Virtualization.repo
	sudo zypper refresh
	sudo zypper install qemu-guest-agent
  ;;
  snap)
 	error "SNAP package wont work at 100%, please install it from another package manager or download it manually"
  ;;
  flatpak)
 	error "FLATPAK package wont work at 100%, please install it from another package manager or download it manually"
  ;;
  *)
  	error "Unkown package manager"
  ;;
  esac
 fi
}
title
check_manager
install_qemu
check_git
clone_repo
success "All done!"
read -p "Do you want to init the init script now? [y/N]" OPTION
case $OPTION in 
y|Y)
 info "Selected yes, Executing init script now"
 ./$DIR/init.sh
;;
n|N)
 info "Selected no, exiting now"
 exit
;;
*)
 error "Unrecognized option, assuming no"
 exit
;;
esac
