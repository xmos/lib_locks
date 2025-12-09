// Copyright 2025 XMOS LIMITED.
// This Software is subject to the terms of the XMOS Public Licence: Version 1.

#ifdef  __XS3A__

#include "tilelock.h"

// unsigned tilelock_try_acquire(unsigned tile_id, unsigned combined_id);
.cc_top tilelock_try_acquire.func, tilelock_try_acquire
.globl tilelock_try_acquire.nstackwords
.globl tilelock_try_acquire.maxthreads
.globl tilelock_try_acquire.maxtimers
.globl tilelock_try_acquire.maxchanends
.globl tilelock_try_acquire.maxsync
.type  tilelock_try_acquire, @function
.linkset tilelock_try_acquire.locnoside, 0
.linkset tilelock_try_acquire.nstackwords, 0
.linkset tilelock_try_acquire.maxchanends, 1
.linkset tilelock_try_acquire.maxtimers, 0
.linkset tilelock_try_acquire.maxthreads, 0
.linkset tilelock_try_acquire.maxsync, 0

.globl tilelock_try_acquire

// r0, r1, r2, r3, r11 are callee save
// r0 tileid as arg at init then used as tmp
// r1 combined_id
// r2 Becomes (chan resid & 0xffffff00) at start of fn
// r3 tmp
// r11 local CHANEND ID (always)

    .align 4
tilelock_try_acquire:
    DUALENTSP_lu6 0                         // force dual issue mode
    .issue_mode dual
tilelock_try_acquire_init:
    // Build destination chanend in r0 & get chanend
    {getr r11, XS1_RES_TYPE_CHANEND;shl r0, r0, XS1_CHAN_ID_PROCESSOR_SHIFT}
    ldc r3, XS1_RES_TYPE_CONFIG | (XS1_CT_SSCTRL << XS1_CHAN_ID_CHANNUM_SHIFT)
    {or r0, r0, r3;                 shr r2, r11, 8} // chan resid & 0xffffff00 part 1
    {setd res[r11], r0;             shl r2, r2, 8} // chan resid & 0xffffff00 part 2
    // Send read command
tilelock_try_acquire_start_read:
    ldc r3, XS1_CT_READC;
    outct res[r11], r3;
    // send reply chanend masked resid    
    // we would normally OR with reg >> 8 but we know reg < 256 so no need
    out res[r11], r2 // chan resid & 0xffffff00
    ldc r3, LOCK_REG
    // send regnum
    outt res[r11], r3
    outct res[r11], XS1_CT_END
    // get ack
    inct r3, res[r11] // XS1_CT_ACK (0x3) or XS1_CT_NACK (0x4)
    eq r3, r3, XS1_CT_ACK
    bt r3, tilelock_try_acquire_read_finish
    // If not ACK then retry
    {chkct res[r11], XS1_CT_END; bu tilelock_try_acquire_start_read}
tilelock_try_acquire_read_finish:
    // get regval
    {in r0, res[r11];               mkmsk r3, 16}  
    {chkct res[r11], XS1_CT_END;    and r3, r0, r3} // regval & 0x0000ffff
    // If read value is non-zero, keep reading
    bt r3, tilelock_try_acquire_start_read


tilelock_try_acquire_write:
    // Start write. Dest of chan already setup!
    ldc r3, XS1_CT_WRITEC // Too big for outct immediate
    outct res[r11], r3
    out res[r11], r2 // chan resid & 0xffffff00
    ldc r3, LOCK_REG
    // send regnum
    outt res[r11], r3
    // send set val
    out res[r11], r1
    outct res[r11], XS1_CT_END
    // Get ACK/NACK
    inct r0, res[r11] // XS1_CT_ACK (0x3) or XS1_CT_NACK (0x4)
    eq r0, r0, XS1_CT_ACK
    // Restart write if no ACK
    {chkct res[r11], XS1_CT_END;    bf r0, tilelock_try_acquire_write}

// This guards against a race condition when two acquires happen at the same time
tilelock_try_acquire_start_read_back:
    ldc r3, XS1_CT_READC;
    outct res[r11], r3;
    // send reply chanend masked resid    
    // we would normally OR with reg >> 8 but we know reg < 256 so no need
    out res[r11], r2 // chan resid & 0xffffff00
    ldc r3, LOCK_REG
    // send regnum
    outt res[r11], r3
    outct res[r11], XS1_CT_END
    // get ack
    inct r3, res[r11] // XS1_CT_ACK (0x3) or XS1_CT_NACK (0x4)
    eq r3, r3, XS1_CT_ACK
    bt r3, tilelock_try_acquire_finish
    // If not ACK then retry
    {chkct res[r11], XS1_CT_END;    bu tilelock_try_acquire_start_read_back}

tilelock_try_acquire_finish:
    // get read back value and end token
    in r0, res[r11]; // This read value is returned to callee
    chkct res[r11], XS1_CT_END; 
    {freer res[r11];                retsp  0}


.cc_bottom tilelock_try_acquire.func

#endif // __XS3A__
