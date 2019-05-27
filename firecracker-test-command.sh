#!/usr/bin/env bash

#fio test
ssh -i xenial.rootfs.id_rsa root@$1 ./fio-rand.sh > fio_$2.txt exit

#net
ssh -i xenial.rootfs.id_rsa root@$1 ./net.sh $2 $3 > $4_net_test.txt exit

#cpu

ssh -i xenial.rootfs.id_rsa root@$1 ./cpu.sh > $2_cpu_test.txt exit

