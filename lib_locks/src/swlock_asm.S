// Copyright 2014-2021 XMOS LIMITED.
// This Software is subject to the terms of the XMOS Public Licence: Version 1.

          .file     "swlock_asm.S"
          .text

#ifndef __riscv_xxcore

.cc_top swlock_try_acquire.function
          .align    4
.globl swlock_try_acquire
.globl swlock_try_acquire.nstackwords
.globl swlock_try_acquire.maxthreads
.globl swlock_try_acquire.maxtimers
.globl swlock_try_acquire.maxchanends
.type  swlock_try_acquire, @function
.set swlock_try_acquire.locnochandec, 1
.set swlock_try_acquire.nstackwords, 0
swlock_try_acquire:
    ENTSP_lu6 0
    get r11, id
    add r11, r11, 1
    ldw r1, r0[0]            // Get the current mutex value.
    bt  r1, .Lfailed         // Check if it is already claimed.
    stw r11, r0[0]           // Claim it.
#if !defined(__XS1B__)
    // On XS2 a high priority core needs to ensure that a low priority core
    // has executed the store before we load
    nop
    nop
    nop
    nop
    nop
    nop
#endif
    nop
    ldw r2, r0[0]            // Reload the mutex.
    eq  r0, r11, r2          // If the value hasn't changed we've claimed the
    retsp 0                  // mutex.
.Lfailed:
    ldc r0, 0
    retsp 0
.size swlock_try_acquire, .-swlock_try_acquire
.cc_bottom swlock_try_acquire.function
.set swlock_try_acquire.maxchanends, 0
.set swlock_try_acquire.maxtimers, 0
.set swlock_try_acquire.maxthreads, 1

#else

          .p2align    2
.globl swlock_try_acquire
.globl swlock_try_acquire.maxthreads
.globl swlock_try_acquire.maxtimers
.globl swlock_try_acquire.maxchanends
.resource_const swlock_try_acquire, "stack_frame_bytes", 0
.resource_list_empty swlock_try_acquire, "callees"
.resource_list_empty swlock_try_acquire, "tail_callees"
.resource_list_empty swlock_try_acquire, "parallel_callees"
.type  swlock_try_acquire, @function
.set swlock_try_acquire.locnochandec, 1
swlock_try_acquire:
    xm.getid x28
    addi x28, x28, 1
    xm.ldwi x11, 0(x10)            // Get the current mutex value.
    bne  x11,x0, .Lfailed         // Check if it is already claimed.
    xm.stwi x28, 0(x10)            // Claim it.
    // A high priority core needs to ensure that a low priority core
    // has executed the store before we load
    xm.nop
    xm.nop
    xm.nop
    xm.nop
    xm.nop
    xm.nop
    xm.nop
    xm.ldwi x12, 0(x10)           // Reload the mutex.
    xm.eq  x10, x28, x12          // If the value hasn't changed we've claimed the
    xm.retsp 0                    // mutex.
.Lfailed:
    xm.ldcu x10, 0
    xm.retsp 0
.size swlock_try_acquire, .-swlock_try_acquire
.set swlock_try_acquire.maxchanends, 0
.set swlock_try_acquire.maxtimers, 0
.set swlock_try_acquire.maxthreads, 1

#endif
