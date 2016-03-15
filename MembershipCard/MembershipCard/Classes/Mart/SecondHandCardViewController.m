//
//  SecondHandCardViewController.m
//  MembershipCard
//
//  Created by tom.sun on 16/3/14.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "SecondHandCardViewController.h"

@interface SecondHandCardViewController ()

@end

@implementation SecondHandCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"二手卡券";
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 28)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"发布" forState:UIControlStateNormal];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(releaseAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)releaseAction
{
    
}
@end
