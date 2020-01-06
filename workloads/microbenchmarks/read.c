#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <string.h>
#include <errno.h>


#include "vtime.h"

#define TOTALSIZE 1 << 30

int main(int argc, const char *argv[])
{

    if (argc < 2)
    {
        fprintf(stderr, "usage: ./write <total_size> <write size>\n");
        exit(EXIT_FAILURE);
    }
    


    size_t read_size = 1 << atoi(argv[2]);
        
    size_t amount = 1 << atoi(argv[1]);

    struct timespec start, end;

    char buf[read_size];

    //memset(buf, 'A', TOTALSIZE); 

    //printf("buffer is : %s\n", buf);
    

    clock_gettime(CLOCK_REALTIME, &start);

    int fd = open("read_file", O_RDONLY, (mode_t)0600);
    
    if (fd == -1)
    {
        printf("error opening file: %s\n", strerror(errno));
        return -1;
    }

    
    for(size_t i = 0 ; i < amount; i++)
    {
       // printf("Hello\n");
        if (read(fd, buf, read_size) == -1)
        {
            close(fd);
            printf("error reading: %s\n", strerror(errno));
            return -1;
        }

        //printf("char read: %s\n",buf);

    }

  //  fsync(fd);
    
    clock_gettime(CLOCK_REALTIME, &end);

 

    struct stat s;
    fstat(fd, &s);

    printf("\ninode number %ld \n",s.st_ino);

    printf("\nFile st_blksize %ld \n",s.st_blksize);
    printf("\nblocks %ld\n", &s.st_blocks);

    struct timespec diff_time = diff(start,end);

    float elapsed_time = diff_time.tv_sec + diff_time.tv_nsec/(float)1000000000;

    float throughput = 1/elapsed_time;

    printf("throughput = %.12f GB/sec\n", throughput);


    close(fd);
    
    return 0;
}