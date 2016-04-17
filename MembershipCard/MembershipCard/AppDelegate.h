//
//  AppDelegate.h
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/21.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *umengAppKey =@"56cdb0bb67e58e696f003b86";
static NSString *userAgent = @"kdtUnion_demo";//  //kdtUnion_demo  注意UA的规范，UA一定是kdtUnion_xxx的规范
static NSString *appID = @"049a6ca527be198c76";///应用营销三方开放API出可以设置
static NSString *appSecret = @"b66a32a76b01b09e11c3fa1de1fd691f";//这里设置时候注意，UA一定是以kdtUnion_为前缀的，如果给您的UA是没有kdtUnion_的前缀，请联系墨迹，看UA是否给您的是正确的

//微信API
static NSString *wxID = @"wxdba2805b7841793e";
static NSString *wxSecret = @"1c710fc0d57a86762c1de4fd3f3a700a";

//JPush
static NSString *appKey = @"6e34b6625bca4c6fe576ace2";
static NSString *channel = @"App Store";
static BOOL isProduction = FALSE;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIView *lunchView;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger countTime;
@property (strong, nonatomic) UILabel *countLabel;

- (void)goMainView;
+ (AppDelegate*) appDelegate;
@end

