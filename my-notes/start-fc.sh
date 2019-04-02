boot_args="ip=172.17.100.10::172.17.100.1:255.255.255.0::eth0:off"

curl --unix-socket /tmp/firecracker.socket -i \
    -X PUT 'http://localhost/boot-source'   \
    -H 'Accept: application/json'           \
    -H 'Content-Type: application/json'     \
    -d '{
        "kernel_image_path": "./hello-vmlinux.bin",
        "boot_args": "console=ttyS0 reboot=k panic=1 pci=off ${boot_args}"
    }'

curl --unix-socket /tmp/firecracker.socket -i \
    -X PUT 'http://localhost/drives/rootfs' \
    -H 'Accept: application/json'           \
    -H 'Content-Type: application/json'     \
    -d '{
        "drive_id": "rootfs",
        "path_on_host": "./hello-rootfs.ext4",
        "is_root_device": true,
        "is_read_only": false
    }'




curl -X PUT \
  --unix-socket /tmp/firecracker.socket \
  http://localhost/network-interfaces/enp1s0f0 \
  -H accept:application/json \
  -H content-type:application/json \
  -d '{
      "iface_id": "enp1s0f0",
      "guest_mac": "AA:FC:00:00:00:01",
      "host_dev_name": "tap0"
    }'


curl --unix-socket /tmp/firecracker.socket -i \
    -X PUT 'http://localhost/actions'       \
    -H  'Accept: application/json'          \
    -H  'Content-Type: application/json'    \
    -d '{
        "action_type": "InstanceStart"
     }'

