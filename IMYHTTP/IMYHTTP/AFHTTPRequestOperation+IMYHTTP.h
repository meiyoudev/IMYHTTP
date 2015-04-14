//
// Created by Ivan Chua on 15/4/7.
// Copyright (c) 2015 Ivan Chua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"

@class RACSignal;

@interface NSError(IMYHTTP)
@property AFHTTPRequestOperation *requestOperation;
@end

@interface AFHTTPRequestOperation (IMYHTTP)
- (RACSignal *)rac_start;

- (RACSignal *)rac_overrideHTTPCompletionBlock;

@end