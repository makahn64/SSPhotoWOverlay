//
//  PhotoOverlay+Convenience.h
//  ShareStationPhotoOverlay
//
//  Created by Mitchell Kahn on 5/25/14.
//  Copyright (c) 2014 AppDelegates, LLC. All rights reserved.
//

#import "PhotoOverlay.h"

@interface PhotoOverlay (Convenience)

+(void)createUsingURL:(NSString *)sourceURL inContext:(NSManagedObjectContext *)context;

+(NSArray *)photoOverlaysinContext:(NSManagedObjectContext *)context;

+(NSUInteger)nukeAllinContext:(NSManagedObjectContext *)context;

@end
