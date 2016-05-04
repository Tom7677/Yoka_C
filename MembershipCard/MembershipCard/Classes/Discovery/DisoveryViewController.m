//
//  DisoveryViewController.m
//  MembershipCard
//
//  Created by  on 16/3/3.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "DisoveryViewController.h"
#import "UIView+frame.h"
#import "MJRefresh.h"
#import "DiscoveryTableViewCell.h"
#import "DiscoveryWithImageCell.h"
#import "UILabel+caculateSize.h"
#import "ArticleViewController.h"
#import "YKModel.h"
#import <UIImageView+WebCache.h>
#import "WebViewController.h"
#import "ModelCache.h"
#import "DisoveryTabViewController.h"
#import "SCNavTabBarController.h"

@interface DisoveryViewController ()
@property (nonatomic, strong) NSMutableArray *typeArray;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) CGFloat btnWidth;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, assign) NSInteger index;

@property(nonatomic,strong)SCNavTabBarController *tabBarController;

@end

@implementation DisoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNameNotification) name:@"ChangeNameNotification" object:nil];
    _index = 0;
    self.title = @"发现";
    _cityName = [[NSUserDefaults standardUserDefaults]objectForKey:@"MyCity"];
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
    [leftBtn setTitle:@"爆料" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftBtn addTarget:self action:@selector(feedbackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [self.navigationItem setRightBarButtonItem:leftItem];
    [self getType];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeNameNotification
{
    _cityName = [[NSUserDefaults standardUserDefaults]objectForKey:@"MyCity"];
}

- (void)getType
{
    _typeArray = [[NSMutableArray alloc]init];
    if ([[ModelCache shared] containsObjectForKey:ARTICLE_TYPE]) {
        [_typeArray addObjectsFromArray:(NSArray *)[[ModelCache shared] readValueByKey:ARTICLE_TYPE]];
        [self createBtn];
    }
    else {
        [[NetworkAPI shared]getArticleTypeWithFinish:^(NSArray *dataArray) {
            [_typeArray addObjectsFromArray:dataArray];
            [[ModelCache shared]saveValue:_typeArray forKey:ARTICLE_TYPE];
            [self createBtn];
        } withErrorBlock:^(NSError *error) {
            
        }];
    }
}

/**
 *  爆料
 */
- (void)feedbackAction {
    [self showHub];
    [[NetworkAPI shared]getFeedbackURLWithFinish:^(BOOL isSuccess, NSString *urlStr) {
        [self hideHub];
        if (isSuccess) {
            WebViewController *vc = [[WebViewController alloc]initWithURLString:urlStr titleLabel:@"爆料"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } withErrorBlock:^(NSError *error) {
        [self hideHub];
        if (error.code == NSURLErrorNotConnectedToInternet) {
            [self showAlertViewController:@"您无法连接到网络，请确认网络连接。"];
        }
    }];
    [[UMengAnalyticsUtil shared]factBtn];
}

/**
 *  创建顶部选择按钮
 */
- (void) createBtn {
    NSMutableArray *temp = [NSMutableArray new];
    DisoveryTabViewController *vc = [[DisoveryTabViewController alloc] initWithCatId:nil cityName:_cityName];
    vc.title = @"推荐";
    [temp addObject:vc];
    for (int i=0; i<_typeArray.count; i++) {
        ArticleTypeModel *model = _typeArray[i];
        DisoveryTabViewController *vc = [[DisoveryTabViewController alloc] initWithCatId:model.cat_id cityName:_cityName];
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
