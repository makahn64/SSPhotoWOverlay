//
//  CustomSegue.m
//  StubHubTicketBuilder
//
//  Created by Mitchell Kahn on 3/1/13.
//  Copyright (c) 2013 AppDelegates. All rights reserved.
//

#import "CustomSegue.h"
#import <QuartzCore/QuartzCore.h>

@implementation CustomSegue


- (void) perform {
    
    UIViewController *src = (UIViewController *) self.sourceViewController;
    UIViewController *dst = (UIViewController *) self.destinationViewController;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    //transition.subtype = kCATransitionFromTop;
    transition.delegate = self;
    [src.view.layer addAnimation:transition forKey:nil];
    [src.navigationController pushViewController:dst animated:NO];

}

@end
