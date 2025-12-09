// Copyright 2025 XMOS LIMITED.
// This Software is subject to the terms of the XMOS Public Licence: Version 1.

#ifndef _TILELOCK_H_
#define _TILELOCK_H_

#ifdef  __XS3A__
#include <xs3a_defines.h>
#include <xs1.h>

#define LOCK_REG        XS1_SSWITCH_MIPI_CLK_DIVIDER_NUM
#define STATUS_REG      XS1_SSWITCH_MIPI_CFG_CLK_DIVIDER_NUM
#define LOCK_REG_INIT   0x10000 // Default val of both reg's on boot

#ifndef __ASSEMBLER__

/** Initialize a tile lock.
 *
 *  This function will clear the tile lock for use. Since only one tile lock
 *  instance is available per xcore.ai device, the details of the lock are
 *  fixed and hence no arguments are needed.
 * 
 *  IMPORTANT - all instances of init must be complete before and acquisition
 *  is attempted to avoid race conditions.
 * 
 */
void tilelock_init(void);


/** Acquire a tile lock.
 *
 *  This function acquires the tile lock for the current logical core.
 *  If another logical core holds the lock then the function will wait until
 *  it becomes available.
 *
 */
void tilelock_acquire(void);

/** Release a tile lock.
 *
 *  This function releases a previously acquired tile lock for other cores
 *  to use. Since this function temporarily allocates a channel end, if
 *  many cores on the same tile wish to use this function at the same time 
 *  it may be sensible to use either a local tile lock to guard access to 
 *  this function to avoid running out of chanend resources at runtime.
 * 
 *  This must only be used AFTER a tile lock acquisition.
 *
 */
void tilelock_release(void);

#endif // ! __ASSEMBLER__
#endif // __XS3A__

#endif // _TILELOCK_H_
