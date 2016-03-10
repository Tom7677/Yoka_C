//
//  LoginViewController.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/21.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "LoginViewController.h"
#import "UIView+frame.h"
#import "UIView+border.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "ChooseAreaViewController.h"
#import <MobClick.h>

#define INTERVAL_KEYBOARD 20
@interface LoginViewController ()
@property (nonatomic, assign) int count;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeNameNotification) name:@"ChangeNameNotification" object:nil];
    [_logoImageView circularBead:15];
    [_loginButton circularBead:4];
    [_weixinBtn circularBoarderBead:4 withBoarder:1 color:[UIColor groupTableViewBackgroundColor]];
    UIImage *wxLogo = [UIImage imageNamed:@"wx"];
    wxLogo = [wxLogo imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_weixinBtn setImage:wxLogo forState:UIControlStateNormal];
    [_scrollView addSubview:_bgView];
    [_scrollView setContentSize:CGSizeMake(MainScreenWidth, _bgView.height)];
//    if (![WXApi isWXAppInstalled]) {
//        _weixinBtn.hidden = YES;
//        _orLabel.hidden = YES;
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)ChangeNameNotification
{
    if (self.LoginCallBack) {
        self.LoginCallBack();
    }
}

- (IBAction)getCodeBtnAction:(id)sender {
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
}

-(void)updateTime
{
    _count++;
    if (_count >= 60) {
        [_timer invalidate];
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getCodeBtn.enabled = YES;
        return;
    }
    [_getCodeBtn setTitle:[NSString stringWithFormat:@"%d秒",60 - _count] forState:UIControlStateNormal];
    _getCodeBtn.enabled = NO;
}

- (IBAction)loginAction:(id)sender {
    ChooseAreaViewController *vc = [[ChooseAreaViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
    [MobClick profileSignInWithPUID:_phoneNumTextField.text];
    [[UMengAnalyticsUtil shared]loginByMobile];
}

- (IBAction)weixinLoginAction:(id)sender {
    [[UMengAnalyticsUtil shared]loginByWX];
}

-(void)sendAuthRequest
{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ]init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}
@end
