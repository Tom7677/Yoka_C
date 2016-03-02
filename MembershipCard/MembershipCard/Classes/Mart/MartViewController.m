//
//  MartViewController.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/28.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "MartViewController.h"

@interface MartViewController ()

@end

@implementation MartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"悠卡专供",@"二手卡券", nil]];
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget:self action:@selector(controlPressed:) forControlEvents:UIControlEventValueChanged];
    NSDictionary *selectDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    NSDictionary *normalDic = [NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0xFF526E),NSForegroundColorAttributeName,nil];
    [segmentedControl setTitleTextAttributes:normalDic forState:UIControlStateNormal];
    [segmentedControl setTitleTextAttributes:selectDic forState:UIControlStateSelected];
    segmentedControl.tintColor = UIColorFromRGB(0xFF526E);
    self.navigationItem.titleView = segmentedControl;
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 28)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"我要卖卡" forState:UIControlStateNormal];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn setTitleColor:UIColorFromRGB(0xFF526E) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(sellAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sellAction
{
    
}

- (void)controlPressed:(UISegmentedControl*)segmented
{
    if (segmented.selectedSegmentIndex == 0) {
        
    }
    else {
        
    }
}
@end
