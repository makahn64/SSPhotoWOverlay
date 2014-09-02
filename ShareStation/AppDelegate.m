//
//  AppDelegate.m
//  ShareShation
//
//  Created by Scott Matheson on 1/15/14.
//  Copyright (c) 2014 AppDelegates, LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "PhotoOverlay+Convenience.h"
#import "ShareStationCustomer+Convenience.h"
//#import "UIApplication+SSToolkitAdditions.h"
//#import "XploriousClient.h"
//#import "InteractiveMediaExperience.h"
//#import "ShareStationFetcher.h"

@interface AppDelegate()

@property NSOperationQueue *operationQueue;

@end



@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize eventID = _eventID;
@synthesize selfieMode = _selfieMode;


#pragma mark -
#pragma mark Convenience

+ (AppDelegate *)sharedAppDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


#pragma mark -
#pragma mark Lifecycle Methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [self initAFNetworking];

    // Default defaults
    [self registerDefaults];
    
    

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"Background");
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"Foreground");
    

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    // Take a reading on startup
    [self orientationChanged:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    //[[SSManagedObject mainQueueContext] save:nil];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark -
#pragma mark Application's Settings

-(NSString *)getBaseURL {
    //return @"http://192.168.1.24/sharestation/ss";
    return @"http://www.xplorious.com/sharestation/ss";
}

- (BOOL)appOutOfDate
{
    return NO;
}

- (BOOL)networkSmallBatches
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"networkSmallBatches"];
}

- (void)setNetworkSmallBatches:(BOOL)newBOOL
{
    [[NSUserDefaults standardUserDefaults] setBool:newBOOL forKey:@"networkSmallBatches"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)selfieMode
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"selfieMode"];
}

- (void)setSelfieMode:(BOOL)selfieMode
{
    [[NSUserDefaults standardUserDefaults] setBool:selfieMode forKey:@"selfieMode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (BOOL)networkDisabled
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"networkDisabled"];
}

- (void)setNetworkDisabled:(BOOL)newBOOL
{
    [[NSUserDefaults standardUserDefaults] setBool:newBOOL forKey:@"networkDisabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)registerDefaults
{
    NSDictionary *appDefaults = @{
                                  @"adminPassword": @"appd3l3gat3s",
                                  @"username": @"restclient",
                                  @"password": @"r3stcli3nt",
                                  @"networkDisabled": @(NO),
                                  @"networkSmallBatches": @(YES),
                                  @"eventID": @(0),
                                  @"eventPwd": @"",
                                  @"binaryLookBackTime": @"1",
                                  @"binaryLookBackPeriod": @"Hour",
                                  };
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    
}

- (NSUInteger)eventID
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"eventID"];
}

- (void)setEventID:(NSUInteger)newEventID
{
    [[NSUserDefaults standardUserDefaults] setInteger:newEventID forKey:@"eventID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)eventPwd
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"eventPwd"];
}

