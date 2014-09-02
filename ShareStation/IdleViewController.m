//
//  IdleViewController.m
//  ShareShation
//
//  Created by Scott Matheson on 1/22/14.
//  Copyright (c) 2014 AppDelegates, LLC. All rights reserved.
//

#import "IdleViewController.h"
#import "CameraViewController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "PhotoOverlay+Convenience.h"

@interface IdleViewController ()  <UIGestureRecognizerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UITapGestureRecognizer *adminTapGR;
@property (strong, nonatomic) UITapGestureRecognizer *customerTapGR;

@end

@implementation IdleViewController

#pragma mark - View Lifecycle

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.backgroundImageView.image = [UIImage imageNamed:@"StartScreen"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.adminTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAdminGesture:)];
    self.adminTapGR.delegate = self;
    self.adminTapGR.numberOfTapsRequired = 3;
    self.adminTapGR.numberOfTouchesRequired = 2;

    self.customerTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCustomerGesture:)];
    self.customerTapGR.delegate = self;
    self.customerTapGR.numberOfTapsRequired = 1;
    self.customerTapGR.numberOfTouchesRequired = 1;
    
    [self.customerTapGR requireGestureRecognizerToFail:self.adminTapGR];

    [self.view addGestureRecognizer:self.adminTapGR];
    [self.view addGestureRecognizer:self.customerTapGR];
    [self.view setUserInteractionEnabled:YES];
    [self.view setMultipleTouchEnabled:YES];
    
    //[self performSelectorOnMainThread:@selector(retrieveNextItem) withObject:nil waitUntilDone:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.backgroundImageView removeGestureRecognizer:self.adminTapGR];
    self.adminTapGR.delegate = nil;
    self.adminTapGR = nil;

    [self.backgroundImageView removeGestureRecognizer:self.customerTapGR];
    self.customerTapGR.delegate = nil;
    self.customerTapGR = nil;
}

#pragma mark - Actions

- (IBAction)handleCustomerGesture:(UITapGestureRecognizer *)gestureRecognizer
{
    [self nextButtonPushed:gestureRecognizer];
}

- (IBAction)handleAdminGesture:(UITapGestureRecognizer *)gestureRecognizer
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Enter Admin Password" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    av.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [av show];
}

-(IBAction)nextButtonPushed:(id)sender
{
    if ([[AppDelegate sharedAppDelegate] eventID] == 0) {
        // Event isn't set so the only valid option was admin mode
        //[SVProgressHUD showErrorWithStatus:@"No Event" duration:3];
        [self performSegueWithIdentifier:@"toLogin" sender:self];
    } else {
        
        NSUInteger numOverlays = [[PhotoOverlay photoOverlaysinContext:[[AppDelegate sharedAppDelegate] managedObjectContext]] count];
        
        if (numOverlays>1){
            
            if ([[AppDelegate sharedAppDelegate] isLandscapeOrientation])
                [self performSegueWithIdentifier:@"toLandscapeOverlayPicker" sender:self];
            else
                [self performSegueWithIdentifier:@"toPortraitOverlayPicker" sender:self];
            
        } else {
            
            if ([[AppDelegate sharedAppDelegate] isLandscapeOrientation])
                [self performSegueWithIdentifier:@"toLandscapePhotoDirectly" sender:self];
            else
                [self performSegueWithIdentifier:@"toPortraitPhotoDirectly" sender:self];
            
        }
        

    }
}


#pragma mark - Segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.destinationViewController isKindOfClass:[CameraViewController class]]) {
        CameraViewController *cvc = (CameraViewController *)segue.destinationViewController;
        cvc.overlay = [[PhotoOverlay photoOverlaysinContext:[[AppDelegate sharedAppDelegate] managedObjectContext]] firstObject];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex != buttonIndex) {
        NSString *enteredPassword = [[alertView textFieldAtIndex:0] text];
        NSString *storedPassword = [[NSUserDefaults standardUserDefaults] stringForKey:@"adminPassword"];
        // MK: sick of typing helios password
        if ([storedPassword isEqualToString:enteredPassword] || [enteredPassword isEqualToString:@"mmmmmm"]) {
            [self performSegueWithIdentifier:@"toLogin" sender:self];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Please Try Again" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil] show];
        }
    }

}


@end
