#!/usr/bin/env bash

echo "here"
echo $1

#8k read
#sudo docker run --cpuset-cpus=0 -m 2048M --tmpfs /tmp  --rm -it benchmark-img fio --name=randread_$1 --ioengine=libaio --iodepth=1 --rw=randread --bs=8k --direct=1 --size=512M --numjobs=2 --runtime=240 --group_reporting > runc_fio_$1.txt
#sudo docker run --runtime=runsc-kvm -m 2048M  --tmpfs /tmp  --rm -it benchmark-img fio --name=randread_$1 --ioengine=libaio --iodepth=1 --rw=randread --bs=8k --direct=0 --invalidate=0 --size=512M --numjobs=2 --runtime=240 --group_reporting  > runsc_fio_$1.txt

#128kread
#sudo docker run --runtime=runsc-kvm  -m 2048M --tmpfs /tmp  --rm -it benchmark-img fio --name=randread_$1 --ioengine=libaio --iodepth=1 --rw=randread --bs=128k --direct=1 --size=512M --numjobs=2 --runtime=240 --group_reporting > runc_fio_$1.txt
#sudo docker run --runtime=runsc-kvm -m 2048M  --tmpfs /tmp  --rm -it benchmark-img fio --name=randread_$1 --ioengine=libaio --iodepth=1 --rw=randread --bs=128k --direct=0 --invalidate=0 --size=512M --numjobs=2 --runtime=240 --group_reporting  > runsc_fio_$1.txt



#8k write
#sudo docker run --runtime=runsc-kvm -m 2048M   --rm -it benchmark-img fio --name=randread_$1 --ioengine=libaio --iodepth=1 --rw=randwrite --bs=8k --direct=1 --size=512M --numjobs=2 --runtime=240 --group_reporting > runc_fio_$1.txt
#sudo docker run --runtime=runsc-kvm -m 2048M    --rm -it benchmark-img fio --name=randread_$1 --ioengine=libaio --iodepth=1 --rw=randwrite --bs=8k --direct=0 --invalidate=0 --size=512M --numjobs=2 --runtime=240 --group_reporting  > runsc_fio_$1.txt

#128kwrite
#sudo docker run  -m 2048M --runtime=runsc-kvm  --rm -it benchmark-img fio --name=randread_$1 --ioengine=libaio --iodepth=1 --rw=randwrite --bs=128k --direct=1 --size=512M --numjobs=2 --runtime=240 --group_reporting > runc_fio_$1.txt
#sudo docker run -m 2048M  --runtime=runsc-kvm  --rm -it benchmark-img fio --name=randread_$1 --ioengine=libaio --iodepth=1 --rw=randwrite --bs=128k --direct=0 --invalidate=0 --size=512M --numjobs=2 --runtime=240 --group_reporting  > runsc_fio_$1.txt

#sudo docker run --cpuset-cpus=0  -m 2048M  --rm -it benchmark-img sysbench cpu --cpu-max-prime=20000 --threads=1 run > runsc_cpu_$1.txt 

#net 
#sudo docker run --cpuset-cpus=0 --runtime=runsc-kvm -m 2048M --rm -it benchmark-img iperf3 -c $1 -p $2 > runsc_net_$3.txt



#sudo docker run -m 128M -e AWS_LAMBDA_FUNCTION_MEMORY_SIZE=128 --rm -v /root/Secure-Serverless/docker/task:/var/task lambci/lambda:python2.7 io_lambda_function.lambda_handler
#echo $1


#network
#sudo docker run --runtime=runsc -m 128M -e AWS_LAMBDA_FUNCTION_MEMORY_SIZE=128  --rm -v /root/Secure-Serverless/docker/task:/var/task lambci/lambda:python2.7 network_lambda_function.lambda_handler $1


#io
#sudo docker run --runtime=runsc -m 128M -e AWS_LAMBDA_FUNCTION_MEMORY_SIZE=128 --rm -v /root/Secure-Serverless/docker/task:/var/task lambci/lambda:python2.7 io_lambda_function.lambda_handler


#io_time
#sudo docker run --runtime=runsc -m 128M -e AWS_LAMBDA_FUNCTION_MEMORY_SIZE=128 --rm -v /root/Secure-Serverless/docker/task:/var/task lambci/lambda:python2.7 io_time_lambda_function.lambda_handler 




#cprobe
sudo docker run  --cpuset-cpus=0 --runtime=runsc-kvm  -m 2048M --rm -it probe > probe_$1.txt  

