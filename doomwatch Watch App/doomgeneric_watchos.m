//
//  doomgeneric_watchos.m
//  doomwatch Watch App
//
//  Created by Joey Tarnowski on 4/16/25.
//


#import <Foundation/Foundation.h>
#import "stdbool.h"

#ifdef true
#undef true
#endif

#ifdef false
#undef false
#endif

#import "doomgeneric.h"
#import "doomkeys.h"
#import "doomstat.h"
#include <unistd.h>
#include <mach/mach_time.h>

#define MAX_KEY_QUEUE 16

typedef struct {
    unsigned char key;
    int pressed;  // 1 = down, 0 = up
} KeyEvent;

static KeyEvent keyQueue[MAX_KEY_QUEUE];
static int keyQueueHead = 0;
static int keyQueueTail = 0;

void DG_Init(void) {
    // Unused
}

void DG_SetWindowTitle(const char *title) {
    // Not needed
}

void DG_SleepMs(uint32_t ms) {
    usleep(ms * 1000);
}

uint32_t DG_GetTicksMs(void) {
    static mach_timebase_info_data_t timebase;
    static uint64_t start = 0;

    if (start == 0) {
        start = mach_absolute_time();
        mach_timebase_info(&timebase);
    }

    uint64_t now = mach_absolute_time();
    uint64_t elapsed = now - start;
    uint64_t nanos = elapsed * timebase.numer / timebase.denom;
    return (uint32_t)(nanos / 1000000);
}

int DG_GetKey(int* pressed, unsigned char* key) {

    if (keyQueueHead == keyQueueTail) {
        return 0; // No input
    }

    KeyEvent event = keyQueue[keyQueueHead];
    keyQueueHead = (keyQueueHead + 1) % MAX_KEY_QUEUE;

    *pressed = event.pressed;
    *key = event.key;

    return 1;
}


void DG_SetKey(int key, bool pressed) {
    int nextTail = (keyQueueTail + 1) % MAX_KEY_QUEUE;

    if (nextTail == keyQueueHead) {
        return;
    }

    keyQueue[keyQueueTail].key = (unsigned char) key;
    keyQueue[keyQueueTail].pressed = pressed ? 1 : 0;
    keyQueueTail = nextTail;

}


