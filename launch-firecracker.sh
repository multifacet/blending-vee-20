#!/bin/bash -e

#set id for the microVM
VM_ID="${1:-0}" # Default to vm_id=0

#rootfs
ROOT_FS="$PWD/xenial.rootfs.ext4"

#set kernel
KERNEL="$PWD/vmlinux"

#set tap device
TAP_DEV="fc-${SB_ID}-tap0"


API_SOCKET="/tmp/firecracker-sb${VM_ID}.sock"
CURL=(curl --silent --show-error --header Content-Type:application/json --unix-socket "${API_SOCKET}" --write-out "HTTP %{http_code}")

curl_put() {
    local URL_PATH="$1"
    local OUTPUT RC
    OUTPUT="$("${CURL[@]}" -X PUT --data @- "http://localhost/${URL_PATH#/}" 2>&1)"
    RC="$?"
    if [ "$RC" -ne 0 ]; then
        echo "Error: curl PUT ${URL_PATH} failed with exit code $RC, output:"
        echo "$OUTPUT"
        return 1
    fi
    # Error if output doesn't end with "HTTP 2xx"
    if [[ "$OUTPUT" != *HTTP\ 2[0-9][0-9] ]]; then
        echo "Error: curl PUT ${URL_PATH} failed with non-2xx HTTP status code, output:"
        echo "$OUTPUT"
        return 1
    fi
}



logFile="$PWD/output/fc-sb${VM_ID}-log"
#metricsfile="$PWD/output/fc-sb${VM_ID}-metrics"
metricsFile="/dev/null"

touch $logFile

#TODO add tap device nonsense here