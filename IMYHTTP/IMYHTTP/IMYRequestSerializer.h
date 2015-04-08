//
// Created by Ivan Chua on 15/4/3.
// Copyright (c) 2015 Ivan Chua. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPRequestOperation;
@class AFHTTPRequestSerializer;


typedef NS_ENUM(NSInteger, IMYRequestSerializerType)
{
    IMYRequestSerializerTypeJson,
    IMYRequestSerializerTypeBody,
    IMYRequestSerializerTypeForm
};


@interface IMYRequestSerializer : NSObject
+ (AFHTTPRequestSerializer *)requestSerializerOfType:(IMYRequestSerializerType)type;

+ (void)setDefaultHeaders:(NSDictionary *)headers;

+ (void)addValue:(id)value forHTTPHeaderField:(NSString *)field;
@end

