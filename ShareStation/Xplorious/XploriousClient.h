//
//  XploriousClient.h
//  DrupalAFNTest
//
//  Created by Mitchell Kahn on 3/4/13.
//  Copyright (c) 2013 AppDelegates. All rights reserved.
//

@class ShareStationCustomer;

@interface XploriousClient : AFHTTPClient

+(XploriousClient *)sharedClient;

- (void)pingCallback:(void (^)(BOOL success))callbackBlock;

- (void)sendEmailUsingCustomer:(ShareStationCustomer *)customer
                      callback:(void (^)(BOOL success, NSString *msg))callbackBlock
           uploadProgressBlock:(void (^)(NSUInteger bytesWritten,
                                         long long totalBytesWritten,
                                         long long totalBytesExpectedToWrite))upLoadBlock;

@end
