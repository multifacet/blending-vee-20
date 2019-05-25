/************************************************************
 * vtime.h -- helper functions for timing 
 * Author: Venkat
 *************************************************************/

#ifndef __VTIME_H__
#define __VTIME_H__

#include <sys/sysinfo.h>

#include <time.h>
#include <unistd.h>
#include <stdio.h>
#include <math.h>
#include <inttypes.h>

//#define _GNU_SOURCE
#ifndef __USE_GNU
#define __USE_GNU
#endif
#include <sched.h>

typedef struct timespec timespec;

//all in ns
#define ONE_S_NS 1000000000L
#define ONE_MS_NS 1000000L
#define ONE_US_NS 1000L

#define GET_NSTIME(ts)  ((ts).tv_sec *ONE_S_NS + (ts).tv_nsec)
#define GET_USTIME(ts)  (GET_NSTIME(ts) / ONE_US_NS )
#define GET_MSTIME(ts)  (GET_NSTIME(ts) / ONE_MS_NS )
#define GET_STIME(ts)  (GET_NSTIME(ts) / ONE_S_NS )

#define PRINT_NSTIME(ts) printf("%ld ns ", GET_NSTIME(ts))
#define PRINT_USTIME(ts) printf("%ld us ", GET_USTIME(ts))
#define PRINT_MSTIME(ts) printf("%ld ms ", GET_MSTIME(ts))

#define PROCFS_MIN_SCHED_GRANULARITY "/proc/sys/kernel/sched_min_granularity_ns"

unsigned long g_min_sched_granularity = 5 * ONE_MS_NS;
unsigned long  g_avg_cpu_spin_delay = 0;

#define AVG_CPU_SPIN_DELAY g_avg_cpu_spin_delay

int pin_to_core(int core) {
    cpu_set_t cpu_mask;
    
    if(core >= get_nprocs_conf()) {
      printf("pin_to_core: core (%d) is greater than available number of processors (%d)", core, get_nprocs_conf);
      return -1;
    }

    CPU_ZERO(&cpu_mask);
    CPU_SET(core, &cpu_mask);

    if(sched_setaffinity(0, sizeof(cpu_mask), &cpu_mask) < 0) {
      printf("ERROR while setting the CPU affinity\n");
      return -1;
    }
    return 0;
}

#define INIT_TIMESPEC(ts) (ts).tv_nsec = (ts).tv_sec = 0;

timespec diff_time(timespec start, timespec end)
{
  timespec temp;
  if ((end.tv_nsec-start.tv_nsec)<0) {
    temp.tv_sec = end.tv_sec-start.tv_sec-1;
    temp.tv_nsec = ONE_S_NS + end.tv_nsec-start.tv_nsec;
  } else {
    temp.tv_sec = end.tv_sec-start.tv_sec;
    temp.tv_nsec = end.tv_nsec-start.tv_nsec;
  }
  return temp;
}

// overloaded diff_time
void inplace_diff_time(timespec start, timespec *end)
{
  if ((end->tv_nsec-start.tv_nsec)<0) {
    end->tv_sec = end->tv_sec-start.tv_sec-1;
    end->tv_nsec = ONE_S_NS + end->tv_nsec-start.tv_nsec;
  } else {
    end->tv_sec = end->tv_sec-start.tv_sec;
    end->tv_nsec = end->tv_nsec-start.tv_nsec;
  }

}

void add_time(timespec* dst, timespec addendum) {
  if ((dst->tv_nsec+addendum.tv_nsec) >= ONE_S_NS) {
    dst->tv_sec += addendum.tv_sec + 1;
    dst->tv_nsec += (addendum.tv_nsec - ONE_S_NS);
  } else {
    dst->tv_sec += addendum.tv_sec;
    dst->tv_nsec += addendum.tv_nsec;
  }
}

void copy_time(timespec* dst, timespec src) {
  dst->tv_sec = src.tv_sec;
  dst->tv_nsec = src.tv_nsec;
}

long compare_time(timespec t1, timespec t2) {
  long sec_diff, nsec_diff;
  sec_diff = t1.tv_sec - t2.tv_sec;
  nsec_diff = t1.tv_nsec - t2.tv_nsec;

  if(sec_diff < 0) {
    return sec_diff;
  }

  if(sec_diff > 0) {
    return sec_diff;
  }

  if(sec_diff == 0 && nsec_diff == 0) {
    return 0;
  }

  return nsec_diff;

}

 void start_time(timespec* t) {
  clock_gettime(CLOCK_REALTIME, t);  
}

 void stop_time(timespec* t) {
  timespec curr;
  clock_gettime(CLOCK_REALTIME, &curr);  
  inplace_diff_time(*t, &curr);
  copy_time(t, curr);
}

//
// rdtsc routines adapted from Thawan's code
//

