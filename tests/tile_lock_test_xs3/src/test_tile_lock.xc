// Copyright 2025 XMOS LIMITED.
// This Software is subject to the terms of the XMOS Public Licence: Version 1.
#include <stdio.h>
#include <print.h>
#include <platform.h>
#include <xs1.h>
#include <stdint.h>

#include "intertilelock.h"
#include "random.h"

/*
This test runs all threads (16), each of which increments a shared counter in XS1_SSWITCH_MIPI_CFG_CLK_DIVIDER_NUM
Being non-atomic read-modify-write this is not thread safe normally.
The number of increments per thread is logged. This will always be correct as each counter is unique.
Inside the lock section, the number of increments per chip and tile are logged too.
These are all then summed and checked against each other to see if they are equal, indicating successful locking.
*/


#define NUM_THREADS 8
#define MAX_COUNT   2000000 // This takes about 35 seconds and does about 16 million reg increments
#define RAND_SEED   8031769
#ifndef USE_LOCK
#define USE_LOCK    1       // Switch this off to see it fail badly
#endif


// These will exist twice (separate memory space) on both tiles
unsigned tile_counter = 0;
unsigned thread_counters[NUM_THREADS] = {0};

unsafe{
    volatile unsigned * unsafe tile_counter_ptr = &tile_counter;
    volatile unsigned * unsafe thread_counters_ptr = thread_counters;
}

void inc_shared_reg(){
    unsigned val;
    read_sswitch_reg(get_local_tile_id(), XS1_SSWITCH_MIPI_CFG_CLK_DIVIDER_NUM, val);
    val++;
    write_sswitch_reg(get_local_tile_id(), XS1_SSWITCH_MIPI_CFG_CLK_DIVIDER_NUM, val);
}

void test_tile_lock(int use_lock){
    unsigned thread_id = get_logical_core_id();
    // Each thread on both tiles will get a unique seed
    random_generator_t rg_sw = random_create_generator_from_seed(RAND_SEED +
                                                                (thread_id << 16) +
                                                                get_local_tile_id());
    unsigned loop_count = random_get_random_number(rg_sw) % MAX_COUNT;

    for(unsigned i = 0; i < loop_count; i++){
        unsafe{
            // This global must be locked to be safe
            if(use_lock) intertile_lock_acquire();
            (*tile_counter_ptr)++;  // This is a read modify write and is NOT thread safe
            inc_shared_reg();       // Also not safe
            if(use_lock) intertile_lock_release();
            // These are specific per location so will always work
            thread_counters_ptr[thread_id]++;
        }
    }
}

void startup(){
    // Init shared reg to zero
    write_sswitch_reg(get_local_tile_id(), XS1_SSWITCH_MIPI_CFG_CLK_DIVIDER_NUM, 0);
}

unsigned tile_report(){
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
    
        return total_thread_counters;
    }
}


void chip_report(unsigned total_tiles){
    unsigned shared_reg_count;
    read_sswitch_reg(get_local_tile_id(), XS1_SSWITCH_MIPI_CFG_CLK_DIVIDER_NUM, shared_reg_count);
    printf("Final shared reg: %u (expected %u): %s\n",
        shared_reg_count,
        total_tiles,
        shared_reg_count == total_tiles ? "PASS" : "FAIL");
}

int main(void){
    chan c_sync;

    par{
        on tile[0]: {
            startup();
            c_sync <: 0;
            par(uint8_t t = 0; t < NUM_THREADS; t++) test_tile_lock(USE_LOCK);
            unsigned total_tile_0 = tile_report();
            c_sync <: total_tile_0;
        }
        on tile[1]: {
            c_sync :> int _;
            par(uint8_t t = 0; t < NUM_THREADS; t++) test_tile_lock(USE_LOCK);
            unsigned total_tile_1 = tile_report();
            unsigned total_tile_0;
            c_sync :> total_tile_0;
            chip_report(total_tile_0 + total_tile_1);
        }
    }

    return 0;
}