//
// Created by Ivan on 15/4/3.
//
//


#import <AFNetworking/AFURLRequestSerialization.h>
#import "IMYRequestSerializer.h"

@interface IMY_BodyRequestSerializer : AFHTTPRequestSerializer
@end

@implementation IMY_BodyRequestSerializer

- (NSMutableURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                                      withParameters:(id)parameters
                                               error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(request);
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    [self.HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL *__unused stop) {
        if (![request valueForHTTPHeaderField:field])
        {
            [mutableRequest setValue:value forHTTPHeaderField:field];
        }
    }];
    NSAssert([parameters isKindOfClass:[NSString class]] || [parameters isKindOfClass:[NSNumber class]] || [parameters isKindOfClass:[NSData class]], @"parameters must be string");
    if (parameters)
    {
        NSData *HTTPBody = nil;
        if ([parameters isKindOfClass:[NSData class]])
        {
            NSData *data = (NSData *) parameters;
            HTTPBody = data;
        }
        else if ([parameters isKindOfClass:[NSString class]])
        {
            NSString *string = (NSString *) parameters;
            HTTPBody = [string dataUsingEncoding:NSUTF8StringEncoding];
        }
        else if ([parameters isKindOfClass:[NSNumber class]])
        {
            NSNumber *number = (NSNumber *) parameters;
            NSString *string = [number stringValue];
            HTTPBody = [string dataUsingEncoding:NSUTF8StringEncoding];
        }

        mutableRequest.HTTPBody = HTTPBody;
    }

    return mutableRequest;
}
@end

@interface IMYRequestSerializer ()
@property(nonatomic, strong) AFJSONRequestSerializer *jsonRequestSerializer;
@property(nonatomic, strong) AFHTTPRequestSerializer *formRequestSerializer;
@property(nonatomic, strong) IMY_BodyRequestSerializer *bodyRequestSerializer;
@end

@implementation IMYRequestSerializer


static IMYRequestSerializer *_sharedIMYRequestSerializer = nil;

+ (AFHTTPRequestSerializer *)requestSerializerOfType:(IMYRequestSerializerType)type
{
    switch (type)
    {
        case IMYRequestSerializerTypeBody:
        {
            return [self sharedIMYRequestSerializer].bodyRequestSerializer;
        }
        case IMYRequestSerializerTypeForm:
        {
            return [self sharedIMYRequestSerializer].formRequestSerializer;
        }
        case IMYRequestSerializerTypeJson:
        {

        }
        default:
        {
            return [self sharedIMYRequestSerializer].jsonRequestSerializer;;
        }
    }
}


+ (IMYRequestSerializer *)sharedIMYRequestSerializer
{
    static dispatch_once_t singleton;
    dispatch_once(&singleton, ^{
        _sharedIMYRequestSerializer = [[self alloc] init];
    });
    return _sharedIMYRequestSerializer;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.jsonRequestSerializer = [AFJSONRequestSerializer serializer];
        self.formRequestSerializer = [AFHTTPRequestSerializer serializer];
        self.bodyRequestSerializer = [IMY_BodyRequestSerializer serializer];
    }
    return self;
}


+ (void)setDefaultHeaders:(NSDictionary *)headers
{
    [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [[self sharedIMYRequestSerializer].bodyRequestSerializer setValue:obj forHTTPHeaderField:key];
        [[self sharedIMYRequestSerializer].jsonRequestSerializer setValue:obj forHTTPHeaderField:key];
        [[self sharedIMYRequestSerializer].formRequestSerializer setValue:obj forHTTPHeaderField:key];
    }];
}

+ (void)addValue:(id)value forHTTPHeaderField:(NSString *)field
{
    [[self sharedIMYRequestSerializer].bodyRequestSerializer setValue:value forHTTPHeaderField:field];
    [[self sharedIMYRequestSerializer].jsonRequestSerializer setValue:value forHTTPHeaderField:field];
    [[self sharedIMYRequestSerializer].formRequestSerializer setValue:value forHTTPHeaderField:field];
}


@end
