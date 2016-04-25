//
//  SellCardViewController.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/3/1.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "SellCardViewController.h"
#import "VoucherListTableViewCell.h"
#import "MJRefresh.h"
#import "AddNewVoucherViewController.h"

@interface SellCardViewController ()<UITableViewDelegate,UITableViewDataSource,VoucherListTableViewCellDelegate>
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation SellCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(releaseReload) name:@"ReloadReleaseNotification" object:nil];
    self.title = @"我的发布";
    _dataArray  = [[NSMutableArray alloc]init];
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 28)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"新建" forState:UIControlStateNormal];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(addNew) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    [_tableView registerNib:[UINib nibWithNibName:@"VoucherListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewData];
    }];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    [self loadNewData];
    _tableView.mj_footer.hidden = YES;
    [_tableView setTableFooterView:[UIView new]];
}


-(void)releaseReload {
    [self loadNewData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNewData
{
    _page = 1;
    [[NetworkAPI shared]getVoucherReleasedListByPage:_page WithFinish:^(NSArray *dataArray) {
        if (dataArray != nil) {
            [_dataArray removeAllObjects];
            [_dataArray addObjectsFromArray:dataArray];
            if (dataArray.count >= pageSize) {
                _tableView.mj_footer.hidden = NO;
            }
            else {
                _tableView.mj_footer.hidden = YES;
            }
            [_tableView reloadData];
        }
        [_tableView.mj_header endRefreshing];
    } withErrorBlock:^(NSError *error) {
        
    }];
}

- (void)loadMoreData
{
    _page = _page + 1;
    [[NetworkAPI shared]getVoucherReleasedListByPage:_page WithFinish:^(NSArray *dataArray) {
        if (dataArray != nil) {
            if (dataArray.count < pageSize) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [_dataArray addObjectsFromArray:dataArray];
            [_tableView reloadData];
        }
        [_tableView.mj_footer endRefreshing];
    } withErrorBlock:^(NSError *error) {
        
    }];
}

/**
 *  新建
 */
- (void)addNew
{
    AddNewVoucherViewController *vc = [[AddNewVoucherViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VoucherListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    VoucherListModel *model = _dataArray[indexPath.row];
    cell.typeLabel.text = model.type;
    if ([model.type isEqualToString:@"转让"]) {
        cell.typeLabel.backgroundColor = UIColorFromRGB(0xF4CE1D);
    }
    else {
        cell.typeLabel.backgroundColor = UIColorFromRGB(0x8DC21F);
    }
    cell.delegate = self;
    cell.vouchertModel = model;
    cell.titleLabel.text = model.title;
    cell.locationLabel.text = [NSString stringWithFormat:@"%@ - %@",model.name,model.location];
    cell.priceLabel.text = [[model.price description] stringByAppendingString:@"元"];
    cell.timeLabel.text = model.create_date;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VoucherListModel *model = _dataArray[indexPath.row];
    AddNewVoucherViewController *vc = [[AddNewVoucherViewController alloc]init];
    vc.voucherId = model.voucher_id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)deleteVoucher:(VoucherListModel *)vouchertModel
{
    [self showConfirmAlertViewControllerWithTitle:@"确认删除" andAction:^{
        [[NetworkAPI shared]deleteVoucherWithVoucherId:vouchertModel.voucher_id WithFinish:^(BOOL isSuccess, NSString *msg) {
            if (isSuccess) {
                [_dataArray removeObject:vouchertModel];
                [_tableView reloadData];
            }
        } withErrorBlock:^(NSError *error) {
            
        }];
    }];
}
@end
