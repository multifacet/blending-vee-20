/*
 *  Cache Prober
 *
 *  Created on: Sep 1, 2011
 *    Authors: Venkat Varadarajan,
 *             Thawan Kooburat
 *             
 * 
 */


#include "vtime.h"
#include "debug.h"

#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <signal.h>
#include <assert.h>

#include <time.h>
#include <math.h>
#include <inttypes.h>

//#include "Cprobe.h"



#ifndef __CPROBE_H__
#define __CPROBE_H__

#include <stdlib.h>

#define ONE_MB_BYTES (1024*1024UL)
#define ONE_KB_BYTES 1024UL
#define WORD_SIZE 64

uint64_t gCounter;
uint64_t gStartTime;

//buffer to probe 


typedef struct node {
  struct node* next;
  char pad[WORD_SIZE - sizeof(struct node*)];
} node;

node *buff, *head;

int is_power_of_2(int num)
{
  return ( (num > 0) && ((num & (num - 1)) == 0) );
}


inline void bounded_probe(node *head, unsigned count) {
  node *p;
  int i = count;
  for(p = head; p && (i--); p = p->next);
}

 void probe(node *head) {
  node *p; 
  
  /*
  // For debugging purposes
  int i = 0;
  int stride_nodes = WORD_SIZE / sizeof(struct node);

  printf("\n PROBE -- START\n"); 

  for(p = head; p; p = p->next)
    printf("%d ", (p->next - head)/stride_nodes);

  printf("\n PROBE -- END\n"); 
  */

  for(p = head; p; p = p->next);

}

/*
  Initialize a pointer-chasing data-buffer 
 */

node* init_buffer(node** buff, unsigned cache_size_kb) {

  unsigned long cache_size = 0;
  unsigned aligned_size_kb = 0;
  node tmp, *head;
  int i, j;
  int stride_nodes, array_nodes, core = -1;

  cache_size = cache_size_kb * ONE_KB_BYTES;

  aligned_size_kb = 1;
  while( aligned_size_kb < cache_size_kb ) {
    aligned_size_kb = aligned_size_kb << 1;
  }

  PINFO("Buffer size: %u KB, Aligned at: %u KB\n", cache_size_kb, aligned_size_kb);
  posix_memalign((void**) buff, aligned_size_kb * ONE_KB_BYTES, cache_size);

  struct node *array = (struct node*) *buff;
  array_nodes =  cache_size / sizeof(struct node);
  stride_nodes = WORD_SIZE / sizeof(struct node);

  for (i = 0; i < array_nodes; i += stride_nodes)
    array[i].next = array + i;
  array[0].next = 0;

  /* Permute using Sattolo's algorithm for generating a random cyclic
     permutation: */

  for (i = array_nodes / stride_nodes - 1; i > 0; --i) {
    int ii, jj;
    j = random() % i;
    ii = i * stride_nodes;
    jj = j * stride_nodes;
    tmp = array[ii];
    array[ii] = array[jj];
    array[jj] = tmp;
  }
  /* Resulting linked list: */
  head = array;
  //length = array_nodes / stride_nodes;

  /*
  test:
  for (i=0; i<array_nodes; i+=stride_nodes) {
    int n = array[i].next?(array[i].next-array):0; 
    assert(n%stride_nodes==0); 
    printf("%d ", n/stride_nodes); 
  } 
  printf(" -- OK\n"); 
  */

  PINFO("%s", "Done randomizing buffer list\n");
  return head;
}


#endif  //__CPROBE_H__




static void terminate(int sig) {
//  uint64_t totalTime = rdtsc() - gStartTime;

 // PINFO("%" PRIu64 " %" PRIu64 "\n", gCounter, totalTime);

  exit(1);
}

int main(int argc, char** argv) {

  unsigned long cache_size_kb;
  int core = -1;
  int tot_procs;

  gCounter = 0;
  gStartTime = 0;

  if (argc < 2 || argc > 3) {
    fprintf(stderr, "Usage: %s <buffer_size_in_kb> [pin_to_core_no]\n",
	    argv[0]);
    exit(EXIT_FAILURE);
  }

  cache_size_kb = atoi(argv[1]);

  if(argc == 3) {
    core = atoi(argv[2]);
    tot_procs = get_nprocs_conf();
    assert(core < tot_procs && \
	   "pin-to-core option invalid (allowed range: 0 to tot-procs available)");
  }

  if(core > -1) {
    pin_to_core(core);
    printf("Pinned to core: %d (total_procs: %d)\n", core, tot_procs);
  }

  //calibrate_fixed_delay();
  signal(SIGINT, terminate);
  signal(SIGQUIT, terminate);

  srandom(time(NULL));    
  head = init_buffer(&buff, cache_size_kb);

  //gStartTime = rdtsc();
  while (1) {
    probe(head);
    gCounter++;
  }

  //unreachable
  return -1;
}
