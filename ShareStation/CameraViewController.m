//
//  CameraViewController.m
//  ShareStation
//
//  Created by Scott Matheson on 2/6/14.
//  Copyright (c) 2014 AppDelegates, LLC. All rights reserved.
//

#import "CameraViewController.h"
#import "ProofViewController.h"
#import "AppDelegate.h"
#import "LandscapeNavController.h"
#import "PortraitImagePickerController.h"
#import "LandscapeImagePickerController.h"
#import "CameraOverlayView.h"


@interface CameraViewController ()
    


@end

@implementation CameraViewController

#pragma mark -
#pragma mark Camera and Compositing

// This is overridden by the children
-(CameraOverlayView *)getOverlayView {
    return nil;
}


-(void)startCamera{

    UIImagePickerController *picker;
    if ([[AppDelegate sharedAppDelegate] isLandscapeOrientation]){
        picker = [[LandscapeImagePickerController alloc] init];
    } else {
        picker = [[PortraitImagePickerController alloc] init];
    }
    
    
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    picker.cameraDevice = [[AppDelegate sharedAppDelegate] selfieMode] ? UIImagePickerControllerCameraDeviceFront : UIImagePickerControllerCameraDeviceRear;
    picker.allowsEditing = YES;
    picker.showsCameraControls = NO;
    picker.delegate = self;

    self.myPicker = picker;
    
    self.cameraPickerUp = YES;
    
    self.cameraOverlay = [self getOverlayView];

    self.cameraOverlay.delegate = self;
    self.myPicker.cameraOverlayView = self.cameraOverlay;
    
    [self.navigationController presentViewController:picker animated:NO completion:^{
        
    }];
    
}

-(void)fireShutter{
    
    NSLog(@"Doink! Pic taken");
    [self.myPicker takePicture];
    
}


#pragma mark - Image Picker Delegates

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
    UIImage *originalPic = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"Snap is %f by %f", originalPic.size.width, originalPic.size.height);
    
    UIImage *overlay       = [UIImage imageWithData:self.overlay.overlayImgData]; //foreground image
    
    //CGSize newSize = overlay.size;
    
    CGSize newSize = CGSizeMake(768, 1024);
    
    UIGraphicsBeginImageContext( newSize );
    
    // drawing photo, it will resize itself to the frame of the overlay
    if ([[AppDelegate sharedAppDelegate] selfieMode]){
        originalPic = [UIImage imageWithCGImage:originalPic.CGImage scale:originalPic.scale orientation:UIImageOrientationLeftMirrored];
    }
    [originalPic drawInRect:CGRectMake(0,0,newSize.width, newSize.height)];

    // Draw the overlay
    [overlay drawInRect:CGRectMake(0,0,newSize.width, newSize.height)] ;
    
    self.compositedPic = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(self.compositedPic, nil, nil, nil);
    
    // Dismiss
    [self dismissViewControllerAnimated:NO completion:^{
        if ([[AppDelegate sharedAppDelegate] isLandscapeOrientation])
            [self performSegueWithIdentifier:@"toLandscapeProof" sender:self];
        else
            [self performSegueWithIdentifier:@"toPortraitProof" sender:self];

    }];

    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    // They can't cancel, fuck em
    
}


#pragma mark - Configuration

#pragma mark - View Lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    self.landscape = NO;  // This should probably be in an init method?
    self.cameraPickerUp = NO;
    
    }


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Start-up the WDT
    //[self performSelector:@selector(enableKickback) withObject:nil afterDelay:1.0];

    // We have to handle autorotate manually because the UIImagePicker doesn't let you lock it
    // We use a delegate from the root VC to propagate the changes (registering for changes isn't working correctly)
    //LandscapeNavController *lnv = (LandscapeNavController *)self.navigationController;
    //lnv.orientationDelegate = self;
    
    
    // Camera picker should only appear on entry/re-entry to this entire view.
    // NOT just because it has been dismissed. THis method gets called both cases, so this flag is here to
    // differentiate.
    
    if (!self.cameraPickerUp)
        [self startCamera];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark -
#pragma mark WDT Methods


- (void)disableKickback
{
    [self.wdt setEnabled:NO];
    [self.wdt kick];
    self.wdt = nil;
}

- (void)enableKickback
{
    if (self.wdt) {
        [self.wdt setEnabled:NO];
        self.wdt = nil;
    }
    
    self.wdt = [[ADWatchdogTimer alloc] initWithTriggerBlock:^{
        [self.myPicker dismissViewControllerAnimated:NO completion:nil];
        self.cameraPickerUp = NO;
        [self.navigationController popToRootViewControllerAnimated:YES];
    } interval:WDT_DELAY];
}




#pragma mark - Segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    
    ProofViewController *pvc = (ProofViewController *)segue.destinationViewController;
    pvc.proofImage = self.compositedPic;
    // Reset the camera picker up flag on the way out the front door
    self.cameraPickerUp = NO;
    
    
}

/*

-(void)orientationChanged:(NSUInteger)orientation{
    
    
    if (orientation==UIDeviceOrientationPortrait) {
        
        
         //self.cameraOverlay.transform = CGAffineTransformMakeRotation(3.141592/2);
    }
    
    else if(orientation==UIDeviceOrientationLandscapeLeft)
    {
        
       // self.cameraOverlay.transform = CGAffineTransformIdentity;
        
    }
    
}
 */

@end
