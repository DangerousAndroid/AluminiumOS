#!/bin/bash
set -e

echo "Applying Trusty TEE modifications..."

# 1. Modify qemu-atf-inc.mk in Trusty source
MK_FILE="/home/DangerousAndroid/ALOS/trusty_source/trusty/device/arm/generic-arm64/project/qemu-atf-inc.mk"
if [ -f "$MK_FILE" ]; then
    if ! grep -q "ARM_LINUX_KERNEL_AS_BL33" "$MK_FILE"; then
        echo "Adding ATF_MAKE_ARGS += ARM_LINUX_KERNEL_AS_BL33=1 to qemu-atf-inc.mk..."
        echo -e "\nATF_MAKE_ARGS += ARM_LINUX_KERNEL_AS_BL33=1" >> "$MK_FILE"
    else
        echo "qemu-atf-inc.mk already modified."
    fi
else
    echo "Warning: $MK_FILE not found."
fi

# 2. Modify boot scripts to add kvm-arm.mode=none
for script in boot-usb.sh boot-debug.sh; do
    if [ -f "$script" ]; then
        if ! grep -q "kvm-arm.mode=none" "$script"; then
            echo "Adding kvm-arm.mode=none to $script..."
            sed -i 's/androidboot.logd.kernel=true/androidboot.logd.kernel=true kvm-arm.mode=none/g' "$script"
        else
            echo "$script already modified."
        fi
    fi
done

# 3. Modify boot scripts to replace -initrd with -device loader, remove pauth=off, and ensure -dtb is used
python3 -c '
import os

def patch_script(filename, is_debug):
    if not os.path.exists(filename):
        return
    with open(filename, "r") as f:
        content = f.read()
    
    modified = False
    if '\''-initrd "$RAMDISK"'\'' in content:
        print(f"Updating {filename} to use -device loader instead of -initrd...")
        if is_debug:
            content = content.replace('\''-initrd "$RAMDISK"'\'', '\''-device loader,file="$RAMDISK",addr=0x44000000,force-raw=on \\\n  -dtb "$DTB"'\'' )
        else:
            content = content.replace('\''-initrd "$RAMDISK"'\'', '\''-device loader,file="$RAMDISK",addr=0x44000000,force-raw=on'\'')
        modified = True
        
    if '\''-cpu max'\'' in content and '\''-cpu max,sve=off'\'' not in content:
        print(f"Updating CPU flag in {filename} to max,sve=off...")
        content = content.replace('\''-cpu max'\'', '\''-cpu max,sve=off'\'')
        modified = True
        
    if modified:
        with open(filename, "w") as f:
            f.write(content)
    else:
        print(f"{filename} already up to date.")

patch_script("boot-usb.sh", False)
patch_script("boot-debug.sh", True)
'

# 4. Decompile DTB, disable secure PL061, insert initrd nodes, and recompile DTB
if [ -f "dtb/alos.dtb" ]; then
    echo "Decompiling and modifying dtb/alos.dtb..."
    dtc -I dtb -O dts -o dtb/alos.dts dtb/alos.dtb
    
    python3 -c '
import re
import os

with open("dtb/alos.dts", "r") as f:
    content = f.read()

# Disable PL061 GPIO
pattern_pl061 = r"(pl061@9030000\s*\{)(.*?)(\};)"
def repl_pl061(m):
    header = m.group(1)
    body = m.group(2)
    footer = m.group(3)
    if "status" in body:
        body = re.sub(r"status\s*=\s*\"[^\"]*\";", "status = \"disabled\";", body)
    else:
        body = "\n\t\tstatus = \"disabled\";" + body
    return header + body + footer

content = re.sub(pattern_pl061, repl_pl061, content, flags=re.DOTALL)

# Add/update initrd addresses in chosen block
ramdisk_path = "./p9pf/vendor_boot/alos.cpio"
size = os.path.getsize(ramdisk_path) if os.path.exists(ramdisk_path) else 44199412
start_addr = 0x44000000
end_addr = start_addr + size

print(f"Calculated ramdisk size: {size} bytes ({hex(size)})")
print(f"Ramdisk memory range: {hex(start_addr)} - {hex(end_addr)}")

pattern_chosen = r"(chosen\s*\{)(.*?)(\};)"
def repl_chosen(m):
    header = m.group(1)
    body = m.group(2)
    footer = m.group(3)
    # Remove existing initrd parameters if any
    body = re.sub(r"\s*linux,initrd-start\s*=\s*<[^>]*>;", "", body)
    body = re.sub(r"\s*linux,initrd-end\s*=\s*<[^>]*>;", "", body)
    # Insert new ones
    new_lines = f"\n\t\tlinux,initrd-start = <0x00 0x{start_addr:x}>;\n\t\tlinux,initrd-end = <0x00 0x{end_addr:x}>;"
    return header + new_lines + body + footer

content = re.sub(pattern_chosen, repl_chosen, content, flags=re.DOTALL)

with open("dtb/alos.dts", "w") as f:
    f.write(content)
'
    dtc -I dts -O dtb -o dtb/alos.dtb dtb/alos.dts
    rm -f dtb/alos.dts
    echo "dtb/alos.dtb updated successfully with PL061 disabled and initrd parameters."
else
    echo "Warning: dtb/alos.dtb not found."
fi

# 5. Fix keymint-service binary location in unpacked vendor files
KM_BIN="p9pf/vendor/bin/android.hardware.security.keymint-service"
KM_HW_DIR="p9pf/vendor/bin/hw"
if [ -f "$KM_BIN" ]; then
    echo "Fixing keymint-service location (copying to bin/hw/)..."
    mkdir -p "$KM_HW_DIR"
    cp -f "$KM_BIN" "$KM_HW_DIR/android.hardware.security.keymint-service"
    chmod +x "$KM_HW_DIR/android.hardware.security.keymint-service"
    echo "keymint-service copied and made executable at $KM_HW_DIR/android.hardware.security.keymint-service."
else
    echo "Warning: $KM_BIN not found, cannot copy."
fi

echo "All modifications applied successfully!"
