#!/usr/bin/env bash



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
#for i in {1..3}
#do
taskset 0x2 ssh -i xenial.rootfs.id_rsa root@$1 ./probe.sh 100 exit 
#done

KEY="xenial.rootfs.id_rsa"
VM_IP=$1
TEST_NAME=$2
IP=$3
PORT=$4
COMMAND="ssh -i xenial.rootfs.id_rsa root@$VM_IP"


run_mem()
{
    FILE=$1
    OPTION=$2
    TOTAL=30
    AMOUNT=18
    SIZE=$((TOTAL-AMOUNT))

    while [ $AMOUNT -ge 10 ]
    do
         $COMMAND ./$FILE $AMOUNT $SIZE 1 $OPTION exit
         AMOUNT=$(( AMOUNT-2 ))
         SIZE=$(( SIZE+2 ))
    done
}

run_write()
{
    FILE=$1
    OPTION=$2
    TOTAL=30
    AMOUNT=18
    SIZE=$((TOTAL-AMOUNT))

    while [ $AMOUNT -ge 10 ]
    do
         $COMMAND ./$FILE $AMOUNT $SIZE 1 $OPTION exit
         AMOUNT=$(( AMOUNT-2 ))
         SIZE=$(( SIZE+2 ))
    done
}

run_read()
{
    FILE=$1
    OPTION=$2
    TOTAL=30
    AMOUNT=18
    SIZE=$((TOTAL-AMOUNT))

    while [ $AMOUNT -ge 10 ]
    do
         $COMMAND ./$FILE $AMOUNT $SIZE 1 $OPTION exit

         if [[ $OPTION = 1 ]] ;
         then
            ../workloads/microbenchmarks/drop_cache
            $COMMAND ./drop_cache exit

         elif [[ $OPTION = 2 ]] ;
         then
            $COMMAND ./drop_cache exit

         else
            ../workloads/microbenchmarks/drop_cache

         fi
         AMOUNT=$(( AMOUNT-2 ))
         SIZE=$(( SIZE+2 ))
    done
}

# run tests
case $TEST_NAME in
    "net")
        $COMMAND ./net.sh $IP $PORT exit
        ;;
    "cpu")
        $COMMAND ./cpu.sh exit
        ;;
    "cprobe")
        $COMMAND ./probe.sh 10 exit
        ;;
     "mem")
        run_mem memory 2
        ;;
    "mem_unmap")
        run_mem memory 3
        ;;
    "read_both")
        run_read read 1
        ;;
    "read_fc")
        run_read read 2
        ;;
    "read_host")
        run_read read 3
        ;;
    "write")
       run_write write
        ;;
esac
