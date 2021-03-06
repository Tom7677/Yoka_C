//
//  MyCardBagViewController.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/21.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "MyCardBagViewController.h"
#import "MyCardBagTableViewCell.h"
#import "NotificationViewController.h"
#import "AddNewCardViewController.h"
#import "MyCardDetailViewController.h"
#import "MJRefresh.h"
#import <UIImageView+WebCache.h>
#import "BaseViewController.h"
#import "UIView+border.h"
#import "WebViewController.h"
#import "ModelCache.h"


@interface MyCardBagViewController ()
@property (nonatomic, strong) NSMutableArray *cardArray;
@property (strong, nonatomic) UIView *lunchView;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger countTime;
@property (strong, nonatomic) UILabel *countLabel;
@property (strong, nonatomic) NSMutableArray *cardIdArray;
@property (strong, nonatomic) UILabel *noCardLabel;
@end

@implementation MyCardBagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"卡包";
    _cardIdArray = [[NSMutableArray alloc]init];
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
    [leftBtn setTitle:@"通知" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftBtn addTarget:self action:@selector(notificationBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    [self loadAd];
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 28)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"添加" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn addTarget:self action:@selector(addNewCardBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    _noCardLabel = [[UILabel alloc]initWithFrame:CGRectMake((MainScreenWidth - 200) / 2, 100, 200, 30)];
    _noCardLabel.textAlignment = NSTextAlignmentCenter;
    _noCardLabel.font = [UIFont systemFontOfSize:14];
    _noCardLabel.textColor = [UIColor lightGrayColor];
    _noCardLabel.text = @"赶快添加你的第一张会员卡吧！";
    _noCardLabel.tag = 500;
    
    _tableView = [[RTDragCellTableView alloc]init];
    _tableView.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - NavAndStatusBarHeight - TabbarHeight);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"MyCardBagTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _cardArray = [[NSMutableArray alloc]init];
    [self showHub];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[ModelCache shared] containsObjectForKey:@"cardList"]) {
        [_cardArray removeAllObjects];
        [_cardArray addObjectsFromArray:(NSArray *)[[ModelCache shared] readValueByKey:@"cardList"]];
        [self reloadTableData];
    }
    [self loadNewData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNewData
{
    [[NetworkAPI shared]getMyCardBagListWithFinish:^(NSArray *dataArray) {
        [self hideHub];
        if (dataArray != nil) {
            [_cardArray removeAllObjects];
            [_cardArray addObjectsFromArray:dataArray];
            NSArray *cardIdArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"cardId"];
            for (int i = 0 ; i < cardIdArray.count; i ++) {
                for (int j = 0; j < _cardArray.count; j ++) {
                    MyCardModel *model = _cardArray[j];
                    if ([model.card_id isEqualToString:cardIdArray[i]]) {
                        [_cardArray exchangeObjectAtIndex:j withObjectAtIndex:i];
                    }
                }
            }
            [self reloadTableData];
            [[ModelCache shared] saveValue:_cardArray forKey:@"cardList"];
            [_tableView.mj_header endRefreshing];
        }
    } withErrorBlock:^(NSError *error) {
        [self hideHub];
        [_tableView.mj_header endRefreshing];
        if (error.code == NSURLErrorNotConnectedToInternet) {
            [self showAlertViewController:@"您无法连接到网络，请确认网络连接。"];
        }
    }];
}
- (void)loadAd
{
    NSString *adImageUrl = [[NSUserDefaults standardUserDefaults]objectForKey:@"adImageUrl"];
    if (![self isEmpty:adImageUrl]) {
        _countTime = 5;
        _lunchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
        _lunchView.backgroundColor = [UIColor whiteColor];
        [[UIApplication sharedApplication].keyWindow addSubview:_lunchView];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLink)];
        imageV.userInteractionEnabled = YES;
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        [imageV addGestureRecognizer:tap];
        [imageV sd_setImageWithURL:[NSURL URLWithString:[imageUrl stringByAppendingString:adImageUrl]]];
        [_lunchView addSubview:imageV];
        
        UIView *blackView = [[UIView alloc]initWithFrame:CGRectMake(MainScreenWidth - 100 - 12, 25, 100, 35)];
        blackView.backgroundColor = [UIColor blackColor];
        blackView.alpha = 0.4;
        [blackView circularBead:16];
        [_lunchView addSubview:blackView];
        _countLabel = [[UILabel alloc]initWithFrame:blackView.frame];
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.font = [UIFont systemFontOfSize:14];
        _countLabel.text = [NSString stringWithFormat:@"%ld 立即跳过",(long)_countTime];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        UITapGestureRecognizer *tapCancel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAdCancel)];
        _countLabel.userInteractionEnabled = YES;
        [_countLabel addGestureRecognizer:tapCancel];
        [_lunchView addSubview:_countLabel];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
        [NSThread sleepForTimeInterval:2.0];
    }
    [[NetworkAPI shared]getAdURLWithFinish:^(BOOL isSuccess, NSString *urlStr, NSString *linkStr) {
        if (isSuccess) {
            [[NSUserDefaults standardUserDefaults]setObject:urlStr forKey:@"adImageUrl"];
            [[NSUserDefaults standardUserDefaults]setObject:linkStr forKey:@"adLinkUrl"];
        }
    } withErrorBlock:^(NSError *error) {
        
    }];
}

