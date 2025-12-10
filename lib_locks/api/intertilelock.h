// Copyright 2025 XMOS LIMITED.
// This Software is subject to the terms of the XMOS Public Licence: Version 1.

#ifndef INTERTILE_LOCK_H_
#define INTERTILE_LOCK_H_

#if defined(__XS3A__) || defined(__DOXYGEN__)
#include <xs3a_defines.h>
#include <xs1.h>

#ifndef INTERTILE_LOCK_REG
#define INTERTILE_LOCK_REG        XS1_SSWITCH_MIPI_CLK_DIVIDER_NUM
#endif
#ifndef INTERTILE_LOCK_REG_INIT
#define INTERTILE_LOCK_REG_INIT   0x10000 // Default val of reg on boot
#endif

#ifndef __ASSEMBLER__


/** Acquire a tile lock.
 *
 *  This function acquires the tile lock for the current logical core.
 *  If another logical core holds the lock then the function will wait until
 *  it becomes available.
 *
 */
void intertile_lock_acquire(void);

/** Release a tile lock.
 *
 *  This function releases a previously acquired tile lock for other cores
 *  to use. Note: the underlying register write operation (performed by
 *  write_sswitch_reg()) temporarily allocates a channel end. If many cores
 *  on the same tile wish to use this function at the same time, it may be
 *  sensible to use either a local tile lock to guard access to this function
 *  to avoid running out of chanend resources at runtime.
 * 
 *  This must only be used AFTER a tile lock acquisition.
 *
 */
void intertile_lock_release(void);

#endif // ! __ASSEMBLER__
#endif // __XS3A__

#endif // INTERTILE_LOCK_H_
