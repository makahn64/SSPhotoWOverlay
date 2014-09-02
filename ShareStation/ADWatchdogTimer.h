//
//  WatchdogTimer.h
//  StubHubTicketBuilder
//
//  Created by Mitchell Kahn on 3/6/13.
//  Copyright (c) 2013 AppDelegates. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADWatchdogTimer : NSObject

@property (nonatomic, strong) void (^triggerBlock)(void);
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) NSTimeInterval timerTime;
@property (nonatomic) BOOL enabled;

-(ADWatchdogTimer *)initWithTriggerBlock:(void (^)(void))block interval:(NSTimeInterval)time;
-(void)kick;
-(void)resetTimer;

@end
