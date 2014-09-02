//
//  LandscapeNavController
//  ShareShation
//
//  Created by Scott Matheson on 1/15/14.
//  Copyright (c) 2014 AppDelegates, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrientationDidChangeDelegate <NSObject>

-(void)orientationChanged:(NSUInteger)newOrientation;

@end

@interface LandscapeNavController : UINavigationController

@property (nonatomic, weak) id<OrientationDidChangeDelegate> orientationDelegate;

@end
