#!/bin/bash

#fio --name=randread_$1 --ioengine=libaio  --iodepth=1 --rw=randread --bs=8k --direct=1 --size=512M --numjobs=2 --runtime=240 --group_reporting >  p_drr8_$1_round_$2

#taskset 0x1 fio --name=randread_$1 --ioengine=libaio --iodepth=1 --rw=randread --bs=8k --direct=0 --invalidate=0 --size=512M --numjobs=2 --runtime=240 --group_reporting > p_brr8_$1_round_$2

#128k read
#taskset 0x1 fio --name=randread_$1 --ioengine=libaio --iodepth=1 --rw=randread --bs=128k --direct=1 --size=512M --numjobs=2 --runtime=240 --group_reporting > p_drr128_$1_round_$2

#taskset 0x1 fio --name=randread_$1 --ioengine=libaio --iodepth=1 --rw=randread --bs=128k --direct=0 --invalidate=0 --size=512M --numjobs=2 --runtime=240 --group_reporting > p_brr8_$1_round_$2

#8k write
#taskset 0x1 fio --name=randread_$1 --ioengine=libaio --iodepth=1 --rw=randwrite --bs=8k --direct=1 --size=512M --numjobs=2 --runtime=240 --group_reporting >  p_dwr8_$1_round_$2

#taskset 0x1 fio --name=randread_$1 --ioengine=libaio --iodepth=1 --rw=randwrite --bs=8k --direct=0 --invalidate=0 --size=512M --numjobs=2 --runtime=240 --group_reporting > p_bwr8_$1_round_$2




#128k write
#taskset 0x1 fio --name=randread_$1 --ioengine=libaio --iodepth=1 --rw=randwrite --bs=128k --direct=1 --size=512M --numjobs=2 --runtime=240 --group_reporting >  p_dwr128_$1_round_$2

#taskset 0x1 fio --name=randread_$1 --ioengine=libaio --iodepth=1 --rw=randwrite --bs=128k --direct=0 --invalidate=0 --size=512M --numjobs=2 --runtime=240 --group_reporting > p_bwr128_$1_round_$2


#rm randread_$1*
#taskset 0x1 iperf3 -c $2 -p $3 > proc_net_$1.txt

/my-disk/Secure-Serverless/probe.sh $3
