//
//  ShareStationCustomer+Convenience.m
//  ShareStationPhotoOverlay
//
//  Created by Mitchell Kahn on 5/26/14.
//  Copyright (c) 2014 AppDelegates, LLC. All rights reserved.
//

#import "ShareStationCustomer+Convenience.h"

@implementation ShareStationCustomer (Convenience)

+(ShareStationCustomer *)createInContext:(NSManagedObjectContext *)context{
    
    ShareStationCustomer *ssc = nil;
    
    if (context!=nil) {
        
        // Does not exist, create
        NSLog(@"Creating new SSCustomer.");
        
        
        ssc = [NSEntityDescription insertNewObjectForEntityForName:@"ShareStationCustomer"
                                            inManagedObjectContext:context];
        ssc.uploadedToCloud = false;
        ssc.timeCreated = [NSNumber numberWithDouble:[[NSDate new] timeIntervalSince1970]];
        [context save:nil];
    }
    
    return ssc;
    
}

+(ShareStationCustomer *)createInContext:(NSManagedObjectContext *)context
                               withEmail:(NSString *)email
                                andPhoto:(UIImage *)photo
{
    ShareStationCustomer *ssc = [self createInContext:context];
    if (ssc)
    {
        ssc.photo = UIImagePNGRepresentation(photo);
        ssc.email = email;
    }
    return ssc;
}

+(NSArray *)getFailedUploadsInContext:(NSManagedObjectContext*)context{
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"ShareStationCustomer" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    // This comb of properties only happens if an upload passes thru the AFN upload and fails
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uploadedToCloud = 0 AND scheduledForUpload = 0"];
    
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;

    
}

@end
