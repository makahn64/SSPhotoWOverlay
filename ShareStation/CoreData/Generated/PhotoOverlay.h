//
//  PhotoOverlay.h
//  ShareStationPhotoOverlay
//
//  Created by Mitchell Kahn on 5/25/14.
//  Copyright (c) 2014 AppDelegates, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PhotoOverlay : NSManagedObject

@property (nonatomic, retain) NSData * overlayImgData;

@end
