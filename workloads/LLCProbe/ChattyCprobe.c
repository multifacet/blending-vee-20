/****************************************************************
 * ChattyCprobe -- interactive version of cache probe 
 * Authors: Venkat
 * Department of Computer Sciences, UW-Madison
 ****************************************************************/

#include "vtime.h"
#include "debug.h"

#include <pthread.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <signal.h>
#include <assert.h>

#include "Cprobe.h"

/* No particular limitation -- this can be changed if there are more
   VCPUs in the VM under test */ 
#define MAX_NUM_THREADS 10

typedef struct thread_t {
  int idx;       //custom uniq id to threads
  pthread_t pth;
} thread_t;


thread_t g_threads[MAX_NUM_THREADS];
/* Works for any number of threads only, but for the benchmark the
   number of threads should be equal to number of VCPUs in the VM. It
   is meaningless to set the number of threads less than 2 
   (default value: 2) */
unsigned g_num_threads = 2;

pthread_barrier_t g_barrier;
pthread_mutex_t g_mutex;
unsigned g_thread_to_lock = 0;

//buffer to probe 
node *buff, *head;


/* Signal handler for interrupted execution. This is the usual (and
   only) exit point of the program */
static void terminate(int sig) {
  
  PINFO("%s", "Terminated with SIG INT/QUIT\n");

  fflush(stdout);
  exit(EXIT_SUCCESS);
}

void* thread_body(thread_t* t) {
  int ret, i;
  int tot_procs = get_nprocs_conf();
  timespec start_ts, tmp;

  PINFO("Tot procs: %d\n", tot_procs);
  // pin each thread to a different core
  pin_to_core((t->idx)%tot_procs);

  while(1) {
 
    /* need to synchronize all threads to not rely on the crafted
       sleeps/locks, which may be intermixed with non-deterministic
       scheduler context switches */
    ret = pthread_barrier_wait(&g_barrier);
    if(ret != 0  && ret != PTHREAD_BARRIER_SERIAL_THREAD)
      errExit("barrier not reached!");    

    /* all threads delayed before lock acquire of the
       `g_thread_to_lock` thread */
    if(t->idx != g_thread_to_lock)
      usleep(ONE_US_NS);

    //other threads supposedly sleep here
    pthread_mutex_lock(&g_mutex);

    //thrash cache    
    start_time(&start_ts);
    do {
      probe(head);
      clock_gettime(CLOCK_REALTIME, &tmp);
    }while( GET_USTIME(diff_time(start_ts, tmp)) <= 10 );
    
    g_thread_to_lock = ( g_thread_to_lock + 1 ) % g_num_threads;

    /* the unlock should generate a scheduler interrupt and wake the
       other thread. */
    pthread_mutex_unlock(&g_mutex);
  }
  
}


int main(int argc, char* argv[])
{
  int i;
  unsigned long cache_size_kb;

  if (argc != 3) {
    fprintf(stderr, "Usage: %s <num-threads> <buffer_size_in_kb>\n",
	    argv[0]);
    exit(EXIT_FAILURE);
  }

  g_num_threads = (unsigned) atoi(argv[1]);
  cache_size_kb = atoi(argv[2]);

  assert( g_num_threads > 1 &&    \
	  "Requires at least two threads to work as intended" );

  calibrate_fixed_delay();
  signal(SIGINT, terminate);
  signal(SIGQUIT, terminate);

  srandom(time(NULL));    
  head = init_buffer(&buff, cache_size_kb);
    
  if(pthread_barrier_init(&g_barrier, NULL, g_num_threads)) {
    errExit("barrier init error");
  }

  //create threads
  for (i = 0; i < g_num_threads; ++i) {
    g_threads[i].idx = i;
    pthread_create(&g_threads[i].pth, NULL,		\
		   (void * (*)(void *)) thread_body,	\
		   (void*) &g_threads[i]);
  }


  //join threads
  for(i = 0; i < g_num_threads; i++) {
      if(pthread_join(g_threads[i].pth, NULL))
	  errExit("Could not join thread\n");
  }


  //not reachable!
  return -1;
}


