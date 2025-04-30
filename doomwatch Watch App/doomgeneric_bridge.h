//
//  doomgeneric_bridge.h
//  doomwatch
//
//  Created by Joey Tarnowski on 4/16/25.
//

#ifndef doomgeneric_bridge_h
#define doomgeneric_bridge_h

#import <Foundation/Foundation.h>
#import "doomkeys.h"

@interface DoomRunner : NSObject
- (void)startDoom;
- (uint32_t *)getFramebuffer;
@end

void DG_SetKey(int key, bool pressed);

int getDoomScreenWidth(void);
int getDoomScreenHeight(void);
int DG_IsMenuActive(void);

#endif /* doomgeneric_bridge_h */
