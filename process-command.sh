#!/bin/bash
for i in i{1..10}
do
   dd if=/dev/urandom of=/tmp/ioload.log bs=512kB count=100 conv=fdatasync oflag=dsync
done
rm /tmp/ioload.log
