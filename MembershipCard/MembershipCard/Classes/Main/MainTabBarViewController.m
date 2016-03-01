//
//  MainTabBarViewController.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/21.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "Macro.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xE33572)} forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0x808080)} forState:UIControlStateNormal];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    //我的卡包
    MyCardBagViewController *myCardBagVC = [[MyCardBagViewController alloc]init];
    UINavigationController *myCardBagNav = [[UINavigationController alloc]initWithRootViewController:myCardBagVC];
    UIImage *myCardBagImg = [UIImage imageNamed:@"tabbar_myCardBag_selected@3x"];
    myCardBagImg =  [myCardBagImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *myCardBagItem = [[UITabBarItem alloc]initWithTitle:@"我的卡包" image:[UIImage imageNamed:@"tabbar_myCardBag@3x"] selectedImage:myCardBagImg];
    myCardBagItem.tag = 1;
    myCardBagVC.tabBarItem = myCardBagItem;
    
    //悠卡专享
    VIPViewController *VIPVC = [[VIPViewController alloc]init];
    UINavigationController *VIPNav = [[UINavigationController alloc]initWithRootViewController:VIPVC];
    UIImage *VIPImg = [UIImage imageNamed:@"tabbar_VIP_selected@3x"];
    VIPImg =  [VIPImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *VIPItem = [[UITabBarItem alloc]initWithTitle:@"会员专享" image:[UIImage imageNamed:@"tabbar_VIP@3x"] selectedImage:VIPImg];
    myCardBagItem.tag = 2;
    VIPVC.tabBarItem = VIPItem;
    
    MartViewController *martVC = [[MartViewController alloc]init];
    UINavigationController *martNav = [[UINavigationController alloc]initWithRootViewController:martVC];
    UIImage *martImg = [UIImage imageNamed:@"tabbar_mart_selected@3x"];
    martImg = [martImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *martItem = [[UITabBarItem alloc]initWithTitle:@"悠卡商城" image:[UIImage imageNamed:@"tabbar_mart@3x"] selectedImage:martImg];
    martItem.tag = 3;
    martVC.tabBarItem = martItem;
    
    //账户设置
    SettingViewController *settingVC = [[SettingViewController alloc]init];
    UINavigationController *settingNav = [[UINavigationController alloc]initWithRootViewController:settingVC];
    UIImage *settingImg = [UIImage imageNamed:@"tabbar_setting_selected@3x"];
    settingImg = [settingImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *settingItem = [[UITabBarItem alloc]initWithTitle:@"账户设置" image:[UIImage imageNamed:@"tabbar_setting@3x"] selectedImage:settingImg];
    settingItem.tag = 4;
    settingVC.tabBarItem = settingItem;
    
    self.viewControllers = @[myCardBagNav,VIPNav,martNav,settingNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
