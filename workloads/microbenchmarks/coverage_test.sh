#! /bin/bash
echo $SECONDS

end=$((SECONDS+600))
while [ $SECONDS -lt $end ]; do
   case $TEST_NAME in
    "net")
        $COMMAND ./net.sh $IP $PORT
        ;;
    "cpu")
        $COMMAND ./cpu.sh
        ;;
    "mem")
        run_multiple_size memory
        ;;
    "write")
       run_multiple_size write
        ;;
esac
done
echo $SECONDS