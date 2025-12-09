
// Copyright 2025 XMOS LIMITED.
// This Software is subject to the terms of the XMOS Public Licence: Version 1.

#ifdef  __XS3A__

#include "tilelock.h"


void tilelock_release(void){
    unsigned tileid = get_local_tile_id();
    int ret = 0;
    while(!ret){
        ret = write_sswitch_reg(tileid, LOCK_REG, LOCK_REG_INIT);
    }
}


void tilelock_init(void)
{
    tilelock_release();
}


// polling delay which does not require a timer (C friendly)
static void timerless_delay(unsigned delay_ticks){
    timer t;
    int time_now;
    int time_trigger;
    t :> time_trigger;
    time_trigger += delay_ticks;
    do{
        t :> time_now;
    } while(timeafter(time_trigger, time_now));
}


// Prototype for the ASM function in tile_lock_asm.S
extern int tilelock_try_acquire(unsigned tileid, unsigned combined_id);


void tilelock_acquire(void)
{
    const unsigned tileid = get_local_tile_id();
    const unsigned combined_id = tileid | (get_logical_core_id() << 4);
    unsigned readback_combined_id = tilelock_try_acquire(tileid, combined_id);
    const unsigned backoff_multiplier = 400; // Tested for maximum speed with multiple clients (see tile_lock_test_xs3)

    while(readback_combined_id != combined_id){
        // If too low, we get more collisions/retries and so microseconds is optimal
        timerless_delay(backoff_multiplier * (combined_id & 0xff));
        readback_combined_id = tilelock_try_acquire(tileid, combined_id);
    }
}

#endif // __XS3A__
