//
//  OverlayPickerViewController.m
//  ShareStationPhotoOverlay
//
//  Created by Mitchell Kahn on 5/25/14.
//  Copyright (c) 2014 AppDelegates, LLC. All rights reserved.
//

#import "OverlayPickerViewController.h"
#import "OverlayPickerCell.h"
#import "PhotoOverlay+Convenience.h"
#import "AppDelegate.h"
#import "CameraViewController.h"

@interface OverlayPickerViewController ()

@property (strong, nonatomic) NSArray *overlayArray;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) int chosenOverlay;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)nextPressed:(UIButton *)sender;

@end

@implementation OverlayPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.overlayArray = [PhotoOverlay photoOverlaysinContext:[[AppDelegate sharedAppDelegate] managedObjectContext]];
    self.chosenOverlay = -1;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    
    OverlayPickerCell *myCell = [self.collectionView
                           dequeueReusableCellWithReuseIdentifier:@"overlayPickerCell"
                           forIndexPath:indexPath];
    
    UIImage *image;
    long row = [indexPath row];
    
    PhotoOverlay *po = self.overlayArray[row];
    
    image = [UIImage imageWithData:po.overlayImgData ];
    
    myCell.imageView.image = image;
    myCell.checkLabel.hidden = row != self.chosenOverlay;
    
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

    self.chosenOverlay = (int)[indexPath row];
    //This was here whaen we didn't auto-segue
    [self.collectionView reloadData];
    if ([[AppDelegate sharedAppDelegate] isLandscapeOrientation]) {
        [self performSegueWithIdentifier:@"toLandscapePhoto" sender:self];

    } else {
        [self performSegueWithIdentifier:@"toPortraitPhoto" sender:self];

    }

}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

#pragma mark Collection view layout things
// Layout: Set cell size

/*
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"SETTING SIZE FOR ITEM AT INDEX %d", indexPath.row);
    CGSize mElementSize = CGSizeMake(768/3, 1024/3);
    return mElementSize;
}
 */

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    CameraViewController *cvc = (CameraViewController *)segue.destinationViewController;
    cvc.overlay = self.overlayArray[self.chosenOverlay];
    
}


- (IBAction)nextPressed:(UIButton *)sender {
    
    if (self.chosenOverlay<0){
        [SVProgressHUD showErrorWithStatus:@"No Frame Chosen!"];
        return;
    }
    [self performSegueWithIdentifier:@"toPhoto" sender:self];
}
@end
