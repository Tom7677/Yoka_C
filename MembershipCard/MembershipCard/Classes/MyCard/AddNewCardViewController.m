//
//  AddNewCardViewController.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/22.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "AddNewCardViewController.h"
#import "BrandListViewController.h"
#import "PossiableCardViewController.h"
#import "UIView+frame.h"


@interface AddNewCardViewController ()

@end

@implementation AddNewCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title= @"添加新卡";
    _scrollView.showsVerticalScrollIndicator = NO;
    [_scrollView addSubview:_addNewCardView];
    _addNewCardView.width = MainScreenWidth;
    _scrollView.contentSize = CGSizeMake(MainScreenWidth, _addNewCardView.height);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)qrBtnAction:(id)sender {
    [[UMengAnalyticsUtil shared]qrCard];
    BrandListViewController *vc = [[BrandListViewController alloc]init];
    vc.scan = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)inputBtnAction:(id)sender {
    [[UMengAnalyticsUtil shared]manuallyInputCard];
    BrandListViewController *vc = [[BrandListViewController alloc]init];
    vc.scan = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)guessBtnAction:(id)sender {
    PossiableCardViewController *vc = [[PossiableCardViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
