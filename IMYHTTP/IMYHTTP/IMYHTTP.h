//
// Created by Ivan Chua on 15/4/7.
// Copyright (c) 2015 Ivan Chua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"
#import "IMYHTTPBuilder.h"

@class RACSignal;
@class IMYHTTPBuilder;
@class AFHTTPRequestOperationManager;


@interface IMYHTTP : NSObject

@property(nonatomic, strong, readonly) AFHTTPRequestOperationManager *requestOperationManager;

+ (instancetype)httpWithBaseURL:(NSURL *)baseURL;

- (void)setDefaultHttpHeaders:(NSDictionary *)headers;

- (void)setDefaultURLQueries:(NSDictionary *)urlQueries;

- (RACSignal *)get:(NSString *)path parameters:(id)parameters;

- (RACSignal *)post:(NSString *)path parameters:(id)parameters;

- (RACSignal *)post:(NSString *)path parameters:(id)parameters constructingBodyWithBlock:(FormDataBlock)block;

- (RACSignal *)head:(NSString *)path parameters:(id)parameters;

- (RACSignal *)put:(NSString *)path parameters:(id)parameters;

- (RACSignal *)delete:(NSString *)path parameters:(id)parameters;

- (RACSignal *)getWithBuilder:(IMYHTTPBuilder *)builder;

- (RACSignal *)postWithBuilder:(IMYHTTPBuilder *)builder;

- (RACSignal *)headWithBuilder:(IMYHTTPBuilder *)builder;

- (RACSignal *)putWithBuilder:(IMYHTTPBuilder *)builder;

- (RACSignal *)deleteWithBuilder:(IMYHTTPBuilder *)builder;

- (AFHTTPRequestOperation *)operationWithBuilder:(IMYHTTPBuilder *)builder;

- (RACSignal *)enqueueHTTPRequestOperation:(AFHTTPRequestOperation *)operation;
@end