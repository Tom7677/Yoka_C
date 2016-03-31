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

@interface SecondHandCardViewController ()
@property (nonatomic, strong) NSMutableArray *typeArray;
@end

@implementation SecondHandCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"二手卡券";
    _typeArray = [[NSMutableArray alloc]init];
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 28)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"发布" forState:UIControlStateNormal];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(releaseAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"VoucherType"] != nil) {
        NSArray *resultArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"VoucherType"];
        [self getTypeArray:resultArray];
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
            [[NSUserDefaults standardUserDefaults]setObject:dataArray forKey:@"VoucherType"];
        }
    } withErrorBlock:^(NSError *error) {
        
    }];
}

- (void)getTypeArray:(NSArray *)resultArray
{
    for (NSDictionary *dic in resultArray) {
        ArticleTypeModel *model = [[ArticleTypeModel alloc]init];
        model = [ArticleTypeModel mj_objectWithKeyValues:dic];
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
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) createBtn
{
    
}
@end
