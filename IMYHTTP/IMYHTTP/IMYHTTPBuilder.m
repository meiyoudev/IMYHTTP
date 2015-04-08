//
// Created by Ivan on 15/4/7.
//
//


#import "IMYHTTPBuilder.h"


@interface IMYHTTPBuilder ()
@property(nonatomic, strong) NSString *method;
@end

@implementation IMYHTTPBuilder

static inline NSString *StringOfMethod(HttpMethod httpMethod) {
    switch (httpMethod)
    {
        case HttpGet:
            return @"GET";
        case HTTPPost:
            return @"POST";
        case HTTPPut:
            return @"PUT";
        case HTTPDelete:
            return @"DELETE";
        case HTTPHead:
            return @"HEAD";
        default:
            return @"";
    }
}


- (PATH)PATH
{
    return ^IMYHTTPBuilder *(NSString *path) {
        self.path = path;
        return self;
    };
}

- (HOST)HOST
{
    return ^IMYHTTPBuilder *(NSString *host) {
        self.host = host;
        return self;
    };
}

- (PARAMETERS)PARAMETERS
{
    return ^IMYHTTPBuilder *(id parameters) {
        self.parameters = parameters;
        return self;
    };
}

- (REQUESTSERIALIZERTYPE)REQUESTSERIALIZERTYPE
{
    return ^IMYHTTPBuilder *(IMYRequestSerializerType type) {
        self.requestSerializerType = type;
        return self;
    };
}

- (URLQUERIES)URLQUERIES
{
    return ^IMYHTTPBuilder *(NSDictionary *urlQueries) {
        self.urlQueries = urlQueries;
        return self;
    };
}

- (METHOD)METHOD
{
    return ^IMYHTTPBuilder *(HttpMethod httpMethod) {
        self.method = StringOfMethod(httpMethod);
        return self;
    };
}

- (HEADERS)HEADERS
{
    return ^IMYHTTPBuilder *(NSDictionary *headers) {
        self.headers = headers;
        return self;
    };
}

- (FORMDATA)FORMDATA
{
    return ^IMYHTTPBuilder *(FormDataBlock formDataBlock) {
        self.formDataBlock = formDataBlock;
        return self;
    };
}

- (GET)GET
{
    return ^IMYHTTPBuilder * {
        return self.METHOD(HttpGet);
    };
}

- (POST)POST
{
    return ^IMYHTTPBuilder * {
        return self.METHOD(HTTPPost);
    };
}

- (PUT)PUT
{
    return ^IMYHTTPBuilder * {
        return self.METHOD(HTTPPut);
    };
}

- (DELETE)DELETE
{
    return ^IMYHTTPBuilder * {
        return self.METHOD(HTTPDelete);
    };
}

- (HEAD)HEAD
{
    return ^IMYHTTPBuilder * {
        return self.METHOD(HTTPHead);
    };
}

- (PROGRESSBLOCK)PROGRESSBLOCK
{
    return ^IMYHTTPBuilder *(ProgressBlock progressBlock) {
        self.progressBlock = progressBlock;
        return self;
    };
}


- (void)dealloc
{
    NSLog(@"builder dealloc");
}


@end