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
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0x808080)} forState:UIControlStateNormal];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    //卡包
    MyCardBagViewController *myCardBagVC = [[MyCardBagViewController alloc]init];
    UINavigationController *myCardBagNav = [[UINavigationController alloc]initWithRootViewController:myCardBagVC];
    UIImage *myCardBagImg = [UIImage imageNamed:@"tabbar_myCardBag_selected@3x"];
    myCardBagImg =  [myCardBagImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *myCardBagItem = [[UITabBarItem alloc]initWithTitle:@"卡包" image:[UIImage imageNamed:@"tabbar_myCardBag@3x"] selectedImage:myCardBagImg];
    myCardBagItem.tag = 1;
    myCardBagVC.tabBarItem = myCardBagItem;
    
    //发现
    DisoveryViewController *discoveryVC = [[DisoveryViewController alloc]init];
    UINavigationController *discoveryNav = [[UINavigationController alloc]initWithRootViewController:discoveryVC];
    UIImage *discoveryImg = [UIImage imageNamed:@"tabbar_discovery_selected"];
    discoveryImg =  [discoveryImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *discoveryItem = [[UITabBarItem alloc]initWithTitle:@"发现" image:[UIImage imageNamed:@"tabbar_discovery"] selectedImage:discoveryImg];
    myCardBagItem.tag = 2;
    discoveryVC.tabBarItem = discoveryItem;
    
    //更多
    MoreViewController *martVC = [[MoreViewController alloc]init];
    UINavigationController *martNav = [[UINavigationController alloc]initWithRootViewController:martVC];
    UIImage *martImg = [UIImage imageNamed:@"tabbar_more_selected"];
    martImg = [martImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *martItem = [[UITabBarItem alloc]initWithTitle:@"更多" image:[UIImage imageNamed:@"tabbar_more"] selectedImage:martImg];
    martItem.tag = 3;
    martVC.tabBarItem = martItem;
    
    self.viewControllers = @[myCardBagNav,discoveryNav,martNav];
    for (UINavigationController *navController in self.viewControllers) {
        navController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3);
        navController.tabBarItem.image = [navController.tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
