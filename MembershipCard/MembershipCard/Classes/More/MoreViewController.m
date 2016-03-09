//
//  MoreViewController.m
//  MembershipCard
//
//  Created by  on 16/3/3.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "MoreViewController.h"
#import "SettingViewController.h"
#import "ShowDeteledCardViewController.h"
#import "UIView+frame.h"
#import "UIView+border.h"
#import "ChooseAreaViewController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更多";
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightBtn setTitle:@"设置" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn addTarget:self action:@selector(setting) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    _bgView.width = MainScreenWidth;
    _scrollView.contentSize = CGSizeMake(MainScreenWidth, _bgView.height);
    [_scrollView addSubview:_bgView];
    
    [_avatarBtn circularBoarderBead:_avatarBtn.width / 2 withBoarder:1 color:UIColorFromRGB(0xf0f0f0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  跳设置
 */
- (void)setting
{
    SettingViewController *vc = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)avatarBtnAction:(id)sender {
}

- (IBAction)editBtnAction:(id)sender {
}

- (IBAction)cardMartBtnAction:(id)sender {
}

- (IBAction)secondHandBtnAction:(id)sender {
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
        //给好评
        NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1085934881" ];
        if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)){
            str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id1085934881"];
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    else {
        ChooseAreaViewController *vc = [[ChooseAreaViewController alloc]init];
        vc.fromSetting = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
