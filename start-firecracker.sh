#!/bin/bash -e
VM_ID="${1:-0}" # Default to vm_id=0

DRIVE="$PWD/sb$VM_ID""xenial.rootfs.ext4"

KERNEL="$PWD/vmlinux"
TAP_DEV="tap$VM_ID"


KERNEL_BOOL_ARGS="console=ttyS0 reboot=k panic=1 pci=off"
#KERNEL_BOOT_ARGS="panic=1 pci=off reboot=k tsc=reliable quiet 8250.nr_uarts=0 ipv6.disable=1 $R_INIT"
#KERNEL_BOOT_ARGS="console=ttyS0 reboot=k panic=1 pci=off nomodules ipv6.disable=1 $R_INIT"

API_SOCKET="/tmp/firecracker-${VM_ID}.socket"
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

logfile="$PWD/output/fc-sb${VM_ID}-log"
#metricsfile="$PWD/output/fc-sb${VM_ID}-metrics"
metricsfile="/dev/null"

touch $logfile

# Setup TAP device that uses proxy ARP
MASK_LONG="255.255.255.0"
#MASK_SHORT="/30"
FC_IP="172.17.100.1"$VM_ID
TAP_IP="172.17.100.1"


FC_MAC="AA:FC:00:00:00:01"

KERNEL_BOOT_ARGS="${KERNEL_BOOT_ARGS} ip=${FC_IP}::${TAP_IP}:${MASK_LONG}::eth0:off"

# Start Firecracker API server
rm -f "$API_SOCKET"

./firecracker --api-sock "$API_SOCKET" --context '{"id": "fc-'${VM_ID}'", "jailed": false, "seccomp_level": 0, "start_time_us": 0, "start_time_cpu_us": 0}' &

sleep 0.015s

# Wait for API server to start
while [ ! -e "$API_SOCKET" ]; do
    echo "FC $VM_ID still not ready..."
    sleep 0.01s
done

curl_put '/logger' <<EOF
{
  "log_fifo": "$logfile",
  "metrics_fifo": "$metricsfile",
  "level": "Warning",
  "show_level": false,
  "show_log_origin": false
}
EOF

curl_put '/machine-config' <<EOF
{
  "vcpu_count": 1,
  "mem_size_mib": 128
}
EOF

curl_put '/boot-source' <<EOF
{
  "kernel_image_path": "$KERNEL",
  "boot_args": "$KERNEL_BOOT_ARGS"
}
EOF

curl_put '/drives/1' <<EOF
{
  "drive_id": "1",
  "path_on_host": "$DRIVE",
  "is_root_device": true,
  "is_read_only": false
}
EOF
#
#curl_put '/drives/2' <<EOF
#{
#  "drive_id": "2",
#  "path_on_host": "$RW_DRIVE",
#  "is_root_device": false,
#  "is_read_only": false
#}
#EOF

curl_put '/network-interfaces/enp1s0f0' <<EOF
{
  "iface_id": "enp1s0f0",
  "guest_mac": "$FC_MAC",
  "host_dev_name": "$TAP_DEV",
  "state": "Attached"
}
EOF

curl_put '/actions' <<EOF
{
  "action_type": "InstanceStart"
}
EOF
