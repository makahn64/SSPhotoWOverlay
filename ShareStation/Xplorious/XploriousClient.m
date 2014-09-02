//
//  XploriousClient.m
//  SHTB
//
//  Created by Mitchell Kahn on 3/4/13.
//  Copyright (c) 2013 AppDelegates. All rights reserved.
//

#import "XploriousClient.h"
#import "ShareStationCustomer.h"
#import "ShareableBinary.h"
#import "InteractiveMediaExperience.h"

static const NSString *kXploriousClientEmail = @"ssemailer.php";
static const NSString *kClientPing = @"ping.php";
static const NSString *kClientURL = @"http://www.xplorious.com/ShareStationSupport";

@implementation XploriousClient

+ (XploriousClient *)sharedClient {
    static XploriousClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[XploriousClient alloc] initWithBaseURL:[NSURL URLWithString:kClientURL]];
    });
    
    return _sharedClient;
}

- (void)pingCallback:(void (^)(BOOL success))callbackBlock
{
    [self getPath:kClientPing
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if (callbackBlock) {
                  if ([operation responseString] && [[operation responseString] isEqualToString:@"I'm here."]) {
                      callbackBlock(YES);
                  } else {
                      callbackBlock(NO);
                  }
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (callbackBlock) callbackBlock(NO);
          }];
}


- (void)sendEmailUsingCustomerOrig:(ShareStationCustomer *)customer
                      callback:(void (^)(BOOL success))callbackBlock
           uploadProgressBlock:(void (^)(NSUInteger bytesWritten,
                                         long long totalBytesWritten,
                                         long long totalBytesExpectedToWrite))upLoadBlock
{
    ShareableBinary *binary = [customer.binariesForCustomer anyObject];
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObject:customer.email forKey:@"userEmail"];

    [params setObject:binary.experience.remoteID forKey:@"eventID"];

    //NSData *imageData = binary.dfData; //UIImageJPEGRepresentation([customer imageTicket], 0.5);
    
    NSString *fn = [NSString stringWithFormat:@"share-%@-ev%@.png", [customer.email stringByReplacingOccurrencesOfString:@"@" withString:@"_at_"], binary.experience.remoteID];
    
    NSMutableURLRequest *request = [self multipartFormRequestWithMethod:@"POST"
                                                                   path:kXploriousClientEmail
                                                             parameters:params
                                              constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
                                                  [formData appendPartWithFileData:binary.dfData
                                                                              name:@"file"
                                                                          fileName:fn
                                                                          mimeType:@"image/png"];
                                              }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    NSManagedObjectContext *context = customer.managedObjectContext;
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"sendEmailUsingCustomer response (%d)!", [[operation response] statusCode]);
        
        [context performBlockAndWait:^{
            @try {
                //customer.cloudNodeID = [NSNumber numberWithInteger:[[responseObject objectForKey:@"nid"] integerValue]];
            } @catch (NSException *exception) {
                //customer.cloudNodeID = [NSNumber numberWithInteger:0];
            }
            customer.uploadedEmail = [NSNumber numberWithInteger:1]; // 1 means done
            
            [context save:nil];
            //NSLog(@"Check 1");
        }];
        
        //NSLog(@"Check 2");
        if (callbackBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //NSLog(@"Check 4");
                callbackBlock(YES);
            });
        }
        //NSLog(@"Check 3");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"sendEmailUsingCustomer HTTP status: %d", [[operation response] statusCode]);
        NSLog(@"sendEmailUsingCustomer NSError detail: %@", [[error userInfo] objectForKey:@"NSLocalizedDescription"]);
        NSLog(@"sendEmailUsingCustomer NSError error: %@", error );
        
        [context performBlockAndWait:^{
            customer.uploadedEmail = [NSNumber numberWithInteger:0]; // 0 means needs an attempt
            
            [context save:nil];
        }];
        
        if (callbackBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callbackBlock(NO);
            });
        }
        
    }];
    
    if (upLoadBlock) {
        [operation setUploadProgressBlock:upLoadBlock];
    }
    
    [operation setShouldExecuteAsBackgroundTaskWithExpirationHandler:^{
        NSLog(@"Background time remaining: %f",[[UIApplication sharedApplication] backgroundTimeRemaining]);
        
        // Need to set it idle to try next time...
        //[self cancelUpload:xn];
        [context performBlockAndWait:^{
            customer.uploadedEmail = [NSNumber numberWithInteger:0]; // 0 means needs an attempt
            
            [context save:nil];
        }];
    }];
    
    //NSLog(@"Sending Email");
    customer.uploadedEmail = [NSNumber numberWithInteger:-1]; // -1 means in progress
    [context save:nil];    
    [self enqueueHTTPRequestOperation:operation];
}

