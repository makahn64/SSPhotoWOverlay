//
//  AppDelegate.h
//  ShareShation
//
//  Created by Scott Matheson on 1/15/14.
//  Copyright (c) 2014 AppDelegates, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareStationCustomer.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

#pragma mark - Application's Settings

@property BOOL networkDisabled;
@property BOOL networkSmallBatches;

@property NSString * printerBaseURL;

@property NSUInteger eventID;
@property NSString * eventPwd;
@property NSDictionary * eventDict;
@property BOOL selfieMode;

//should be readonly but causes weak self complications in Reachability blocks, so fuck it
@property BOOL networkReachable;

@property AFHTTPRequestOperationManager *afnManager;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly) BOOL isLandscapeOrientation;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
+ (AppDelegate *)sharedAppDelegate;


- (void) reloadCoreData;


@property (nonatomic) BOOL syncInProgress;

@property (nonatomic, strong) NSString *syncLabelText;
@property (nonatomic) float syncProgress;
@property (nonatomic, strong) NSOperationQueue *netQueue;

-(void) getEventInformationForEvent:(NSUInteger)eventId withPwd:(NSString *)pwd;

+(BOOL)isSynching;
+(void)setSynching:(BOOL)on;

+(void)setSynchMessage:(NSString *)message;
+(void)setSynchProgress:(float)progress;
+(float)getSyncProgress;
+(NSString *)getSyncMessage;

-(void)newCustomerAdded:(ShareStationCustomer *)ssc;

@end
