//
//  CameraViewController.h
//  ShareStation
//
//  Created by Mitch Kahn on 2/6/14.
//  Copyright (c) 2014 AppDelegates, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraOverlayView.h"
#import "LandscapeNavController.h"
#import "PortraitImagePickerController.h"
#import "PhotoOverlay+Convenience.h"

@interface CameraViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate, ShutterProtocol>

// True for landscape pics, false by default
@property (nonatomic) BOOL landscape;
@property (nonatomic, strong) PhotoOverlay *overlay;
@property (weak, nonatomic) UIImagePickerController *myPicker;
@property (strong, nonatomic) ADWatchdogTimer *wdt;
@property (strong, nonatomic) CameraOverlayView *cameraOverlay;
@property (strong, nonatomic) UIImage *compositedPic;
@property (nonatomic) BOOL cameraPickerUp;

-(CameraOverlayView *)getOverlayView;

@end