- (void)sendEmailUsingCustomer:(ShareStationCustomer *)customer
                      callback:(void (^)(BOOL success, NSString *msg))callbackBlock
           uploadProgressBlock:(void (^)(NSUInteger bytesWritten,
                                         long long totalBytesWritten,
                                         long long totalBytesExpectedToWrite))upLoadBlock
{
    
    
    
    @try {
        
        ShareableBinary *binary = [customer.binariesForCustomer anyObject];
        NSMutableDictionary *params = [NSMutableDictionary new];
        
        [params setObject:customer.email forKey:@"userEmail"];
        
        [params setObject:binary.experience.remoteID forKey:@"eventID"];
        
        //NSData *imageData = binary.dfData; //UIImageJPEGRepresentation([customer imageTicket], 0.5);
        
        NSString *fn = [NSString stringWithFormat:@"share-%@-ev%@.png", [customer.email stringByReplacingOccurrencesOfString:@"@" withString:@"_at_"], binary.experience.remoteID];
        
        NSMutableURLRequest *request = [self multipartFormRequestWithMethod:@"POST"
                                                                       path:kXploriousClientEmail
                                                                 parameters:params
                                                  constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
                                                      [formData appendPartWithFileData:binary.dfData
                                                                                  name:@"file"
                                                                              fileName:fn
                                                                              mimeType:@"image/png"];
                                                  }];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        NSManagedObjectContext *context = customer.managedObjectContext;
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"sendEmailUsingCustomer response (%d)!", [[operation response] statusCode]);
            
            [context performBlockAndWait:^{
                @try {
                    //customer.cloudNodeID = [NSNumber numberWithInteger:[[responseObject objectForKey:@"nid"] integerValue]];
                } @catch (NSException *exception) {
                    //customer.cloudNodeID = [NSNumber numberWithInteger:0];
                }
                customer.uploadedEmail = [NSNumber numberWithInteger:1]; // 1 means done
                
                [context save:nil];
                //NSLog(@"Check 1");
            }];
            
            //NSLog(@"Check 2");
            if (callbackBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //NSLog(@"Check 4");
                    callbackBlock(YES, @"Success!");
                });
            }
            //NSLog(@"Check 3");
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"sendEmailUsingCustomer HTTP status: %d", [[operation response] statusCode]);
            NSLog(@"sendEmailUsingCustomer NSError detail: %@", [[error userInfo] objectForKey:@"NSLocalizedDescription"]);
            NSLog(@"sendEmailUsingCustomer NSError error: %@", error );
            
            [context performBlockAndWait:^{
                customer.uploadedEmail = [NSNumber numberWithInteger:0]; // 0 means needs an attempt
                
                [context save:nil];
            }];
            
            if (callbackBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    callbackBlock(NO, [NSString stringWithFormat:@"Failed with code %d, error %@. Details: %@", [[operation response] statusCode],
                                       error,
                                       [[error userInfo] objectForKey:@"NSLocalizedDescription"]]);
                });
            }
            
        }];
        
        if (upLoadBlock) {
            [operation setUploadProgressBlock:upLoadBlock];
        }
        
        [operation setShouldExecuteAsBackgroundTaskWithExpirationHandler:^{
            NSLog(@"Background time remaining: %f",[[UIApplication sharedApplication] backgroundTimeRemaining]);
            
            // Need to set it idle to try next time...
            //[self cancelUpload:xn];
            [context performBlockAndWait:^{
                customer.uploadedEmail = [NSNumber numberWithInteger:0]; // 0 means needs an attempt
                
                [context save:nil];
            }];
        }];
        
        //NSLog(@"Sending Email");
        customer.uploadedEmail = [NSNumber numberWithInteger:-1]; // -1 means in progress
        [context save:nil];
        [self enqueueHTTPRequestOperation:operation];

        
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception happened sending email: %@", [exception reason]);
        
        if (!customer.email || [customer.email isEqualToString:@""]) {
            
            NSManagedObjectContext *context = customer.managedObjectContext;
            // Purge this entry, it's invalid

            [context performBlockAndWait:^{
                @try {
                    //customer.cloudNodeID = [NSNumber numberWithInteger:[[responseObject objectForKey:@"nid"] integerValue]];
                } @catch (NSException *exception) {
                    //customer.cloudNodeID = [NSNumber numberWithInteger:0];
                }
                customer.uploadedEmail = [NSNumber numberWithInteger:1]; // 1 means done
                
                [context save:nil];
                //NSLog(@"Check 1");
            }];

        }
        
        // THIS IS A FUCKING HACK
        if (callbackBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callbackBlock(YES, [NSString stringWithFormat:@"Failed with exception. Details: %@", [exception reason]  ]);
            });
        }

    }
    
}


@end
