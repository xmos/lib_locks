// Copyright 2014-2024 XMOS LIMITED.
// This Software is subject to the terms of the XMOS Public Licence: Version 1.
#include <xs1.h>
#include <platform.h>

#include <stdio.h>
#include "hwlock.h"
#include "swlock.h"

#ifndef USE_HW_LOCK
#define USE_HW_LOCK 0
#endif

#if USE_HW_LOCK
#define acquire(x) hwlock_acquire(x)
#define release(x) hwlock_release(x)
#else

void acquire_lock();
void release_lock();

#define acquire(x) acquire_lock()
#define release(x) release_lock()
#endif

#define NUM_THREADS 8
#define NUM_ATTEMPTS 10

void use_lock(unsigned high_priority_limit, hwlock_t lock,
  int acquire_time[NUM_ATTEMPTS], int release_time[NUM_ATTEMPTS])
{
  timer tmr;

  unsigned core_id = get_logical_core_id();
  if (core_id < high_priority_limit) {
    set_core_high_priority_on();
  }

  for (unsigned i = 0; i < NUM_ATTEMPTS; i++) {
    acquire(lock);
    tmr :> acquire_time[i];
    delay_microseconds(10);
    tmr :> release_time[i];
    release(lock);
  }
}

int check_none_in_range(int thread_num, int start_time, int end_time,
  int acquire_time[][NUM_ATTEMPTS], int release_time[][NUM_ATTEMPTS])
{
  int errors = 0;
  for (unsigned i = 0; i < NUM_THREADS; i++) {
    if (i == thread_num) {
      continue;
    }

    for (unsigned j = 0; j < NUM_ATTEMPTS; j++) {
      if (acquire_time[i][j] > start_time && acquire_time[i][j] < end_time) {
        errors += 1;
        // debug_printf("Core %d acquired lock at %d when core %d had lock from %d -> %d\n",
        //   i, acquire_time[i][j], thread_num, start_time, end_time);
      }
    }
  }
  return errors;
}

int check_data(int acquire_time[][NUM_ATTEMPTS], int release_time[][NUM_ATTEMPTS])
{
  int errors = 0;
  for (unsigned i = 0; i < NUM_THREADS; i++) {
    for (unsigned j = 0; j < NUM_ATTEMPTS; j++) {
      // determine if any other thread managed to acquire the lock while this
      // one owned it
      errors += check_none_in_range(i, acquire_time[i][j], release_time[i][j], acquire_time, release_time);
    }
  }
  return errors;
}

int main() {
  par {
    on tile[0]: {
      int acquire_time[NUM_THREADS][NUM_ATTEMPTS];
      int release_time[NUM_THREADS][NUM_ATTEMPTS];

      // The software lock is kept in helper.c to get around parallel usage checks
      hwlock_t lock = hwlock_alloc();

      for (int i = 0; i <= NUM_THREADS; i++) {
        par {
          use_lock(i, lock, acquire_time[0], release_time[0]);
          use_lock(i, lock, acquire_time[1], release_time[1]);
          use_lock(i, lock, acquire_time[2], release_time[2]);
          use_lock(i, lock, acquire_time[3], release_time[3]);
          use_lock(i, lock, acquire_time[4], release_time[4]);
          use_lock(i, lock, acquire_time[5], release_time[5]);
          use_lock(i, lock, acquire_time[6], release_time[6]);
          use_lock(i, lock, acquire_time[7], release_time[7]);
        }
        int errors = check_data(acquire_time, release_time);
        if (errors) {
          printf("ERRORS detected\n");
        } else {
          printf("All ran ok\n");
        }
      }

      hwlock_free(lock);
    }
  }
  return 0;
}