#define rdtsc_start(val) (val) = rdtsc()
#define rdtsc_stop(val) (val) = rdtsc() - (val)
 
/* Read CPU cycle cointer, in cycles -- with serialization */
 uint64_t rdtsc() {
  uint32_t lo, hi;
  asm volatile ( /* serialize */
      "xorl %%eax,%%eax \n        cpuid"
      ::: "%rax", "%rbx", "%rcx", "%rdx");
  /* We cannot use "=A", since this would use %rax on x86_64 */
  asm volatile ("rdtsc" : "=a" (lo), "=d" (hi));
  return (uint64_t) hi << 32 | lo;
}

 uint64_t rdtsc_fast() {
  uint32_t lo, hi;
  /* We cannot use "=A", since this would use %rax on x86_64 */
  asm volatile ("rdtsc" : "=a" (lo), "=d" (hi));
  return (uint64_t) hi << 32 | lo;
}

/********************************************
            Caliberated spins
 ********************************************/

#define NUM_OLOOP 2
#define NUM_ILOOP 1024
#define NUM_CALIBRATION_LOOP 50

void cpu_spin() {

  int i,j;
  volatile vol = 0;

  for(i = 0; i < NUM_OLOOP; i++) {
    for(j = 0; j < NUM_ILOOP; j++) {
      vol = j + vol;
    }
  }
}


unsigned long read_min_sched_granularity() {

  FILE* fp;
  unsigned long min_gran;
  fp = fopen(PROCFS_MIN_SCHED_GRANULARITY, "r");

  if(!fp) {
    printf(" Error opening procfs file : %s\n",PROCFS_MIN_SCHED_GRANULARITY);
    fclose(fp);
    return 0;
  }

  fscanf(fp, "%ul",&min_gran);

  fclose(fp);
  return min_gran;
}

//
//NOTE: Method is not thread safe
//
void calibrate_fixed_delay() {
  timespec start, temp, difftime, avg_cpu_spin_delay;
  unsigned long min_gran, tmp;
  unsigned count = 0;

  if( min_gran = read_min_sched_granularity() ) 
    g_min_sched_granularity = min_gran;
  //else leave the default expected value in the g_min_* gvar

  INIT_TIMESPEC(avg_cpu_spin_delay);

  do {
    // sleep to make sure that the calibration cycle 
    // is NOT interrupted with a context switch
    usleep(g_min_sched_granularity/1000);

    clock_gettime(CLOCK_REALTIME, &start);
    cpu_spin();
    clock_gettime(CLOCK_REALTIME, &temp);

    difftime = diff_time(start,temp);
    add_time(&avg_cpu_spin_delay, difftime);
    count++;

  }while(count < NUM_CALIBRATION_LOOP);

  g_avg_cpu_spin_delay = ceil( 
			      (avg_cpu_spin_delay.tv_nsec + \
			       avg_cpu_spin_delay.tv_sec * ONE_S_NS)\
			      / (double) NUM_CALIBRATION_LOOP
			      );

  printf("Calibration over!\n cpu delay for %d double additions is %lu ns\n",
	 NUM_ILOOP * NUM_OLOOP, g_avg_cpu_spin_delay);

}

int fixed_cpu_delay(unsigned long ns) {

  unsigned long count;
  //timespec delay;
  if (ns < g_avg_cpu_spin_delay)
    return -1;

  count = ns / g_avg_cpu_spin_delay;
  if( ns % g_avg_cpu_spin_delay )
    count++;

  //start_time(&delay);
  do {
    cpu_spin();
  }while(--count);
  /*  
  stop_time(&delay);
  PRINT_NSTIME(delay);
  printf(" =? %u\n", ns);
  */
  return 0;
}

void wallclock_cpu_nsdelay(unsigned long ns) {
  
  timespec start, temp, difftime;

  clock_gettime(CLOCK_REALTIME, &start);
  
  do {
    cpu_spin();
    clock_gettime(CLOCK_REALTIME, &temp);
    difftime = diff_time(start,temp);
  }while(GET_NSTIME(difftime) < ns);

}

/* inline void startTime(timespec* start) { */
/*   clock_gettime(CLOCK_MODE, gStart); */
/* } */

/* inline timespec stopTime(timespec* end) { */
/*   clock_gettime(CLOCK_MODE, end); */
/* } */

/* void printAllTime() { */
/*   for(unsigned i = 0; i < alltimes.size(); i++) */
/*     printf("%ld \n", alltimes[i]); */

/* } */

/* double avgTime() { */
/*   unsigned long sum = 0; */
/*   for(unsigned i = 0; i < alltimes.size(); i++) */
/*     sum += alltimes[i]; */

/*   double ret = (double)sum/alltimes.size(); */
/*   return ret; */
/* } */

#endif //__VTIME_H__

