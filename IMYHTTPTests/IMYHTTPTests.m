//
//  IMYHTTPTests.m
//  IMYHTTPTests
//
//  Created by Ivan Chua on 15/4/3.
//  Copyright (c) 2015年 Ivan Chua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "IMYHTTP.h"
#import "RACSignal.h"
#import "RACTuple.h"
#import "IMYRequestSerializer.h"
#import "AFHTTPRequestOperation+IMYHTTP.h"
#import "AFHTTPRequestOperation.h"

@interface IMYHTTPTests : XCTestCase
@property(nonatomic, strong) IMYHTTP *http;
@end

@implementation IMYHTTPTests

- (void)setUp
{
    [super setUp];
    [IMYRequestSerializer setDefaultHeaders:@{@"test":@"haha"}];
    _http = [IMYHTTP httpWithBaseURL:[NSURL URLWithString:@"http://www.baidu.com"]];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGet
{
    [[_http get:@"http://meiyou.im/5" parameters:nil].logAll asynchronousFirstOrDefault:nil success:NULL error:NULL];

//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://meiyou.im/5"]]];
//    [operation.rac_start.logAll asynchronousFirstOrDefault:nil success:NULL error:NULL];
}


@end
