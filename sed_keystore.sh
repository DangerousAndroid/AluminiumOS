#!/bin/bash
sed_keystore() {
KEYSTORE_RC="system/system/etc/init/keystore2.rc"

if [ -f "$KEYSTORE_RC" ]; then
    sudo sed -i '/service keystore2/a \    interface aidl android.security.maintenance\n    interface aidl android.system.keystore2.IKeystoreService/default\n    interface aidl android.security.authorization\n    interface aidl android.security.apc' "$KEYSTORE_RC"
    echo "keystore2.rc successfully sedded"
else
    echo "Could not locate keystore2.rc"
fi
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    sed_keystore
fi
