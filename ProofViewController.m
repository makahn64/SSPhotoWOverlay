//
//  ProofViewController.m
//  ShareStationPhotoOverlay
//
//  Created by Mitchell Kahn on 5/25/14.
//  Copyright (c) 2014 AppDelegates, LLC. All rights reserved.
//

#import "ProofViewController.h"
#import "ShareStationCustomer+Convenience.h"
#import "AppDelegate.h"

@interface ProofViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *proofImageView;
@property (nonatomic) int state;
- (IBAction)nextPushed:(id)sender;
- (IBAction)backPushed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UILabel *yourEmailLabel;
@property (strong, nonatomic) IBOutlet UITextField *emailAddrTextField;

@end

@implementation ProofViewController

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

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
    self.proofImageView.image = self.proofImage;
    self.state = 0;
    self.emailAddrTextField.alpha = 0.0;
    self.yourEmailLabel.alpha = 0.0;
    self.emailAddrTextField.delegate = self;
    
    
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self nextPushed:nil];
    return NO;
}

-(void)bailToHome{
    
    [SVProgressHUD dismiss];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (IBAction)nextPushed:(id)sender {
    
    switch (self.state){
        case 0:{
            
            self.state = 1;
            self.backButton.hidden = YES;
            
            CGRect origFrame = self.proofImageView.frame;
            [UIView animateWithDuration: 0.5
                             animations:^{
                                 self.proofImageView.frame = CGRectMake(origFrame.origin.x-20,
                                                                        origFrame.origin.y-10,
                                                                        origFrame.size.width*0.5,
                                                                        origFrame.size.height*0.5);
                             } completion:^(BOOL finished) {
                                 [UIView animateWithDuration:0.5 animations:^{
                                     self.yourEmailLabel.alpha = 1.0;
                                     self.emailAddrTextField.alpha = 1.0;
                                 }];
                                 
                             }];
            
        }
            break;
            
        case 1:{
            if ([self validateEmail:self.emailAddrTextField.text]){
                ShareStationCustomer *ssc = [ShareStationCustomer createInContext:[[AppDelegate sharedAppDelegate] managedObjectContext]
                                                                        withEmail:self.emailAddrTextField.text andPhoto:self.proofImage];
                if (ssc){
                    [[AppDelegate sharedAppDelegate] newCustomerAdded:ssc];
                    [SVProgressHUD showSuccessWithStatus:@"Your Pic has been Emailed!"];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"Could not create new SSC, this is bad!"];
                }
                
                [self performSelector:@selector(bailToHome) withObject:self afterDelay:2.0];
                
            } else {
                [SVProgressHUD showErrorWithStatus:@"Bad Email Address"];
                
            }
        }
    }
    
}

- (IBAction)backPushed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
