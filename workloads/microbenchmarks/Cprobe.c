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

#include "Cprobe.h"

uint64_t gCounter;
uint64_t gStartTime;

//buffer to probe 
node *buff, *head;

static void terminate(int sig) {
  uint64_t totalTime = rdtsc() - gStartTime;

  PINFO("Total probes:: %" PRIu64 " ,totaltime:%" PRIu64 "\n", gCounter, totalTime);

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

  gStartTime = rdtsc();
  while (1) {
    probe(head);
    gCounter++;
  }

  //unreachable
  return -1;
}
