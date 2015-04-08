//
// Created by Ivan on 15/4/7.
//
//


#import <ReactiveCocoa/RACSignal.h>
#import "AFHTTPRequestOperationManager+IMYHTTP.h"
#import "AFHTTPRequestOperation+IMYHTTP.h"


@implementation AFHTTPRequestOperationManager (IMYHTTP)
- (RACSignal *)rac_enqueueHTTPRequestOperation:(AFHTTPRequestOperation *)operation
{
    RACSignal *signal = [operation rac_overrideHTTPCompletionBlock];
    [self.operationQueue addOperation:operation];
    return signal;
}

@end