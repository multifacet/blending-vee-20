#!/usr/bin/env bash


INSTANCE=$1
TEST_NAME=$2
RUNTIME=$3
IP=$4
PORT=$5
MEMORY=8192M
CONTAINER1=net-sysbench
CONTAINER2=micro-bench


#echo "here"
#echo $1



run_multiple_size()
{
    FILE=$1
    #echo "Hello"
    TOTAL=30
    AMOUNT=18
    SIZE=$((TOTAL-AMOUNT))

    while [ $AMOUNT -ge 10 ]
    do
         docker run --runtime=$RUNTIME -m $MEMORY--rm -it $CONTAINER2 ./$FILE $AMOUNT $SIZE
         AMOUNT=$(( AMOUNT-2 ))
         SIZE=$(( SIZE+2 ))
    done
}

# run tests
case $TEST_NAME in
    "net")
        docker run --runtime=$RUNTIME -m $MEMORY--rm -it $CONTAINER1 iperf3 -c $IP -p $PORT
        ;;
    "cpu")
        docker run --runtime=$RUNTIME -m $MEMORY--rm -it $CONTAINER1 sysbench cpu --cpu-max-prime=20000 --threads=1 run
        ;;
    "cprobe")
        docker run --runtime=$RUNTIME -m $MEMORY--rm -it $CONTAINER2  /bin/bash ./probe.sh 10
        ;;
    "mem")
        run_multiple_size memory
        ;;
    "read")
        run_multiple_size read
        ;;
    "write")
       run_multiple_size write
        ;;
esac

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
#sudo docker run  --cpuset-cpus=1  --runtime=runsc -m 2048M --rm -it probe /bin/bash ./probe.sh 100 >  runsc_probe_$1.txt

