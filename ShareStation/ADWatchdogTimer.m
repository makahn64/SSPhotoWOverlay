//
//  WatchdogTimer.m
//  StubHubTicketBuilder
//
//  Created by Mitchell Kahn on 3/6/13.
//  Copyright (c) 2013 AppDelegates. All rights reserved.
//

#import "ADWatchdogTimer.h"

@implementation ADWatchdogTimer

@synthesize triggerBlock;
@synthesize timer;
@synthesize timerTime;


- (id)initWithTriggerBlock:(void (^)(void))block interval:(NSTimeInterval)time
{
    self = [super init];
    if (self) {
        self.triggerBlock = block;
        self.timerTime = time;
        self.enabled = YES;
        [self resetTimer];

    }
    
    return self;
}



-(void)fireTrigger{
    
    if (self.enabled)
        self.triggerBlock();
    
}

-(void)resetTimer{
    
    if (self.enabled)
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timerTime
                                                      target:self
                                                    selector:@selector(fireTrigger)
                                                    userInfo:nil
                                                     repeats:NO];
}

-(void)kick{
    
    [self.timer invalidate];
    self.timer = nil;
    [self resetTimer];
    
}

@end
