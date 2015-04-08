//
// Created by Ivan Chua on 15/4/7.
// Copyright (c) 2015 Ivan Chua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@class RACSignal;

@interface AFHTTPRequestOperationManager (IMYHTTP)
- (RACSignal *)rac_enqueueHTTPRequestOperation:(AFHTTPRequestOperation *)operation;
@end