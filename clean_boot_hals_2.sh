#!/bin/bash
set -e
VENDOR_DIR="p9pf/vendor"
echo "Locating Boot APEX"
APEX_PATH=$(ls "$VENDOR_DIR/apex/"*boot*.apex* "$VENDOR_DIR/apex/"*boot*.capex* 2>/dev/null | head -n 1)

if [ -z "$APEX_PATH" ]; then
    echo "Error: Could not find any boot APEX/CAPEX file inside $VENDOR_DIR/apex/"
    exit 1
fi

echo "Found APEX target: $(basename "$APEX_PATH")"
echo "Unpack to temp folder"
UNPACK_WORKSPACE=$(mktemp -d)
cp "$APEX_PATH" "$UNPACK_WORKSPACE/"
cd "$UNPACK_WORKSPACE"
unzip -q *.apex* 2>/dev/null || unzip -q *.capex*
if [ -f "original_apex" ]; then
    echo "   [CAPEX Format Detected] Extracting secondary payload..."
    mv original_apex payload.apex
    unzip -q payload.apex
fi
mkdir mnt_payload
sudo mount -o loop apex_payload.img mnt_payload

echo "Moving HALs into vendor folder"
if [ -d mnt_payload/bin/hw ]; then
    cp -r mnt_payload/bin/hw/* "$VENDOR_DIR/bin/hw/"
fi
if [ -d mnt_payload/lib64 ]; then
    cp -r mnt_payload/lib64/* "$VENDOR_DIR/lib64/"
fi
if [ -d mnt_payload/etc/init ]; then
    cp -r mnt_payload/etc/init/* "$VENDOR_DIR/etc/init/"
fi
if [ -d mnt_payload/etc/vintf ]; then
    cp -r mnt_payload/etc/vintf/* "$VENDOR_DIR/etc/vintf/manifest/"
fi
sudo umount mnt_payload
cd - > /dev/null
rm -rf "$UNPACK_WORKSPACE"

echo "Change paths"
sed -i 's|/apex/com\.[^/]*/|/vendor/|g' "$VENDOR_DIR/etc/init/"*boot*.rc

echo "Finish!"
