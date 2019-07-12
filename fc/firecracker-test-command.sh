#!/usr/bin/env bash

#fio test
#taskset 0x1 ssh -i xenial.rootfs.id_rsa root@$1 ./fio-rand.sh > fio_$2.txt exit

#direct read
#ssh -i xenial.rootfs.id_rsa root@$1 ./direct-read8k.sh > fio_$2.txt exit
#ssh -i xenial.rootfs.id_rsa root@$1 ./direct-read128k.sh > fio_$2.txt exit

#buffer read
#ssh -i xenial.rootfs.id_rsa root@$1 ./buffer-read8k.sh > fio_$2.txt exit
#ssh -i xenial.rootfs.id_rsa root@$1 ./buffer-read128k.sh > fio_$2.txt exit

#direct
#ssh -i xenial.rootfs.id_rsa root@$1 ./direct-write8k.sh > fio_$2.txt exit
#ssh -i xenial.rootfs.id_rsa root@$1 ./direct-write128k.sh > fio_$2.txt exit

#buffer write
#ssh -i xenial.rootfs.id_rsa root@$1 ./buffer-write8k.sh > fio_$2.txt exit
#ssh -i xenial.rootfs.id_rsa root@$1 ./buffer-write128k.sh > fio_$2.txt exit


#net
#echo "hello from here"
#echo $1
#echo $2
#echo $3
#echo $4
#for i in {1..3}
#do
#	taskset 0x1 ssh -i xenial.rootfs.id_rsa root@$1 ./net.sh $2 $3 > net_test_vm_$4.round_$i exit 
#done

#cpu

#ssh -i xenial.rootfs.id_rsa root@$1  ./cpu.sh > cpu_test_$2.txt exit 



#cprobe
for i in {1..3}
do
	 taskset 0x1 ssh -i xenial.rootfs.id_rsa root@$1 ./probe.sh  exit 
done

