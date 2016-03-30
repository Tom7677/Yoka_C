//
//  NotificationViewController.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/22.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "NotificationViewController.h"
#import "UIView+frame.h"
#import "NotificationTableViewCell.h"
#import "MJRefresh.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface NotificationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) NSMutableArray *resultArray;
@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _resultArray = [[NSMutableArray alloc]init];
    _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 28)];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_rightBtn setTitle:@"清空" forState:UIControlStateNormal];
    _rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(clearBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    [_tableView registerNib:[UINib nibWithNibName:@"NotificationTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self loadNewData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNewData
{
    [[NetworkAPI shared]getNoticeListWithFinish:^(NSArray *dataArray) {
        if (dataArray != nil) {
            [_resultArray removeAllObjects];
            [_resultArray addObjectsFromArray:dataArray];
            [_tableView reloadData];
        }
    } withErrorBlock:^(NSError *error) {
        
    }];
}

- (void)clearBtnAction
{
    [[UMengAnalyticsUtil shared]clearNotice];
    [[NetworkAPI shared]deleteAnnouncementWithFinish:^(BOOL isSuccess) {
        if (isSuccess) {
            [_resultArray removeAllObjects];
            [_tableView reloadData];
        }
    } withErrorBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _resultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    cell.fd_enforceFrameLayout = YES;
    NoticeModel *model = _resultArray[indexPath.row];
    cell.contentLabel.text = model.content;
    cell.timeLabel.text = model.create_date;
    cell.shopNameLabel.text = model.merchant_name;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"cellIdentify" configuration:^(NotificationTableViewCell *cell) {
        
    }];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //[dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}
@end
