//
//  ViewController.m
//  IMYHTTP
//
//  Created by Ivan Chua on 15/4/3.
//  Copyright (c) 2015年 Ivan Chua. All rights reserved.
//

#import <ReactiveCocoa/RACSignal.h>
#import "ViewController.h"
#import "IMYHTTPBuilder.h"
#import "IMYHTTP.h"
#import "RACDisposable.h"
#import "ReactiveCocoa.h"

@interface ViewController ()
@property(nonatomic, strong) RACSignal *signal;
@property(nonatomic, strong) IMYHTTPBuilder *builder;
@property(nonatomic, strong) IMYHTTP *http;
@property(nonatomic, weak) RACDisposable *disposable;
@property(nonatomic, strong) RACSignal *racSignal;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor lightGrayColor];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    self.http = [IMYHTTP httpWithBaseURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    NSString *urlString = @"http://download.ime.sogou.com/1425624818/SogouInput_V3.1.0.66862_20150306_.dmg";
    @weakify(self);
    IMYHTTPBuilder *builder = IMYHTTPBuilder.new.GET().PATH(urlString).PROGRESSBLOCK(^(NSUInteger bytesRead, long long int totalBytesRead, long long int totalBytesExpectedToRead) {
        NSLog(@"index = %d progress = %f", self.navigationController.viewControllers.count, totalBytesRead / (totalBytesExpectedToRead * 1.0));

    }).PARAMETERS(@{@"test" : @"gogogo"});

//    self.disposable = [[_http getWithBuilder:builder] subscribeNext:^(id x) {
//
//    } completed:^{
//
//    }];

    self.racSignal = [_http getWithBuilder:builder];
    self.disposable = [_racSignal subscribeNext:^(id x) {

    } error:^(NSError *error) {

    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.disposable dispose];
}


- (void)tap:(id)sender
{
    [self.navigationController pushViewController:[ViewController new] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self.disposable dispose];
}


@end
