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
        TSImageLeftButton *btn = [[TSImageLeftButton alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:title forState:UIControlStateNormal];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [viewController.navigationItem setLeftBarButtonItem:backButton];
    }
}

- (void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