- (void)reloadTableData {
    if (_cardArray.count < 1 ) {
        [self.view insertSubview:_noCardLabel aboveSubview:_tableView];
    }else {
        for (UIView *view in [self.view subviews]) {
            if (view.tag == 500) {
                [_noCardLabel removeFromSuperview];
            }
        }
    }
    [_tableView reloadData];
}

#pragma mark Action
- (void)notificationBtnAction
{
    [[UMengAnalyticsUtil shared]seeNotice];
    NotificationViewController *vc = [[NotificationViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addNewCardBtnAction
{
    [[UMengAnalyticsUtil shared]addNewCard];
    AddNewCardViewController *vc = [[AddNewCardViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)updateTime
{
    _countTime--;
    _countLabel.text = [NSString stringWithFormat:@"%ld 立即跳过",(long)_countTime];
    if (_countTime == 0) {
        [self tapAdCancel];
    }
}

- (void)tapAdCancel
{
    [_timer invalidate];
    [_lunchView removeFromSuperview];
}

- (void)tapLink
{
    NSString *linkUrl = [[NSUserDefaults standardUserDefaults]objectForKey:@"adLinkUrl"];
    if (linkUrl != nil && ![linkUrl isEqualToString:@""]) {
        WebViewController *webVC = [[WebViewController alloc]initWithWebNavigationAndURLString:linkUrl];
        [self.navigationController pushViewController:webVC animated:YES];
        [self tapAdCancel];
    }
}

#pragma mark TableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92.5;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cardArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCardBagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    MyCardModel *model = _cardArray[indexPath.row];
    if ([self isEmpty:model.f_logo]) {
        cell.logoImageView.image = [UIImage imageNamed:@"mjlogo_rectangle.jpg"];
    }else {
        [cell.logoImageView sd_setImageWithURL:[NSURL URLWithString:[imageUrl stringByAppendingString:model.f_logo]]];
    }
    cell.shopNameLabel.text = model.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCardDetailViewController *vc = [[MyCardDetailViewController alloc]init];
    MyCardModel *model = _cardArray[indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSArray *)originalArrayDataForTableView:(RTDragCellTableView *)tableView{
    return _cardArray;
}

- (void)tableView:(RTDragCellTableView *)tableView newArrayDataForDataSource:(NSArray *)newArray{
    [_cardArray removeAllObjects];
    [_cardArray addObjectsFromArray:newArray];
    [_cardIdArray removeAllObjects];
    for (int i = 0 ; i < _cardArray.count; i ++) {
        MyCardModel *model = _cardArray[i];
        [_cardIdArray addObject:model.card_id];
    }
    [self reloadTableData];
    [[NSUserDefaults standardUserDefaults]setObject:[_cardIdArray copy] forKey:@"cardId"];
}
@end
