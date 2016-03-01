//
//  SettingViewController.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/21.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "SettingViewController.h"
#import "ShowDeteledCardViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户设置";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnAction:(id)sender {
    UIButton *btn = sender;
    if (btn.tag == 1) {
        //分享到微信
        
    }
    else if (btn.tag == 2) {
        //已删除会员卡
        ShowDeteledCardViewController  *vc = [[ShowDeteledCardViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (btn.tag == 3) {
        //清除缓存
        
    }
    else if (btn.tag == 4) {
        //使用条款
    }
    else if (btn.tag == 5) {
        //关于我们
    }
    else if (btn.tag == 6) {
        //给好评
        NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1085934881" ];
        if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)){
            str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id1085934881"];
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    else {
        //退出登录
    }
    
}
@end
