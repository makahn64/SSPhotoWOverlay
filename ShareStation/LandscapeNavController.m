//
//  LandscapeNavController.m
//  ShareShation
//
//  Created by Scott Matheson on 1/15/14.
//  Copyright (c) 2014 AppDelegates, LLC. All rights reserved.
//

#import "LandscapeNavController.h"

@interface LandscapeNavController ()

@end

@implementation LandscapeNavController

//- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
//    return UIInterfaceOrientationMaskLandscapeLeft;
//}


-(NSUInteger)supportedInterfaceOrientations{
    
    if (self.orientationDelegate){
       [self.orientationDelegate orientationChanged:[[UIDevice currentDevice] orientation]];
    }
    
    return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationPortrait;

}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
