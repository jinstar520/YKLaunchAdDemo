//
//  AppDelegate.m
//  YKLaunchAd
//
//  Created by 聂金星 on 2017/4/1.
//  Copyright © 2017年 聂金星. All rights reserved.
//

#import "AppDelegate.h"
#import "YKLaunchAd.h"
#import "ViewController.h"

@interface AppDelegate ()<YKLaunchAdDelegate>

@end

@implementation AppDelegate

- (void)yk_willLoadAd:(YKLaunchAd *)launchAd {
    [self requestAdData:^(NSString *imgUrl, NSInteger duration) {
        [launchAd setImageUrl:imgUrl countdown:duration skipType:YKSkipTypeTimerText options:YKWebImageUseNSURLCache ];
    }];
}

- (void)yk_requestAdImageFinished:(YKLaunchAd *)launchAd {
    //在这里做些处理
    launchAd.adFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-100);
    launchAd.countdown = 6;
}

- (void)yk_willAdCountdownEnding:(YKLaunchAd *)launchAd {
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
}

- (void)yk_didAdClicked:(YKLaunchAd *)launchAd {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.baidu.com"] options:@{} completionHandler:^(BOOL success) {
        
    }];
}

/*
- (void)yk_customAdEndingAnimations:(void (^)())animations {
    [UIView transitionWithView:[[UIApplication sharedApplication].delegate window] duration:0.3 options: UIViewAnimationOptionTransitionCurlUp animations:^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        animations();
        [UIView setAnimationsEnabled:oldState];
    } completion:NULL];
}
*/

- (void)requestAdData:(void(^)(NSString *imgUrl, NSInteger duration))imageData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (imageData) {
            imageData(@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1793266724,3705164572&fm=23&gp=0.jpg", 5);
        }
    });
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    YKLaunchAd *launchAd = [[YKLaunchAd alloc] init];
    launchAd.delegate = self;
    
    launchAd.adFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height-100);
    launchAd.countdown = 6;
    launchAd.skipType = YKSkipTypeTimer;
    launchAd.adClickCountdownEnding = NO;
    [launchAd start];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
