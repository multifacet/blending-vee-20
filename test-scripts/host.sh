#!/usr/bin/env bash

TEST_NAME=$1
IP=$2
PORT=$3
PATH=../workloads/microbenchmarks/

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
             (cd $PATH && ./$FILE $AMOUNT $SIZE 1 $2)

         elif [[ $FILE = *'read'* ]];
         then
             (cd $PATH && ./$FILE $AMOUNT $SIZE)
             (cd $PATH  && ./drop_cache)

         else
             (cd $PATH && ./$FILE $AMOUNT $SIZE)

         fi

         AMOUNT=$(( AMOUNT-2 ))
         SIZE=$(( SIZE+2 ))
    done
}

# run tests
case $TEST_NAME in
    "net")
        (cd $PATH && ./net.sh $IP $PORT)
        #iperf3 -c $IP -p $PORT
        ;;
    "cpu")
	(cd $PATH && ./cpu.sh)
	#sysbench cpu --cpu-max-prime=20000 --threads=1 run
        ;;
    "cprobe")
        (cd $PATH && ./probe.sh 10)
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
