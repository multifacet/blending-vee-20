#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <sched.h>
#include <assert.h>
#include <string.h>
#include <sys/mman.h>
#include <errno.h>
#include <fcntl.h>


#include "vtime.h"

#ifndef __USE_GNU
#define __USE_GNU
#endif



float mem_alloc(size_t amount, size_t alloc_size)
{

  struct timespec start, end;
  //clock_t t;
  //printf("total alloc: %ld, alloc size: %ld\n", amount,alloc_size); 
  // t = clock();
  clock_gettime(CLOCK_REALTIME, &start);

  unsigned int count = 0;

  for(size_t i = 0; i < amount; i++)
  {
    char *addr = mmap(NULL, alloc_size, PROT_READ | PROT_WRITE, MAP_ANON | MAP_PRIVATE, -1, 0);
		//printf("Mapped at %p\n", addr);

    if(addr == MAP_FAILED)
    {
     printf("mmap failed: %s\n", strerror(errno));
     return -1;
    }

  }

  clock_gettime(CLOCK_REALTIME, &end);

  /*t = clock() - t;
  double total_time = ((double)t)/CLOCKS_PER_SEC;
  printf("CPU time: %f\n",total_time);*/
  struct timespec diff_time = diff(start,end);
  float elapsed_time = diff_time.tv_sec + diff_time.tv_nsec/(float)1000000000;
  return elapsed_time;

}


float mem_alloc_with_touch(size_t amount, size_t alloc_size, int option)
{
  struct timespec start, end, start_touch, end_touch, diff_time, diff_time_touch;
  //printf("total alloc: %ld, alloc size: %ld\n", amount,alloc_size);
  size_t page_size = getpagesize();

  float elapsed_time_touch = 0;
  char buf[4];
  memset(buf, 'A', 4);
  clock_gettime(CLOCK_REALTIME, &start);

  unsigned int count = 0;

  for(size_t i = 0; i < amount; i++)
  {
    char *addr = mmap(NULL, alloc_size, PROT_READ | PROT_WRITE, MAP_ANON | MAP_PRIVATE, -1, 0);

    if(addr == MAP_FAILED)
    {
      printf("mmap failed: %s\n", strerror(errno));
      return -1;
    }
    else
    {
      //printf("here\n");
      /*
      Case 1:
      Touching first page of the alocated memory*/
   
      /*strcpy(addr, "hello");
      if(strcmp(addr,"hello") != 0)
      {
        printf("Error reading: %s\n",strerror(errno));
      }*/

      /*
      Case 2:
      Touching one word(4 bytes) for each page
      */ 

      clock_gettime(CLOCK_REALTIME, &start_touch);

      for(size_t j = 0; j < alloc_size; j += page_size)
      {
        addr[j] = buf; 
      }

      clock_gettime(CLOCK_REALTIME, &end_touch);
      diff_time_touch = diff(start_touch, end_touch);
      elapsed_time_touch += (diff_time_touch.tv_sec + diff_time_touch.tv_nsec/(float)1000000000);
    }

    if(option == 3)
    {
        int unmap = munmap(addr, alloc_size);

        if (unmap != 0)
        {
            printf("unmmap failed: %s\n", strerror(errno));
            return -1;
         }
    }

  }

  clock_gettime(CLOCK_REALTIME, &end);
  printf("Total touch time = %.12f seconds\n", elapsed_time_touch);
  diff_time = diff(start, end);
  float elapsed_time = diff_time.tv_sec + diff_time.tv_nsec/(float)1000000000;
  printf("Total allocation time = %.12f seconds\n", elapsed_time - elapsed_time_touch);
  return elapsed_time;
}


int main(int argc, char *argv[])
{
  size_t amount = 1 << atoi(argv[1]);
  size_t alloc_size = 1 << atoi(argv[2]);
  int rounds = atoi(argv[3]);
  int option = atoi(argv[4]);

  if(argc < 5)
  {
    fprintf(stderr, "Usage: ./memory <total> <mmap_size> <rounds> <option: 1(no touch), 2(touch), 3(touch+unmap)>\n");
    exit(EXIT_FAILURE);
  }


  float total_time = 0;

  switch(option)
  {
    case 1: for(int i = 0; i<rounds; i++)
            {
              printf("round %d\n",i+1);
              total_time += mem_alloc(amount, alloc_size);
            }

            break;
    case 2: total_time+=mem_alloc_with_touch(amount, alloc_size, option);
            break;

    case 3: total_time+=mem_alloc_with_touch(amount, alloc_size, option);
            break;
   default: break;

  }
  

  printf("Average for %d rounds: time elapsed = %.12f seconds\n", rounds, total_time/rounds);
  return 0;
}
