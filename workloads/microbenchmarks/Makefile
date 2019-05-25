#debug_flags = -g -DDEBUG
headers = vtime.h debug.h 
$(CC) = gcc 

all: cprobe nqueens
	/bin/true


cprobe: Cprobe.c Cprobe.h $(headers)
	$(CC) Cprobe.c -lrt -lm -o cprobe

nqueens: NQueens.c $(headers)
	$(CC) NQueens.c -lrt -lm -o nqueens

clean: 
	rm -rf nqueens cprobe  
