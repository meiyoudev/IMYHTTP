//
//  AppDelegate.m
//  IMYHTTP
//
//  Created by Ivan Chua on 15/4/3.
//  Copyright (c) 2015年 Ivan Chua. All rights reserved.
//

#import <AFNetworking/AFHTTPRequestOperation.h>
#import <ReactiveCocoa/RACSignal.h>
#import "AppDelegate.h"
#import "ViewController.h"
#import "Aspects.h"
#import "IMYHTTP.h"

@interface AppDelegate ()
@property(nonatomic, strong) IMYHTTP *http;
@property(nonatomic, strong) AFHTTPRequestOperation *op;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    ViewController *viewController = [[ViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.window.rootViewController = navigationController;

    SEL sel = NSSelectorFromString(@"dealloc");
    [AFHTTPRequestOperation aspect_hookSelector:sel withOptions:AspectPositionBefore usingBlock:^(id <AspectInfo> s) {
        NSLog(@"s = %@", s.instance);
    } error:nil];

    self.http = [IMYHTTP httpWithBaseURL:[NSURL URLWithString:@"http://www.google.com"]];

//    AFHTTPRequestOperation *operation = [_http operationWithBuilder:IMYHTTPBuilder.new.PATH(@"http://file.seeyouyima.com/android/169.apk").METHOD(@"GET")];
//    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long int totalBytesRead, long long int totalBytesExpectedToRead) {
//        NSLog(@"totalBytesRead = %qi", totalBytesRead);
//    }];
//    [[_http enqueueHTTPRequestOperation:operation] subscribeNext:^(id x) {
//
//    } error:^(NSError *error) {
//
//    }];

//    IMYHTTPBuilder *builder = IMYHTTPBuilder.new.GET().PATH(@"http://download.ime.sogou.com/1425624818/SogouInput_V3.1.0.66862_20150306_.dmg");
//    [builder setProgressBlock:^(NSUInteger bytesRead, long long int totalBytesRead, long long int totalBytesExpectedToRead) {
////        NSLog(@"totalBytesRead = %f", totalBytesRead / (totalBytesExpectedToRead * 1.0));
//    }];
//    [[_http getWithBuilder:builder] subscribeNext:^(AFHTTPRequestOperation *x) {
//        NSData *data = x.responseData;
//        NSLog(@"data.length = %d", data.length);
//    } error:^(NSError *error) {
//        NSLog(@"error = %@", error);
//    }];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
