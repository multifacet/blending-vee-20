headers = vtime.h 
$(CC) = gcc 

all: write read
	/bin/true

write: write.c $(headers)
	$(CC) write.c -lrt -lm -lpthread -o write

read: read.c $(headers)
	$(CC) read.c -lrt -lm -lpthread -o read

memory: memory.c $(headers)
	$(CC) memory.c -lrt -lm -lpthread -o memory

memory_unmap: memory.c $(headers)
	$(CC) memory.c -lrt -lm -lpthread -o memory_unmap

worker: dcache/worker.c 
	$(CC) dcache/worker.c  -lrt -lm -lpthread  -o worker

trasher: dcache/trasher.c 
	$(CC) dcache/trasher.c  -lrt -lm -lpthread -luuid -o trasher

clean: 
	rm -rf write 
	rm -rf read
	rm -rf worker
	rm -rf trasher
	rm -rf memory