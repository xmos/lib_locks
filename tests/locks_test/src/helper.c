// Copyright 2014-2021 XMOS LIMITED.
// This Software is subject to the terms of the XMOS Public Licence: Version 1.
#if USE_HW_LOCK
#else

#include "swlock.h"

swlock_t swlock = SWLOCK_INITIAL_VALUE;

void acquire_lock()
{
  swlock_acquire(&swlock);
}

void release_lock()
{
  swlock_release(&swlock);
}

#endif
