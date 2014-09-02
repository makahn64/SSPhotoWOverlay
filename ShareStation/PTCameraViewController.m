//
//  PTCameraViewController.m
//  ShareStation
//
//  Created by Scott Matheson on 2/6/14.
//  Copyright (c) 2014 AppDelegates, LLC. All rights reserved.
//


#import "PortraitImagePickerController.h"
#import "PTCameraOverlayView.h"
#import "PTCameraViewController.h"
#import "ProofViewController.h"

#define AUTOROTATE YES

@interface PTCameraViewController ()
    
@end

@implementation PTCameraViewController

#pragma mark -
#pragma mark Camera and Compositing

-(CameraOverlayView *)getOverlayView{
    
    UIButton *shutterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shutterButton setTitle:@"" forState:UIControlStateNormal];
    [shutterButton setImage:[UIImage imageNamed:@"shutterbutton"] forState:UIControlStateNormal];
    shutterButton.frame = CGRectMake(690, 512, 64, 64);
    
    CameraOverlayView *cov = [[CameraOverlayView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)
                             andPhotoOverlay:self.overlay
                            andShutterButton:shutterButton];
    
    return cov;
}


#pragma mark - View Lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"PTCameraViewController did load");
    self.landscape = NO;  // This should probably be in an init method?
    
    }


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}




#pragma mark - Segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    
    ProofViewController *pvc = (ProofViewController *)segue.destinationViewController;
    pvc.proofImage = self.compositedPic;
    // Reset the camera picker up flag on the way out the front door
    self.cameraPickerUp = NO;
    
    
}


@end
