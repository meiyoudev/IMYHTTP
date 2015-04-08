//
// Created by Ivan on 15/4/7.
//
//


#import <ReactiveCocoa/RACDisposable.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "IMYHTTP.h"
#import "ReactiveCocoa.h"
#import "AFHTTPRequestOperationManager+IMYHTTP.h"
#import "NSError+IMYHTTP.h"


@interface IMYHTTP ()
@property(nonatomic, strong) AFHTTPRequestOperationManager *requestOperationManager;
@property(nonatomic, strong) NSURL *baseURL;
@property(nonatomic, strong) NSString *urlQueryString;
@end

@implementation IMYHTTP

+ (instancetype)httpWithBaseURL:(NSURL *)baseURL
{
    return [[self alloc] initWithBaseURL:baseURL];
}

- (instancetype)initWithBaseURL:(NSURL *)baseURL
{
    self = [self init];
    if (self)
    {
        self.baseURL = baseURL;
        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
        self.requestOperationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return self;
}

- (void)setDefaultHttpHeaders:(NSDictionary *)headers
{
    [IMYRequestSerializer setDefaultHeaders:headers];
}

- (void)setDefaultURLQueries:(NSDictionary *)urlQueries
{
    NSMutableArray *queries = [[NSMutableArray alloc] init];
    [urlQueries enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [queries addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
    }];
    self.urlQueryString = [queries componentsJoinedByString:@"&"];
}


- (RACSignal *)get:(NSString *)path parameters:(id)parameters
{
    return [self getWithBuilder:[IMYHTTPBuilder new].PATH(path).PARAMETERS(parameters)];
}

- (RACSignal *)post:(NSString *)path parameters:(id)parameters
{
    return [self postWithBuilder:[IMYHTTPBuilder new].PATH(path).PARAMETERS(parameters)];
}

- (RACSignal *)post:(NSString *)path parameters:(id)parameters constructingBodyWithBlock:(FormDataBlock)block
{
    return [self postWithBuilder:IMYHTTPBuilder.new.PATH(path).PARAMETERS(parameters).FORMDATA(block)];
}

- (RACSignal *)head:(NSString *)path parameters:(id)parameters
{
    return [self headWithBuilder:[IMYHTTPBuilder new].PATH(path).PARAMETERS(parameters)];
}

- (RACSignal *)put:(NSString *)path parameters:(id)parameters
{
    return [self putWithBuilder:[IMYHTTPBuilder new].PATH(path).PARAMETERS(parameters)];
}

- (RACSignal *)delete:(NSString *)path parameters:(id)parameters
{
    return [self deleteWithBuilder:[IMYHTTPBuilder new].PATH(path).PARAMETERS(parameters)];
}

- (RACSignal *)getWithBuilder:(IMYHTTPBuilder *)builder
{
    return [self racWithHttpBuilder:builder.GET()];
}

- (RACSignal *)postWithBuilder:(IMYHTTPBuilder *)builder
{
    return [self racWithHttpBuilder:builder.POST()];
}

- (RACSignal *)headWithBuilder:(IMYHTTPBuilder *)builder
{
    return [self racWithHttpBuilder:builder.HEAD()];
}

- (RACSignal *)putWithBuilder:(IMYHTTPBuilder *)builder
{
    return [self racWithHttpBuilder:builder.PUT()];
}

- (RACSignal *)deleteWithBuilder:(IMYHTTPBuilder *)builder
{
    return [self racWithHttpBuilder:builder.DELETE()];
}

- (RACSignal *)racWithHttpBuilder:(IMYHTTPBuilder *)builder
{
//    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
//        AFHTTPRequestOperation *requestOperation = [self operationWithBuilder:builder];
//        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//            [subscriber sendNext:operation.responseString];
//            [subscriber sendCompleted];
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            error.requestOperation = operation;
//            [subscriber sendError:error];
//        }];
//        [self.requestOperationManager.operationQueue addOperation:requestOperation];
//        return [RACDisposable disposableWithBlock:^{
//            [requestOperation cancel];
//        }];
//    }];

    AFHTTPRequestOperation *requestOperation = [self operationWithBuilder:builder];
    return [self.requestOperationManager rac_enqueueHTTPRequestOperation:requestOperation];

}

- (AFHTTPRequestOperation *)operationWithBuilder:(IMYHTTPBuilder *)builder
{
    AFHTTPRequestSerializer *requestSerializer = [IMYRequestSerializer requestSerializerOfType:builder.requestSerializerType];
    NSString *urlString = [self urlStringWithBuilder:builder];
    NSMutableURLRequest *request = nil;
    if ([builder.method isEqualToString:@"POST"] && builder.formDataBlock)
    {
        request = [requestSerializer multipartFormRequestWithMethod:builder.method URLString:urlString parameters:builder.parameters constructingBodyWithBlock:builder.formDataBlock error:nil];
    }
    else
    {
        request = [requestSerializer requestWithMethod:builder.method URLString:urlString parameters:builder.parameters error:nil];
    }
    [builder.headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request addValue:obj forHTTPHeaderField:key];
    }];
    AFHTTPRequestOperation *requestOperation = [self.requestOperationManager HTTPRequestOperationWithRequest:request success:nil failure:nil];
    if (builder.progressBlock)
    {
        if ([builder.method isEqualToString:@"POST"] || [builder.method isEqualToString:@"PUT"])
        {
            [requestOperation setUploadProgressBlock:builder.progressBlock];
        }
        else
        {
            [requestOperation setDownloadProgressBlock:builder.progressBlock];
        }
    }
    return requestOperation;
}

- (RACSignal *)enqueueHTTPRequestOperation:(AFHTTPRequestOperation *)operation
{
    return [self.requestOperationManager rac_enqueueHTTPRequestOperation:operation];
}


- (NSString *)urlStringWithBuilder:(IMYHTTPBuilder *)builder
{
    NSString *customHost = builder.host;
    NSString *urlString = builder.path;
    NSString *string = nil;
    if (customHost)
    {
        string = [[NSURL URLWithString:urlString relativeToURL:[NSURL URLWithString:customHost]] absoluteString];
    }
    else
    {
        string = [[NSURL URLWithString:urlString relativeToURL:self.requestOperationManager.baseURL] absoluteString];
    }
    NSMutableString *query = [[NSMutableString alloc] init];
    if (_urlQueryString)
    {
        [query appendString:_urlQueryString];
    }
    if (builder.urlQueries.count > 0)
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [builder.urlQueries enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [array addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
        }];
        NSString *appendQuery = [array componentsJoinedByString:@"&"];
        if (appendQuery)
        {
            [query appendString:appendQuery];
        }
    }
    if (query.length > 0)
    {
        if ([NSURL URLWithString:string].query)
        {
            string = [string stringByAppendingFormat:@"&%@", query];
        }
        else
        {
            string = [string stringByAppendingFormat:@"?%@", query];
        }
    }
    if (![NSURL URLWithString:string])
    {
        string = [string stringByAddingPercentEscapesUsingEncoding:4];
    }
    return [NSURL URLWithString:string relativeToURL:self.baseURL].absoluteString;
}

@end