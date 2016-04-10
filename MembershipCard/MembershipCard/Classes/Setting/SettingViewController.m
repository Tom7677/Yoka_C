//
//  SettingViewController.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/21.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "SettingViewController.h"
#import "WebViewController.h"
#import <SDImageCache.h>
#import "AppDelegate.h"


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
        WebViewController *vc = [[WebViewController alloc]initWithURLString:ABOUTUS titleLabel:@"关于我们"];
        vc.navigationController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (btn.tag == 2) {
        WebViewController *vc = [[WebViewController alloc]initWithURLString:TEMSOFUSE titleLabel:@"使用条款与法律声明"];
        vc.navigationController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (btn.tag == 3) {
        [[SDImageCache sharedImageCache]calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
            NSString *clearCacheName;
            if (totalSize < 1024 * 1024) {
                 clearCacheName = [NSString stringWithFormat:@"清理缓存(%.2fK)",(double)totalSize / 1024];
            }
            else {
                clearCacheName = [NSString stringWithFormat:@"清理缓存(%.2fM)",(double)totalSize / (1024 * 1024)];
            }
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认清除缓存？" message:clearCacheName preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
            }];
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [[SDImageCache sharedImageCache]clearDisk];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:otherAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }];
    }
    else {
        //退出登录
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"accessToken"];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认退出当前用户吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[AppDelegate appDelegate] goMainView];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}
@end
