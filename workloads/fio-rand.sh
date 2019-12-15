echo "------------------direct IO 8k randread----------------------"

fio --name=randread --ioengine=libaio --iodepth=16 --rw=randread --bs=8k --direct=1 --size=512M --numjobs=2 --runtime=240 --group_reporting


rm rand*

echo "---------------direct IO 128k randread-----------------"

fio --name=randread --ioengine=libaio --iodepth=16 --rw=randread --bs=128k --direct=1 --size=512M --numjobs=2 --runtime=240 --group_reporting

rm rand*

echo "-------------direct IO 8k randwrite-----------------"

fio --name=randread --ioengine=libaio --iodepth=16 --rw=randwrite --bs=8k --direct=1 --size=512M --numjobs=2 --runtime=240 --group_reporting

rm rand*

echo "-------------direct IO 128k randwrite-------------------------"

fio --name=randread --ioengine=libaio --iodepth=16 --rw=randwrite --bs=128k --direct=1 --size=512M --numjobs=2 --runtime=240 --group_reporting

rm rand*