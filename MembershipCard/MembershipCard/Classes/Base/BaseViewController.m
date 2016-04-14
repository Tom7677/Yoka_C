//
//  BaseViewController.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/21.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "BaseViewController.h"
#import "TSImageLeftButton.h"

@interface BaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setBackItemTitle:@"返回"];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setBackItemTitle:(NSString *)title
{
    //当前Controller设定的BackBarButtonItem只影响下一个Controller的左侧返回键Title
    if (self.navigationController.viewControllers.count > 1)
    {
        UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 1];
        TSImageLeftButton *btn = [[TSImageLeftButton alloc]initWithFrame:CGRectMake(0, 0, 80, 60)];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setImage:[UIImage imageNamed:@"backicon"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:title forState:UIControlStateNormal];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -5;
        viewController.navigationItem.leftBarButtonItems = @[negativeSpacer,backButton];
    }
}

- (void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*!
 *  @brief  判断str是否为空
 *
 *  @param str str description
 *
 *  @return return value description
 */
- (BOOL)isEmpty:(NSString *)str
{
    return str == nil || [str isEqual:@""] || [str isEqual:[NSNull null]];
}

/**
 *  弹出AlertViewController
 *
 *  @param msg message
 */
- (void)showAlertViewController:(NSString *)msg
{
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showConfirmAlertViewControllerWithTitle:(NSString *)msg andAction:(void(^)())actionBlock
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:msg message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        actionBlock();
    }];
    [alertController addAction:okAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
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
