#!/bin/bash
get_info() {
 ARCH=$(uname -m)
 case $ARCH in
 "x86_64")
 	X86=1
  ;;
  "arm64")
  	ARM=0
  ;;
  *)
   	echo "$ARCH not supported, only arm64 and x86"
  ;;
 esac
 for i in apt pacman yum dnf zypper snap flatpak; do
  HAS_MANAGER=$(which $i 2>/dev/null)
   if [ ! -z $HAS_MANAGER ]; then
    MANAGER=$i
    break
   fi
 done
# case $MANAGER in 
# apt)
# 	APT=1
# ;;
# pacman)
# 	PACMAN=1
# ;;
# yum)
# 	YUM=1
# ;;
# dnf)
# 	DNF=1
# ;;
# zypper)
# 	ZYPPER=1
# ;;
# snap)
# 	SNAP=1
# ;;
# flatpak)
# 	FLATPAK=1
# ;;
# esac
DISTRO=$(source /etc/os-release && echo "$NAME")
}
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
   . vars.sh || exit 255
   get_info
fi
