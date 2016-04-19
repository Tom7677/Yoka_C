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
@property (nonatomic, assign) int count;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, getter=isWXLogin) BOOL wxLogin;
@property (weak, nonatomic) IBOutlet UIButton *cancelWXloginBtn;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _wxLogin = NO;
    _cancelWXloginBtn.layer.borderWidth = 1;
    _cancelWXloginBtn.layer.borderColor = [[UIColor groupTableViewBackgroundColor] CGColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeNameNotification) name:@"ChangeNameNotification" object:nil];
    [_logoImageView circularBead:15];
    [_loginButton circularBead:4];
    [_weixinBtn circularBoarderBead:4 withBoarder:1 color:[UIColor groupTableViewBackgroundColor]];
    UIImage *wxLogo = [UIImage imageNamed:@"wx"];
    wxLogo = [wxLogo imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_weixinBtn setImage:wxLogo forState:UIControlStateNormal];
    [_scrollView addSubview:_bgView];
    [_scrollView setContentSize:CGSizeMake(MainScreenWidth, _bgView.height)];
    if (![WXApi isWXAppInstalled]) {
        _weixinBtn.hidden = YES;
        _orLabel.hidden = YES;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goHomeView) name:@"bandMobileNotification" object:nil];
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
    NSString *phoneNum;
    if (_wxLogin) {
        phoneNum = _wxPhoneNumTextField.text;
    }else {
        phoneNum = _phoneNumTextField.text;
    }
    if (phoneNum.length == 0) {
        [self showAlertViewController:@"请输入手机号码"];
        return;
    }
    if (![self checkTelNumber:phoneNum]) {
        [self showAlertViewController:@"请输入格式正确的手机号码"];
        return;
    }
    [[NetworkAPI shared]getMobileCodeByMobile:phoneNum WithFinish:^(BOOL isSuccess, NSString *msg) {
        if (isSuccess) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
        }
        else {
            [self showAlertViewController:msg];
        }
    } withErrorBlock:^(NSError *error) {
        
    }];
}


-(void)updateTime
{
    _count++;
    if (_count >= 60) {
        [_timer invalidate];
        if (_wxLogin) {
            [_wxGetCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            _wxGetCodeBtn.enabled = YES;
        }
        else {
            [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            _getCodeBtn.enabled = YES;
        }
        return;
    }
    if (_wxLogin) {
        [_wxGetCodeBtn setTitle:[NSString stringWithFormat:@"%d秒",60 - _count] forState:UIControlStateNormal];
        _wxGetCodeBtn.enabled = NO;
    }
    else {
        [_getCodeBtn setTitle:[NSString stringWithFormat:@"%d秒",60 - _count] forState:UIControlStateNormal];
        _getCodeBtn.enabled = NO;
    }
}

- (IBAction)loginAction:(id)sender {
    if (_phoneNumTextField.text.length == 0) {
        [self showAlertViewController:@"请输入手机号码"];
        return;
    }
    if (![self checkTelNumber:_phoneNumTextField.text]) {
        [self showAlertViewController:@"请输入格式正确的手机号码"];
        return;
    }
    if (_codeTextField.text.length == 0) {
        [self showAlertViewController:@"请输入验证码"];
        return;
    }
    [[NetworkAPI shared]userLoginByMobile:_phoneNumTextField.text AndCode:_codeTextField.text WithFinish:^(BOOL isSuccess, NSString *msg) {
        if (isSuccess) {
            [self goHomeView];
            [[NSUserDefaults standardUserDefaults]setObject:_phoneNumTextField.text forKey:@"phoneNum"];
            [[UMengAnalyticsUtil shared]loginByMobile];
        }
        else {
            [self showAlertViewController:msg];
        }
    } withErrorBlock:^(NSError *error) {
        if (error.code == NSURLErrorNotConnectedToInternet) {
            
        }
        else {
            
        }
    }];
}

-(void)goHomeView {
    ChooseAreaViewController *vc = [[ChooseAreaViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)wxLoginAction:(id)sender {
    if (_wxPhoneNumTextField.text.length == 0) {
        //@"请输入手机号码"
        return;
    }
    if (![self checkTelNumber:_wxPhoneNumTextField.text]) {
        //@"请输入格式正确的手机号码"
        return;
    }

    [[NetworkAPI shared]bindMobileByMobile:_wxPhoneNumTextField.text AndCode:_wxCodeTextField.text WithFinish:^(BOOL isSuccess, NSString *msg) {
        if (isSuccess) {
            [self goHomeView];
            [[NSUserDefaults standardUserDefaults]setObject:_wxPhoneNumTextField.text forKey:@"phoneNum"];
        }
    } withErrorBlock:^(NSError *error) {
        
    }];
}

- (IBAction)chooseWXLoginBtn:(id)sender {
    _wxLogin = YES;
    [self sendAuthRequest];
    [[UMengAnalyticsUtil shared]loginByWX];
    [_scrollView addSubview:_wxView];
    _wxView.width = MainScreenWidth;
}
- (IBAction)cancelWXLoginAction:(id)sender {
    _wxLogin = NO;
    [_wxView removeFromSuperview];
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

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
