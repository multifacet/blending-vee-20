#!/usr/bin/env bash

#create copy of rootfs, equal to the number of thread
start=0
upperlim="${1-1}"

#DRIVE="lambda-root.ext4"
DRIVE=$2

for ((i=start; i<upperlim; i++)); do
  echo "sb$i"${DRIVE}
  cp $DRIVE "sb$i"${DRIVE}
done

