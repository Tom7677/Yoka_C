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
#import "NetworkAPI.h"

#define INTERVAL_KEYBOARD 20
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *wxPhoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *wxCodeTextField;
@property (nonatomic, getter=isWXLogin) BOOL wxLogin;
@property (nonatomic, assign) int count;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.wxLogin = NO;
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
    if (_phoneNumTextField.text.length == 0) {
        //@"请输入手机号码"
        return;
    }
    if (![self checkTelNumber:_phoneNumTextField.text]) {
        //@"请输入格式正确的手机号码"
        return;
    }
    [[NetworkAPI shared]getMobileCodeByMobile:_phoneNumTextField.text WithFinish:^(BOOL isSuccess, NSString *msg) {
        if (isSuccess) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
        }
        else {
            
        }
    } withErrorBlock:^(NSError *error) {
        
    }];
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
    if (self.isWXLogin) {
        _codeTextField.text = _wxCodeTextField.text;
        _phoneNumTextField.text = _wxPhoneNumTextField.text;

    }
        if (_phoneNumTextField.text.length == 0) {
        //@"请输入手机号码"
        return;
    }
    if (![self checkTelNumber:_phoneNumTextField.text]) {
        //@"请输入格式正确的手机号码"
        return;
    }
    [[NetworkAPI shared]userLoginByMobile:_phoneNumTextField.text AndCode:_codeTextField.text WithFinish:^(BOOL isSuccess, NSString *msg) {
        if (isSuccess) {
            ChooseAreaViewController *vc = [[ChooseAreaViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
            [[UMengAnalyticsUtil shared]loginByMobile];
        }
        else {
            
        }
    } withErrorBlock:^(NSError *error) {
        if (error.code == NSURLErrorNotConnectedToInternet) {
            
        }
        else {
            
        }
    }];
}

- (IBAction)weixinLoginAction:(id)sender {
    [self sendAuthRequest];
    [[UMengAnalyticsUtil shared]loginByWX];
    [_scrollView addSubview:_wxView];
    _wxLogin = YES;

}

- (void)sendAuthRequest
{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ]init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}



/*!
 *  @brief  检验手机号码格式是否正确
 *
 *  @param telNumber 手机号
 *
 *  @return return value description
 */
- (BOOL)checkTelNumber:(NSString *) telNumber
{
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    BOOL res1 = [regextestmobile evaluateWithObject:telNumber];
    BOOL res2 = [regextestcm evaluateWithObject:telNumber];
    BOOL res3 = [regextestcu evaluateWithObject:telNumber];
    BOOL res4 = [regextestct evaluateWithObject:telNumber];
    if (res1 || res2 || res3 || res4 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
@end