- (void)setEventPwd:(NSString *)newEventPwd
{
    [[NSUserDefaults standardUserDefaults] setObject:newEventPwd forKey:@"eventPwd"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (NSDictionary *)eventDict {
    NSDictionary *oldCopy = [[NSUserDefaults standardUserDefaults] objectForKey:@"eventDict"];
    if (oldCopy==nil)
        [self getEventInformation];
    
    return oldCopy;
}

-(void) setEventDict:(NSDictionary *)eventDict{
    [[NSUserDefaults standardUserDefaults] setObject:eventDict forKey:@"eventDict"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - Synching


+(BOOL)isSynching{
  
    return  NO;
}


//TODO Why are these static methids on a singleton?

// None of these are used in this app, but left here for future versions.

+(void)setSynching:(BOOL)on{
    AppDelegate *ad = [AppDelegate sharedAppDelegate];
    ad.syncInProgress = on;
}

+(void)setSynchMessage:(NSString *)message{
    AppDelegate *ad = [AppDelegate sharedAppDelegate];
    ad.syncLabelText = message;
}

+(void)setSynchProgress:(float)progress{
    AppDelegate *ad = [AppDelegate sharedAppDelegate];
    ad.syncProgress = progress;
}

+(float)getSyncProgress{
    AppDelegate *ad = [AppDelegate sharedAppDelegate];
    return ad.syncProgress;
}

+(NSString *)getSyncMessage{
    AppDelegate *ad = [AppDelegate sharedAppDelegate];
    return ad.syncLabelText;
}



#pragma mark - Core Data Convenience Functions

- (void)reloadCoreData
{

}


#pragma mark - Login

- (void)login:(void (^)(BOOL success))callbackBlock
{
    NSLog(@"Login called");
        
}



#pragma mark - Shared AFNetworking

-(void) initAFNetworking{
    
    NSURL *baseURL = [NSURL URLWithString:[self getBaseURL]];
    self.afnManager  = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    
    self.operationQueue = self.afnManager.operationQueue;
    __weak typeof(self) weakSelf = self;

    [self.afnManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"[AppDel] Network is reachable");
                weakSelf.networkReachable = YES;
                [weakSelf.operationQueue setSuspended:NO];
                [weakSelf reinstateFailedUploads];
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                [weakSelf.operationQueue setSuspended:YES];
                NSLog(@"[AppDel] Network is NOT reachable");
                weakSelf.networkReachable = NO;
                break;
        }
    }];
    
    // This is conveniently not in the docs!
    [self.afnManager.reachabilityManager startMonitoring];

}

-(void) getEventInformation {
    
    if (self.eventID > 0)
    {
        NSLog(@"No saved event info, I'm not fecthing that shit!");
        return;
    }
    
    [self getEventInformationForEvent:self.eventID withPwd:self.eventPwd];
}

-(void) processOverlays {
    // if we got here, we have new overlays to add to core data
    // Ideally, we would check to see if there are actual changes to the overlays, but in this version we will just blow away the
    // old an load the new.
    //TODO more intelligent handling
    NSUInteger nuked = [PhotoOverlay nukeAllinContext:self.managedObjectContext];
    NSLog(@"Nuked %ld photo overlays!", nuked);
    for (NSString *url in [self.eventDict objectForKey:@"overlays"]) {
        [PhotoOverlay createUsingURL:url inContext:self.managedObjectContext];
    }
    
}

-(void) getEventInformationForEvent:(NSUInteger)eventId withPwd:(NSString *)pwd{
    
    NSString *url = [NSString stringWithFormat:@"%@/event/%ld",[self getBaseURL], eventId];
    
    
    
    [self.afnManager POST:url parameters:@{@"pwd":pwd} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        self.eventDict = responseObject;
        self.eventID = eventId;
        self.eventPwd = pwd;
        if ([[self.eventDict objectForKey:@"overlays"] count]>0){
            [self processOverlays];
        } else {
            [self notifiyEventUpdate];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"EVENT_UPDATE_FAILED" object:self];

    }];

}

-(void)notifiyEventUpdate {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EVENT_UPDATE" object:self];

}

-(void)notifyCompletedUpload:(ShareStationCustomer *)ssc{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPLOAD_OK"
                                                        object:self
                                                      userInfo:@{@"userEmail":ssc.email}];
}

-(void)notifyFailedUpload:(ShareStationCustomer *)ssc{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPLOAD_FAILED"
                                                        object:self
                                                      userInfo:@{@"userEmail":ssc.email}];
}

-(void)turnOnPHPDebugging{
    // inserts the header needed to set breakpoints
    self.afnManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.afnManager.requestSerializer setValue:@"XDEBUG_SESSION=1" forHTTPHeaderField:@"Cookie"];
}

-(void)newCustomerAdded:(ShareStationCustomer *)ssc {
    
    NSDictionary *parameters = @{@"userEmail": ssc.email, @"sendEmail": @"1"};
    NSString *urlPath = [NSString stringWithFormat:@"%@/ime/%ld", [self getBaseURL], self.eventID];
    NSString *imgFileName = [NSString stringWithFormat:@"%@-%ld-%@.png", ssc.email, self.eventID, ssc.timeCreated];
    ssc.scheduledForUpload = @(YES);
    [self.managedObjectContext save:nil];
    
    //[self turnOnPHPDebugging];
    
    [self.afnManager POST:urlPath
       parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
           
        [formData appendPartWithFileData:ssc.photo name:@"file" fileName:imgFileName mimeType:@"image/png"];
           
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Success: %@", responseObject);
        ssc.uploadedToCloud = @(YES);
        ssc.scheduledForUpload = @(NO);
        [self.managedObjectContext save:nil];
        [self notifyCompletedUpload:ssc];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error uploading %@: %@", ssc.email, error);
        ssc.scheduledForUpload = @(NO);
        [self.managedObjectContext save:nil];
        [self notifyFailedUpload:ssc];
        
    }];
    
}

-(void)reinstateFailedUploads {
    NSArray *failed = [ShareStationCustomer getFailedUploadsInContext:self.managedObjectContext];
    if ([failed count]) {
        NSLog(@"[AppDel] There are %ld failed uploads to reschedule, getting on that!", [failed count]);
        for (ShareStationCustomer *ssc in failed) {
            [self newCustomerAdded:ssc];
        }
    }
}


#pragma mark -
#pragma Core Data shit

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ShareStation" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ShareStation.sqlite"];
    
    NSError *error = nil;
    
    // MK: Should provide lightweight migration to the model for delete, add properties
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


-(void)orientationChanged:(NSNotification *)notificaiton{
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    _isLandscapeOrientation = (orientation==UIDeviceOrientationLandscapeLeft) || (orientation==UIDeviceOrientationLandscapeRight);
    
}


@end
