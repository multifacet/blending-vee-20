#!/bin/bash -e

TOTAL_TAPS="${1:-0}"  #Default to 0
echo $TOTAL_TAPS
WIRELESS_DEVICE_NAME="enp1s0f0"

#enable ipv4 forwarding
#sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"


#setup all the tap devices, equal to the number of threads
for (( i=0; i<$TOTAL_TAPS; i++ ))
do
   let num=1
   sudo ip tuntap add tap$i mode tap
   sudo ip addr add 172.17.100.$((i+num))/24 dev tap$i
   sudo ip link set tap$i up
   sudo iptables -t nat -A POSTROUTING -o $WIRELESS_DEVICE_NAME -j MASQUERADE
   sudo iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
   sudo iptables -A FORWARD -i tap$i -o $WIRELESS_DEVICE_NAME -j ACCEPT
   echo "tap$((i+num))"
done


