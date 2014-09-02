//
//  ShareStationCustomer+Convenience.h
//  ShareStationPhotoOverlay
//
//  Created by Mitchell Kahn on 5/26/14.
//  Copyright (c) 2014 AppDelegates, LLC. All rights reserved.
//

#import "ShareStationCustomer.h"

@interface ShareStationCustomer (Convenience)

+(ShareStationCustomer *)createInContext:(NSManagedObjectContext *)context;
+(ShareStationCustomer *)createInContext:(NSManagedObjectContext *)context
                               withEmail:(NSString *)email
                                andPhoto:(UIImage *)photo;
+(NSArray *)getFailedUploadsInContext:(NSManagedObjectContext*)context;

@end
