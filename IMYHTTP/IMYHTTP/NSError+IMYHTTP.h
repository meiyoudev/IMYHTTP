//
// Created by Ivan Chua on 15/4/7.
// Copyright (c) 2015 Ivan Chua. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPRequestOperation;

@interface NSError (IMYHTTP)
@property AFHTTPRequestOperation *requestOperation;
@end