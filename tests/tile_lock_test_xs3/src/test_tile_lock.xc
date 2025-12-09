#include <stdio.h>
#include <print.h>
#include <platform.h>
#include <xs1.h>
#include <stdint.h>

#include "tile_lock.h"
#include "random.h"

#define NUM_THREADS 8
#define MAX_COUNT   100000
#define RAND_SEED   8031769
#ifndef USE_LOCK
#define USE_LOCK    1
#endif

unsigned tile_counter = 0;
unsigned thread_counters[NUM_THREADS] = {0};

unsafe{
    volatile unsigned * unsafe tile_counter_ptr = &tile_counter;
    volatile unsigned * unsafe thread_counters_ptr = thread_counters;
}

void test_tile_lock(int use_lock){
    random_generator_t rg_sw = random_create_generator_from_seed(RAND_SEED);
    unsigned loop_count = random_get_random_number(rg_sw) % MAX_COUNT;
    unsigned thread_id = get_logical_core_id();

    for(unsigned i = 0; i < loop_count; i++){
        unsafe{
            // This global must be locked to be safe
            if(use_lock) tilelock_acquire();
            (*tile_counter_ptr)++; // This is a read modify write and is NOT thread safe
            if(use_lock) tilelock_release();
            // These are specific per location so will always work
            thread_counters_ptr[thread_id]++;
        }
    }
}

void report(){
    unsigned total_thread_counters = 0;
    unsafe{
        for(int i = 0; i < NUM_THREADS; i++){
            total_thread_counters += thread_counters_ptr[i];
        }
        printf("Counter tile 0x%x: expected %u (actual %u): %s\n",
            get_local_tile_id() == get_tile_id(tile[0]) ? 0 : 1,
            total_thread_counters, 
            *tile_counter_ptr,
            total_thread_counters == *tile_counter_ptr ? "PASS" : "FAIL");
    }
}


int main(void){
    par{
        on tile[0]: {
            par(uint8_t t = 0; t < NUM_THREADS; t++) test_tile_lock(USE_LOCK);
            report();
        }
        on tile[1]: {
            par(uint8_t t = 0; t < NUM_THREADS; t++) test_tile_lock(USE_LOCK);
            report();
        }
    }

    return 0;
}