//
//  ShareStationCustomer.h
//  ShareStationPhotoOverlay
//
//  Created by Mitchell Kahn on 5/27/14.
//  Copyright (c) 2014 AppDelegates, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ShareStationCustomer : NSManagedObject

@property (nonatomic, retain) NSNumber * acceptsSpam;
@property (nonatomic, retain) NSNumber * acceptsTCs;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * eventId;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * nameFirstName;
@property (nonatomic, retain) NSString * nameLastName;
@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) NSString * postalCode;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * street1;
@property (nonatomic, retain) NSString * street2;
@property (nonatomic, retain) NSNumber * timeCreated;
@property (nonatomic, retain) NSNumber * uploadedToCloud;
@property (nonatomic, retain) NSNumber * scheduledForUpload;

@end
