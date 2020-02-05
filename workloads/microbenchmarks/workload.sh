#! /bin/bash
end=$((SECONDS+600))

while [ $SECONDS -lt $end ]; do
    
    case $1 in 
    	"net") #net
	       iperf3 -c 128.110.154.145 -p 5201
	       ;;
	"cpu") 
		sysbench cpu --cpu-max-prime=20000 --threads=1 run
		;;
        "mem") 
	     ./memory 10 20 1 2
	     ;;

        "write")
	       ./write 10 20 
               rm test
	       ;;
    esac
    :
done
