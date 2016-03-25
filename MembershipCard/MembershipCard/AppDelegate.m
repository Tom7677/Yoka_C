//
//  AppDelegate.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/21.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "AppDelegate.h"
#import "GuideViewController.h"
#import "LoginViewController.h"
#import "MainTabBarViewController.h"
#import <MobClick.h>
#import "YZSDK.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        GuideViewController *guideVC = [[GuideViewController alloc]init];
        self.window.rootViewController = guideVC;
        [guideVC setEnterMainVC:^{
            [self goMainView];
            
        }];
    }
    else {
        [self goMainView];
    }
    //友盟统计配置
    [MobClick startWithAppkey:umengAppKey reportPolicy:BATCH channelId:@"App Store"];
    //账号统计
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    //使用集成测试模式
    [MobClick setLogEnabled:YES];
    //有赞86    [YZSDK setOpenDebugLog:YES];
    [YZSDK userAgentInit:userAgent version:@""];
    [YZSDK setOpenInterfaceAppID:appID appSecret:appSecret];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)goMainView
{
    NSString *accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"Mobile"];
    if (nil == accessToken || [@"" isEqualToString:accessToken]) {
        LoginViewController * vc = [[LoginViewController alloc] init];
        self.window.rootViewController = vc;
        [vc setLoginCallBack:^{
            [self showHomeVC];
        }];
    }
    else {
        [self showHomeVC];
    }
}

- (void)showHomeVC
{
    MainTabBarViewController *tabbarVC = [[MainTabBarViewController alloc]init];
    self.window.rootViewController = tabbarVC;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
