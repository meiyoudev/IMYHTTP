//
// Created by Ivan on 15/4/7.
//
//


#import <ReactiveCocoa/RACSignal.h>
#import <ReactiveCocoa/RACReplaySubject.h>
#import <ReactiveCocoa/RACDisposable.h>
#import "AFHTTPRequestOperation+IMYHTTP.h"


@implementation AFHTTPRequestOperation (IMYHTTP)
- (RACSignal *)rac_start
{
    RACSignal *racSignal = self.rac_overrideHTTPCompletionBlock;
    [self start];
    return racSignal;
}

- (RACSignal *)rac_overrideHTTPCompletionBlock
{
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        [self setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [subscriber sendNext:operation.responseString];
            [subscriber sendCompleted];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            [self cancel];
        }];
    }];

}
@end