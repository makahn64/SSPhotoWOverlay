//
//  EventSignInViewController.m
//  ShareStationPhotoOverlay
//
//  Created by Mitchell Kahn on 5/24/14.
//  Copyright (c) 2014 AppDelegates, LLC. All rights reserved.
//

#import "EventSignInViewController.h"
#import "AppDelegate.h"
#import "OverlayCell.h"
#import "PhotoOverlay+Convenience.h"

@interface EventSignInViewController ()

@property (weak, nonatomic) IBOutlet UITextField *eventIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *eventPwdTextField;
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (strong, nonatomic) NSArray *overlayArray;
@property (strong, nonatomic) IBOutlet UISwitch *selfieSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *pickOverlayEnabled;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)getEventInfoPushed:(id)sender;
- (IBAction)selfieModeChanged:(id)sender;
- (IBAction)proceedPressed:(id)sender;
- (IBAction)overlayPickerModeChanged:(id)sender;
@end

@implementation EventSignInViewController

- (void) loadOverlays {
    
    self.overlayArray = [PhotoOverlay photoOverlaysinContext:[[AppDelegate sharedAppDelegate] managedObjectContext]];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    int evid = [[AppDelegate sharedAppDelegate] eventID];
    if (evid)
        self.eventIDTextField.text = [NSString stringWithFormat:@"%d", evid];
    else
        self.eventIDTextField.placeholder = @"Enter event ID";
    
    self.eventPwdTextField.placeholder = @"Enter event passphrase";
    self.selfieSwitch.on = [[AppDelegate sharedAppDelegate] selfieMode];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(eventGetOK:)
                                                 name:@"EVENT_UPDATE"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(eventGetFailed:)
                                                 name:@"EVENT_UPDATE_FAILED"
                                               object:nil];
    
    self.eventPwdTextField.delegate = self;
    self.eventIDTextField.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)getEventInfoPushed:(id)sender {
    NSLog(@"Get event info pushed");
    int eventId = [self.eventIDTextField.text intValue];
    NSString *pwd = self.eventPwdTextField.text;
    [[AppDelegate sharedAppDelegate] getEventInformationForEvent:eventId withPwd:pwd];
    [SVProgressHUD showWithStatus:@"Getting Event Info"];
    [self.eventIDTextField resignFirstResponder];
    [self.eventPwdTextField resignFirstResponder];
}

- (IBAction)selfieModeChanged:(id)sender {
    UISwitch *sw = (UISwitch *)sender;
    [[AppDelegate sharedAppDelegate] setSelfieMode:sw.isOn];
    
}

- (IBAction)proceedPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)overlayPickerModeChanged:(id)sender {
}

-(void) eventGetOK:(NSNotification *)n{
    [SVProgressHUD showSuccessWithStatus:@"Event Upadated!"];
    self.eventNameLabel.text = [[[AppDelegate sharedAppDelegate] eventDict] objectForKey:@"title"];
    [self loadOverlays];
    [self.collectionView reloadData];
}

-(void) eventGetFailed:(NSNotification *)n{
    [SVProgressHUD showErrorWithStatus:@"Could not fetch event. Check password, event ID and internet connection."];

    
}

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    //NSString *searchTerm = self.searches[section];
    //return [self.searchResults[searchTerm] count];
    return [self.overlayArray count];
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    //return [self.searches count];
    return 1;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    OverlayCell *myCell = [self.collectionView
                                    dequeueReusableCellWithReuseIdentifier:@"overlayCell"
                                    forIndexPath:indexPath];
    
    UIImage *image;
    long row = [indexPath row];
    
    PhotoOverlay *po = self.overlayArray[row];
    
    image = [UIImage imageWithData:po.overlayImgData ];
    
    myCell.imageView.image = image;
    
    return myCell;
    
}
// 4
/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}


#pragma mark -
#pragma mark TextFied Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

// It is important for you to hide kwyboard

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==self.eventPwdTextField){
        [textField resignFirstResponder];
        [self getEventInfoPushed:nil];
    } else {
        [self.eventPwdTextField becomeFirstResponder];
    }

    return NO;

}



@end
