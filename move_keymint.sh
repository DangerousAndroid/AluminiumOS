#!/bin/bash
move_keymint() {
if [ ! -f keymint/android.hardware.gatekeeper-service.trusty ] || [ ! -f keymint/android.hardware.keymaster@4.0-service.rc ] || [ ! -f keymint/android.hardware.gatekeeper-service.trusty ]; then
 echo "Files missing!"
 exit 255
fi
for i in android.hardware.gatekeeper-service.trusty android.hardware.keymaster@4.0-service.rc android.hardware.security.keymint-service.rc; do
if [ $i = "android.hardware.gatekeeper-service.trusty" ]; then
 cp $i p9pf/vendor/bin/hw
elif [ $i = "android.hardware.keymaster@4.0-service.rc" ] || [ $i = "android.hardware.security.keymint-service.rc" ]; then
 cp $i p9pf/vendor/init
else
 echo "Error copying files!"
 exit 255
fi
done
echo "Files copied!"
}
# If the script is not sourced from the main script still can be executed as an individual file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    move_keymint
fi
