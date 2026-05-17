
KEYSTORE_RC="system/system/etc/init/keystore2.rc"

if [ -f "$KEYSTORE_RC" ]; then
    sudo sed -i '/service keystore2/a \    interface aidl android.security.maintenance\n    interface aidl android.system.keystore2.IKeystoreService/default\n    interface aidl android.security.authorization\n    interface aidl android.security.apc' "$KEYSTORE_RC"
    echo "keystore2.rc successfully sedded"
else
    echo "Could not locate keystore2.rc"
fi
