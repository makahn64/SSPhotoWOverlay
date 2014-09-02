//
//  PhotoOverlay+Convenience.m
//  ShareStationPhotoOverlay
//
//  Created by Mitchell Kahn on 5/25/14.
//  Copyright (c) 2014 AppDelegates, LLC. All rights reserved.
//

#import "PhotoOverlay+Convenience.h"


@implementation PhotoOverlay (Convenience)

+(void)createUsingURL:(NSString *)sourceURL inContext:(NSManagedObjectContext *)context{
    
    
    if (!(sourceURL==nil && context==nil)) {
        
        // Does not exist, create
        NSLog(@"Need to create this PhotoOverlay: %@", sourceURL);
        
        NSURL *nsurl = [NSURL URLWithString:sourceURL];
        NSURLRequest *req = [NSURLRequest requestWithURL:nsurl];
        
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
        requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Response: %@", responseObject);
            //_imageView.image = responseObject;
            PhotoOverlay  *po = [NSEntityDescription insertNewObjectForEntityForName:@"PhotoOverlay" inManagedObjectContext:context];
            po.overlayImgData = UIImagePNGRepresentation(responseObject);
            [context save:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"EVENT_UPDATE" object:self];

            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Image error: %@", error);
        }];
        [requestOperation start];
    }
    
}


+(NSArray *)photoOverlaysinContext:(NSManagedObjectContext *)context{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"PhotoOverlay" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
    
}

+(NSUInteger)nukeAllinContext:(NSManagedObjectContext *)context{
    
    NSArray *all = [self photoOverlaysinContext:context];
    
    for (PhotoOverlay *po in all){
        [context deleteObject:po];
    }
    
    [context save:nil];
    
    return [all count];
}

@end
