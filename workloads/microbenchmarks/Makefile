#debug_flags = -g -DDEBUG
headers = vtime.h debug.h 
$(CC) = gcc 

all: chatty_cprobe cprobe nqueens
	/bin/true

chatty_cprobe: ChattyCprobe.c Cprobe.h $(headers)
	$(CC) ChattyCprobe.c -lrt -lm -lpthread -o chatty_cprobe

cprobe: Cprobe.c Cprobe.h $(headers)
	$(CC) Cprobe.c -lrt -lm -o cprobe

nqueens: NQueens.c $(headers)
	$(CC) NQueens.c -lrt -lm -o nqueens

clean: 
	rm -rf nqueens cprobe chatty_cprobe 
