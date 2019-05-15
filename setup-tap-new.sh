#!/bin/bash -e

TOTAL_TAPS="${1:-0}"  #Default to 0
echo $TOTAL_TAPS
WIRELESS_DEVICE_NAME="enp1s0f0"

#enable ipv4 forwarding
#sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

# Load kernel module
sudo modprobe kvm_intel

# Configure packet forwarding
sudo sysctl -w net.ipv4.conf.all.forwarding=1

# Avoid "neighbour: arp_cache: neighbor table overflow!"
sudo sysctl -w net.ipv4.neigh.default.gc_thresh1=1024
sudo sysctl -w net.ipv4.neigh.default.gc_thresh2=2048
sudo sysctl -w net.ipv4.neigh.default.gc_thresh3=4096


MASK_LONG="255.255.255.252"
MASK_SHORT="/30"


#setup all the tap devices, equal to the number of threads
for (( i=0; i<$TOTAL_TAPS; i++ ))
do
   TAP_DEV="tap"$i


   FC_IP="$(printf '169.254.%s.%s' $(((4 * $i + 1) / 256)) $(((4 * $i + 1) % 256)))"


   TAP_IP="$(printf '169.254.%s.%s' $(((4 * $i + 2) / 256)) $(((4 * $i + 2) % 256)))"
   FC_MAC="$(printf '02:FC:00:00:%02X:%02X' $(($i / 256)) $(($i % 256)))"

   echo "$FC_IP"
   echo "$TAP_IP"
   echo "$FC_MAC"

   sudo ip link del "$TAP_DEV" 2> /dev/null || true
   sudo ip tuntap add dev "$TAP_DEV" mode tap

   sudo sysctl -w net.ipv4.conf.${TAP_DEV}.proxy_arp=1 > /dev/null
   sudo sysctl -w net.ipv6.conf.${TAP_DEV}.disable_ipv6=1 > /dev/null

   sudo ip addr add "${TAP_IP}${MASK_SHORT}" dev "$TAP_DEV"
   sudo ip link set dev "$TAP_DEV" up

   sudo iptables -t nat -A POSTROUTING -o $WIRELESS_DEVICE_NAME -j MASQUERADE
   sudo iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
   sudo iptables -A FORWARD -i $TAP_DEV -o $WIRELESS_DEVICE_NAME -j ACCEPT
   echo "$TAP_DEV"
done
