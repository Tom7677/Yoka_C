//
//  LoginViewController.h
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/21.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "BaseViewController.h"
#import "MidImageLeftButton.h"
#import <TPKeyboardAvoidingScrollView.h>

@interface LoginViewController : BaseViewController
@property (copy, nonatomic) void (^LoginCallBack)();
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *orLabel;
@property (weak, nonatomic) IBOutlet MidImageLeftButton *weixinBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIView *wxView;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;



- (IBAction)getCodeBtnAction:(id)sender;
- (IBAction)loginAction:(id)sender;
- (IBAction)weixinLoginAction:(id)sender;

@end
