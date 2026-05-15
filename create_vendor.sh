VENDOR_FILES=p9pf/vendor
if [ -f p9pf/vendor.img ]; then
 if [ ! -d backup ]; then
  mkdir backup
 fi
 mv p9pf/vendor.img backup/vendor.img.old
fi
mke2fs -t ext2 -d ./vendor vendor.img 1300M
