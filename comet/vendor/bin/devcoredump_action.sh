#!/vendor/bin/sh

DEST_DIR="/data/vendor/pcie"
MAX_DUMPS_PER_DEVICE=5

#
# Validates the incoming DEVPATH to ensure it is a safe and expected value.
#
# Arguments:
#   $1: The DEVPATH to validate.
#
validate_devpath() {
	local devpath="$1"

	if [ -z "$devpath" ]; then
		log -t devcoredump_action "Error: Missing DEVPATH argument"
		return 1
	fi

	case "$devpath" in
	/sys/devices/virtual/devcoredump/*) ;;
	*)
		log -t devcoredump_action "Error: DEVPATH has wrong prefix. ${devpath}"
		return 1
		;;
	esac

	case "$devpath" in
	*[!a-zA-Z0-9./:@_,-]*)
		log -t devcoredump_action "Error: DEVPATH contains invalid characters ${devpath}"
		return 1
		;;
	esac

	case "$devpath" in
	*..*)
		log -t devcoredump_action "Error: DEVPATH must not contain '..' ${devpath}"
		return 1
		;;
	esac

	return 0
}

#
# Rotates coredumps for a given device, keeping only the most recent ones.
#
# Arguments:
#   $1: The DEVICE_ID to rotate coredumps for.
#
rotate_coredumps() {
	local device_id_to_rotate="$1"

	local file_list
	local num_files
	local num_to_delete
	local files_to_delete

	file_list=$(ls -1 "${DEST_DIR}/coredump_${device_id_to_rotate}_"* 2>/dev/null)
	num_files=$(echo "${file_list}" | wc -l)

	if [ "$num_files" -gt "$MAX_DUMPS_PER_DEVICE" ]; then
		num_to_delete=$((num_files - MAX_DUMPS_PER_DEVICE))
		files_to_delete=$(echo "${file_list}" | head -n "${num_to_delete}")

		for old_file in ${files_to_delete}; do
			rm "${old_file}"
			log -t devcoredump_action "Removed old coredump: ${old_file}"
		done
	fi
}

# --- Main Script Logic ---

# The property name containing the devpath is passed as the first argument.
PROPERTY_NAME="$1"
DEVPATH=$(getprop "$PROPERTY_NAME")

validate_devpath "$DEVPATH"
if [ $? -ne 0 ]; then
	exit 1
fi

FAILING_DEVICE_FILE="${DEVPATH}/failing_device"

TARGET_PATH=$(readlink "$FAILING_DEVICE_FILE")
if [ -z "$TARGET_PATH" ]; then
	log -t devcoredump_action "Error: Failed to readlink ${FAILING_DEVICE_FILE}"
	exit 1
fi

DEVICE_ID=$(basename "$TARGET_PATH")

SRC_FILE="${DEVPATH}/data"
if [ ! -f "$SRC_FILE" ]; then
	log -t devcoredump_action "Error: Source coredump data not found at ${SRC_FILE}"
	exit 1
fi

TIMESTAMP=$(date +%Y%m%d-%H%M%S)
DEST_FILE="${DEST_DIR}/coredump_${DEVICE_ID}_${TIMESTAMP}"

if cp "${SRC_FILE}" "${DEST_FILE}"; then
	log -t devcoredump_action "Successfully copied coredump to ${DEST_FILE}"
	# Change file permission so dump_pcie.sh can read the file.
	chmod 755 "${DEST_FILE}"
	rotate_coredumps "$DEVICE_ID"
	# Acknowledge the dump to allow the kernel to recycle the devcd node.
	echo 1 >"${SRC_FILE}"
else
	log -t devcoredump_action "Error: Failed to copy coredump to ${DEST_FILE}"
	exit 1
fi
