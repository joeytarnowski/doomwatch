//
//  doomgeneric_bridge.m
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


#import "doomgeneric_bridge.h"
#import "doomgeneric.h"
#import "doomstat.h"
#import "i_video.h"

@implementation DoomRunner

- (void)startDoom {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *wadPath = [[NSBundle mainBundle] pathForResource:@"doom1" ofType:@"wad"];
        const char *wad = [wadPath UTF8String];
        static char *argv[] = { "doom", "-iwad", NULL };
        argv[2] = (char *)wad;

        doomgeneric_Create(3, argv);
    });
    doomgeneric_Tick();
}

- (uint32_t *)getFramebuffer {
    return (uint32_t *)DG_ScreenBuffer;
}

int DG_IsMenuActive(void) {
    return menuactive ? 1 : 0;
}

int getDoomScreenWidth(void) {
    return SCREENWIDTH;
}

int getDoomScreenHeight(void) {
    return SCREENHEIGHT;
}

@end
