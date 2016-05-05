//
//  SecondHandCardViewController.m
//  MembershipCard
//
//  Created by tom.sun on 16/3/14.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "SecondHandCardViewController.h"
#import "MJExtension.h"
#import "SellCardViewController.h"
#import "UIView+frame.h"
#import "MJRefresh.h"
#import "AssignmentInfoViewController.h"
#import "ModelCache.h"
#import "SCNavTabBarController.h"
#import "VoucherTabViewController.h"


#define LINE_WIDTH  50
@interface SecondHandCardViewController ()
@property (nonatomic, strong) NSMutableArray *typeArray;
@property(nonatomic,strong)SCNavTabBarController *tabBarController;


@end

@implementation SecondHandCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"二手卡券";
    _typeArray = [[NSMutableArray alloc]init];
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 28)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"我的发布" forState:UIControlStateNormal];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(releaseAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];
    }

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[ModelCache shared]containsObjectForKey:VOUCHER_TYPE]) {
        NSArray *resultArray = [[ModelCache shared]readValueByKey:VOUCHER_TYPE];
        [self getTypeArray:resultArray];
        [self createBtn];
    }
    else {
        [self getVoucherCatList];
    }

}
- (void)getVoucherCatList
{
    [[NetworkAPI shared]getVoucherTypeWithFinish:^(NSArray *dataArray) {
        if (dataArray != nil) {
            [self getTypeArray:dataArray];
            [self createBtn];
        }
    } withErrorBlock:^(NSError *error) {
        
    }];
}

- (void)getTypeArray:(NSArray *)resultArray
{
    [_typeArray removeAllObjects];
    for (NSDictionary *dic in resultArray) {
        ArticleTypeModel *model = [ArticleTypeModel mj_objectWithKeyValues:dic];
        [_typeArray addObject:model];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)releaseAction
{
    SellCardViewController *vc = [[SellCardViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) createBtn
{
    NSMutableArray *temp = [NSMutableArray new];
    VoucherTabViewController *vc = [[VoucherTabViewController alloc] initWithCatId:nil];
    vc.title = @"全部卡";
    [temp addObject:vc];
    for (int i=0; i<_typeArray.count; i++) {
        ArticleTypeModel *model = _typeArray[i];
        VoucherTabViewController *vc = [[VoucherTabViewController alloc] initWithCatId:model.cat_id];
        vc.title = model.cat_name;
        [temp addObject:vc];
    }
    
    self.tabBarController = [[SCNavTabBarController alloc] init];
    self.tabBarController.navTabBarLineColor = UIColorFromRGB(0xffd500);
    self.tabBarController.navTabBarColor = [UIColor whiteColor];
    self.tabBarController.subViewControllers = temp;
    
    self.tabBarController.showArrowButton = NO;
    [self.tabBarController addParentController:self];
}

@end
