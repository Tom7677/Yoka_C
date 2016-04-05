//
//  EditNameViewController.m
//  MembershipCard
//
//  Created by tom.sun on 16/4/5.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "EditNameViewController.h"

@interface EditNameViewController ()

@end

@implementation EditNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _nameTextField.delegate = self;
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 28)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn setTitleColor:UIColorFromRGB(0xFF526E) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(saveBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveBtnAction
{
    if (![_nameTextField.text isEqualToString:@""]) {
        [[NetworkAPI shared]saveUserInfoByNickName:_nameTextField.text avatar:nil WithFinish:^(BOOL isSuccess, NSString *msg) {
            if (isSuccess) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                
            }
        } withErrorBlock:^(NSError *error) {
            
        }];
    }
    else {
        
    }
        
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_nameTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_nameTextField resignFirstResponder];
    return YES;
}
@end
