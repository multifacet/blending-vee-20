#!/usr/bin/env bash

rm -rf output/*
killall firecracker
killall iperf3

COUNT="${1:-0}"
DRIVE="xenial.rootfs.ext4"

for ((i=0; i<COUNT; i++))
do
  rm "sb$i"${DRIVE}
  rm -f /tmp/firecracker-${COUNT}.socket
  ip link del tap$i 2> /dev/null &
done

rm -rf output/*
rm -rf /tmp/firecracker-sb*