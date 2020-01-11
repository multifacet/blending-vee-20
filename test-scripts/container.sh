#!/usr/bin/env bash

INSTANCE=$1
TEST_NAME=$2
RUNTIME=$3
IP=$4
PORT=$5
MEMORY=8192M
CONTAINER1=net-sysbench
CONTAINER2=micro-bench

run_multiple_size()
{
    FILE=$1
    TOTAL=30
    AMOUNT=18
    SIZE=$((TOTAL-AMOUNT))

    while [ $AMOUNT -ge 10 ]
    do

         if [[ $FILE = *'memory'* ]];
         then
              docker run --runtime=$RUNTIME -m $MEMORY --rm -it $CONTAINER2 ./$FILE $AMOUNT $SIZE 1 $2

         elif [[ $FILE = *'read'* ]];
         then
             docker run --runtime=$RUNTIME -m $MEMORY --rm -it $CONTAINER2 ./$FILE $AMOUNT $SIZE
             ./drop_cache

         else
             docker run --runtime=$RUNTIME -m $MEMORY --rm -it $CONTAINER2 ./$FILE $AMOUNT $SIZE

         fi

         AMOUNT=$(( AMOUNT-2 ))
         SIZE=$(( SIZE+2 ))
    done
}

# run tests
case $TEST_NAME in
    "net")
         docker run --runtime=$RUNTIME -m $MEMORY --rm -it -d $CONTAINER1 iperf3 -c $IP -p $PORT
        ;;
    "cpu")
        docker run --runtime=$RUNTIME -m $MEMORY --rm -it $CONTAINER1 sysbench cpu --cpu-max-prime=20000 --threads=1 run
        ;;
    "cprobe")
        docker run --runtime=$RUNTIME -m $MEMORY --rm -it $CONTAINER2  /bin/bash ./probe.sh 10
        ;;
    "mem")
        run_multiple_size memory 2
        ;;
    "mem_unmap")
        run_multiple_size memory 3
        ;;
    "read")
        run_multiple_size read
        ;;
    "write")
       run_multiple_size write
        ;;
esac
