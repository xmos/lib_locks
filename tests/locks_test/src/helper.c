// Copyright (c) 2014-2016, XMOS Ltd, All rights reserved
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
