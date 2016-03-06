//
//  LoginViewController.h
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/21.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController
@property (copy, nonatomic) void (^LoginCallBack)();
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;


- (IBAction)getCodeBtnAction:(id)sender;
- (IBAction)loginAction:(id)sender;
- (IBAction)weixinLoginAction:(id)sender;

@end
