//
//  SettingViewController.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/21.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "SettingViewController.h"
#import "AboutViewController.h"


@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnAction:(id)sender {
    UIButton *btn = sender;
    if (btn.tag == 1 ) {
        
        //关于我们
        AboutViewController *vc = [[AboutViewController alloc]init];
        vc.urlStr = ABOUTUS;
        vc.navigationController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (btn.tag == 2) {
        //使用条款
        AboutViewController *vc = [[AboutViewController alloc]init];
        vc.urlStr = TEMSOFUSE;
        vc.navigationController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }

    else if (btn.tag == 3) {
        
    }
    else {
        //退出登录
    }
    
}
@end
