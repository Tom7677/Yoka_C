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
#import "WebViewController.h"
#import "UILabel+caculateSize.h"

@interface NotificationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) NSMutableArray *resultArray;
@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通知";
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

- (void)viewDidAppear:(BOOL)animated
{
    if (![self isEmpty:_url]) {
        WebViewController *web = [[WebViewController alloc]initWithURLString:_url titleLabel:nil];
        _url = nil;
        [self.navigationController pushViewController:web animated:YES];
    }
}

- (void)loadNewData
{
    [self showHub];
    [[NetworkAPI shared]getNoticeListWithFinish:^(NSArray *dataArray) {
        [self hideHub];
        if (dataArray != nil) {
            [_resultArray removeAllObjects];
            [_resultArray addObjectsFromArray:dataArray];
            [_tableView reloadData];
        }
    } withErrorBlock:^(NSError *error) {
        [self hideHub];
        if (error.code == NSURLErrorNotConnectedToInternet) {
            [self showAlertViewController:@"您无法连接到网络，请确认网络连接。"];
        }
    }];
}

- (void)clearBtnAction
{
    [self showConfirmAlertViewControllerWithTitle:@"是否清空" andAction:^{
        [[UMengAnalyticsUtil shared]clearNotice];
        [[NetworkAPI shared] clearNoticeWithFinish:^(NSString *msg, BOOL isSuccess) {
            if (isSuccess) {
                [_resultArray removeAllObjects];
                [_tableView reloadData];
            }
        } withErrorBlock:^(NSError *error) {
            
        }];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _resultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    NoticeModel *model = _resultArray[indexPath.row];
    cell.contentLabel.text = model.content;
    cell.timeLabel.text = model.create_date;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NoticeModel *model = _resultArray[indexPath.row];
    if (![self isEmpty:model.jump_link]) {
        WebViewController *vc = [[WebViewController alloc]initWithURLString:model.jump_link titleLabel:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    NoticeModel *model = _resultArray[indexPath.row];
    cell.contentLabel.text = model.content;
    cell.contentLabel.width = MainScreenWidth - 20;
    return [cell.contentLabel getTextHeight] + cell.timeLabel.height + 31;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self showConfirmAlertViewControllerWithTitle:@"是否删除" andAction:^{
            NoticeModel *model = _resultArray[indexPath.row];
            [[NetworkAPI shared]deleteNoticeWithMessageId:model.message_id WithFinish:^(NSString *msg, BOOL isSuccess) {
                if (isSuccess) {
                    [_resultArray removeObjectAtIndex:indexPath.row];
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
                }
            } withErrorBlock:^(NSError *error) {
                
            }];
        }];
    }
}
@end
