//
//  PossiableCardViewController.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/3/20.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "PossiableCardViewController.h"
#import "PossiableCardTableViewCell.h"
#import <UIImageView+WebCache.h>

@interface PossiableCardViewController ()<UITableViewDelegate,UITableViewDataSource,PossiableCardTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *resultArray;
@property (strong, nonatomic) UILabel *noCardLabel;

@end

@implementation PossiableCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"猜你有这些卡";
    _resultArray = [[NSMutableArray alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"PossiableCardTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
    [self loadNewData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNewData
{
    [self showHub];
    [[NetworkAPI shared]getCooperatedMerchantListWithFinish:^(NSArray *dataArray) {
        [self hideHub];
        [_resultArray removeAllObjects];
        [_resultArray addObjectsFromArray:dataArray];
        if (dataArray.count < 1) {
            _noCardLabel = [[UILabel alloc]initWithFrame:CGRectMake((MainScreenWidth - 200) / 2, 100, 200, 30)];
            _noCardLabel.textAlignment = NSTextAlignmentCenter;
            _noCardLabel.font = [UIFont systemFontOfSize:14];
            _noCardLabel.textColor = [UIColor lightGrayColor];
            _noCardLabel.text = @"暂无匹配卡！";
            [self.view insertSubview:_noCardLabel aboveSubview:_tableView];
        }else {
            [_noCardLabel removeFromSuperview];
            [_tableView reloadData];
        }
    } withErrorBlock:^(NSError *error) {
        [self hideHub];
        if (error.code == NSURLErrorNotConnectedToInternet) {
            [self showAlertViewController:@"您无法连接到网络，请确认网络连接。"];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _resultArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PossiableCardTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    cell.delegate = self;
    BrandCardListModel *model = _resultArray[indexPath.row];
    cell.merchantId = model.merchant_id;
    cell.nameLabel.text =model.name;
    [cell.cardImageView sd_setImageWithURL:[NSURL URLWithString:[imageUrl stringByAppendingString:model.f_logo]]];
    if (model.has_card) {
        cell.addCardBtn.enabled = NO;
        [cell.addCardBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cell.addCardBtn setTitle:@"已在卡包" forState:UIControlStateNormal];
        [cell.addCardBtn setBackgroundColor:UIColorFromRGB(0xEFEFEF)];
    }
    else {
        cell.addCardBtn.enabled = YES;
        [cell.addCardBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell.addCardBtn setTitle:@"加入卡包" forState:UIControlStateNormal];
        [cell.addCardBtn setBackgroundColor:UIColorFromRGB(0x279E20)];
    }
    return cell;
}

- (void)possiableCardTableViewCell:(PossiableCardTableViewCell *)cell merchantId:(NSString *)merchantId
{
    [self showHub];
    [[NetworkAPI shared]addCardYunsuoWithMerchantId:merchantId WithFinish:^(BOOL isSuccess, NSString *msg) {
        [self hideHub];
        if (isSuccess) {
            cell.addCardBtn.enabled = NO;
            [cell.addCardBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cell.addCardBtn setTitle:@"已在卡包" forState:UIControlStateNormal];
            [cell.addCardBtn setBackgroundColor:UIColorFromRGB(0xEFEFEF)];
        }
        else {
            [self showAlertViewController:msg];
        }
    } withErrorBlock:^(NSError *error) {
        [self hideHub];
    }];
}

@end
