//
// Created by Ivan Chua on 15/4/7.
// Copyright (c) 2015 Ivan Chua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMYRequestSerializer.h"
#import "AFHTTPRequestOperation.h"

typedef NS_ENUM(NSInteger, HttpMethod)
{
    HttpGet,
    HTTPPost,
    HTTPPut,
    HTTPDelete,
    HTTPHead
};

@class IMYHTTPBuilder;

typedef IMYHTTPBuilder *(^PATH)(NSString *path);

typedef IMYHTTPBuilder *(^HOST)(NSString *host);

typedef IMYHTTPBuilder *(^PARAMETERS)(id parameters);

typedef IMYHTTPBuilder *(^REQUESTSERIALIZERTYPE)(IMYRequestSerializerType type);

typedef IMYHTTPBuilder *(^URLQUERIES)(NSDictionary *urlQueries);

typedef IMYHTTPBuilder *(^HEADERS)(NSDictionary *headers);

typedef IMYHTTPBuilder *(^METHOD)(HttpMethod httpMethod);

typedef IMYHTTPBuilder *(^GET)();

typedef IMYHTTPBuilder *(^POST)();

typedef IMYHTTPBuilder *(^PUT)();

typedef IMYHTTPBuilder *(^DELETE)();

typedef IMYHTTPBuilder *(^HEAD)();

typedef void(^FormDataBlock)(id <AFMultipartFormData> formData);

typedef void(^ProgressBlock)(NSUInteger bytesRead, long long int totalBytesRead, long long int totalBytesExpectedToRead);

typedef IMYHTTPBuilder *(^FORMDATA)(FormDataBlock formDataBlock);

typedef IMYHTTPBuilder *(^PROGRESSBLOCK)(ProgressBlock progressBlock);

@interface IMYHTTPBuilder : NSObject

@property(nonatomic, strong) NSString *path;
@property(nonatomic, strong) NSString *host;
@property(nonatomic, strong) id parameters;
@property(nonatomic, assign) IMYRequestSerializerType requestSerializerType;
@property(nonatomic, strong) NSDictionary *urlQueries;
@property(nonatomic, strong) NSDictionary *headers;
@property(nonatomic, copy) FormDataBlock formDataBlock;
@property(nonatomic, copy) ProgressBlock progressBlock;
@property(nonatomic, strong,readonly) NSString *method;

@property(nonatomic, readonly) PATH PATH;
@property(nonatomic, readonly) HOST HOST;
@property(nonatomic, readonly) PARAMETERS PARAMETERS;
@property(nonatomic, readonly) REQUESTSERIALIZERTYPE REQUESTSERIALIZERTYPE;
@property(nonatomic, readonly) URLQUERIES URLQUERIES;
@property(nonatomic, readonly) METHOD METHOD;
@property(nonatomic, readonly) HEADERS HEADERS;
@property(nonatomic, readonly) FORMDATA FORMDATA;
@property(nonatomic, readonly) GET GET;
@property(nonatomic, readonly) POST POST;
@property(nonatomic, readonly) PUT PUT;
@property(nonatomic, readonly) DELETE DELETE;
@property(nonatomic, readonly) HEAD HEAD;
@property(nonatomic, readonly) PROGRESSBLOCK PROGRESSBLOCK;

@end