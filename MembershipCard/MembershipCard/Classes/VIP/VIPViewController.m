//
//  VIPViewController.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/21.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "VIPViewController.h"
#import "VIPServiceTableViewController.h"
#import "YKMerchantsViewController.h"
#import "UIView+frame.h"

@interface VIPViewController ()

@end

@implementation VIPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"会员专享",@"悠卡商户", nil]];
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget:self action:@selector(controlPressed:) forControlEvents:UIControlEventValueChanged];
    NSDictionary *selectDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    NSDictionary *normalDic = [NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0xFF526E),NSForegroundColorAttributeName,nil];
    [segmentedControl setTitleTextAttributes:normalDic forState:UIControlStateNormal];
    [segmentedControl setTitleTextAttributes:selectDic forState:UIControlStateSelected];
    segmentedControl.tintColor = UIColorFromRGB(0xFF526E);
    self.navigationItem.titleView = segmentedControl;
    [self addChildVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addChildVC
{
    _scrollView.contentSize = CGSizeMake(MainScreenWidth*2,MainScreenHeight);
    VIPServiceTableViewController *vipTableView = [[VIPServiceTableViewController alloc]init];
    [_scrollView addSubview:vipTableView.view];
    [self addChildViewController:vipTableView];
    
    YKMerchantsViewController *merchantsVC = [[YKMerchantsViewController alloc]init];
    merchantsVC.view.originX = MainScreenWidth;
    [_scrollView addSubview:merchantsVC.view];
    [self addChildViewController:merchantsVC];
}

- (void)controlPressed:(UISegmentedControl*)segmented
{
    [_scrollView setContentOffset:CGPointMake(segmented.selectedSegmentIndex * MainScreenWidth, 0) animated:YES];
}
@end
