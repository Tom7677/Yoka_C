//
//  VoucherTabViewController.m
//  MembershipCard
//
//  Created by  on 16/5/5.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "VoucherTabViewController.h"
#import "UIView+frame.h"
#import "CommonMacro.h"
#import "MJRefresh.h"
#import "ModelCache.h"
#import "VoucherListTableViewCell.h"
#import "AssignmentInfoViewController.h"


@interface VoucherTabViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,copy ) NSString *catId;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *resultDic;

@end

@implementation VoucherTabViewController

-(instancetype)initWithCatId:(NSString *)catId{
    self = [super init];
    if (self) {
        self.catId = catId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.items = [NSMutableArray new];
    self.page = 1;
    
    [self setupUI];
    [self refreshData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    
}

#pragma mark - UITableViewDataSource
-(void)setupUI {
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.tableView.height = MainScreenHeight - NavAndStatusBarHeight - NAVIGATION_BAR_HEIGHT;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"VoucherListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    self.tableView.mj_footer.hidden = YES;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.catId) {
        return [[[ModelCache shared]readValueByKey:@"全部卡"] count];
    }
    else {
        return [[[ModelCache shared]readValueByKey:self.title] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VoucherListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    NSArray *dataArray;
    if (!self.catId) {
        dataArray = [[ModelCache shared]readValueByKey:@"全部卡"];
    }
    else {
        dataArray = [[ModelCache shared]readValueByKey:self.title];
    }
    if (dataArray.count == 0) {
        return cell;
    }
    VoucherListModel *model = dataArray[indexPath.row];
    cell.typeLabel.text = model.type;
    if ([model.type isEqualToString:@"转让"]) {
        cell.typeLabel.backgroundColor = UIColorFromRGB(0xF4CE1D);
    }
    else {
        cell.typeLabel.backgroundColor = UIColorFromRGB(0x8DC21F);
    }
    cell.titleLabel.text = model.title;
    cell.locationLabel.text = [NSString stringWithFormat:@"%@ - %@",model.name,model.location];
    cell.priceLabel.text = [[model.price description] stringByAppendingString:@"元"];
    cell.timeLabel.text = model.create_date;
    cell.deleteLabel.hidden = YES;
    cell.deleteBtn.hidden = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *dataArray;
    if (!self.catId) {
        dataArray = [[ModelCache shared]readValueByKey:@"全部卡"];
    }
    else {
        dataArray = [[ModelCache shared]readValueByKey:self.title];
    }
    VoucherListModel *model = dataArray[indexPath.row];
    AssignmentInfoViewController *vc = [[AssignmentInfoViewController alloc]init];
    vc.voucher_id = model.voucher_id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 82;
}

#pragma mark - request

- (void)refreshData
{
    [self showHub];
    __weak VoucherTabViewController *weakSelf = self;
    _page = 1;
    if (!self.catId) {
        [[NetworkAPI shared]getVoucherListByCatId:@"" page:_page WithFinish:^(NSArray *dataArray) {
            [self hideHub];
            if (dataArray != nil) {
                [_resultDic setObject:[NSNumber numberWithInteger:_page] forKey:@"全部卡"];
                [[ModelCache shared]saveValue:dataArray forKey:@"全部卡"];
            }
            else {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((MainScreenWidth - 200) / 2, 100, 200, 30)];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:14];
                label.textColor = [UIColor lightGrayColor];
                label.text = @"暂无卡券信息";
                [weakSelf.tableView addSubview:label];
            }
            [weakSelf.tableView reloadData];
            if (dataArray.count >= pageSize) {
                weakSelf.tableView.mj_footer.hidden = NO;
            }
            else {
                weakSelf.tableView.mj_footer.hidden = YES;
            }
            [weakSelf.tableView.mj_header endRefreshing];
        } withErrorBlock:^(NSError *error) {
            [weakSelf.tableView.mj_header endRefreshing];
            weakSelf.tableView.mj_footer.hidden = YES;
            [self hideHub];
            [weakSelf.tableView reloadData];
            if (error.code == NSURLErrorNotConnectedToInternet) {
                [self showAlertViewController:@"您无法连接到网络，请确认网络连接。"];
            }
        }];
    }
    else {
        [_resultDic setObject:[NSNumber numberWithInteger:_page] forKey:self.title];
        [[NetworkAPI shared]getVoucherListByCatId:self.catId page:_page WithFinish:^(NSArray *dataArray) {
            [self hideHub];
            if (dataArray != nil) {
                [[ModelCache shared]saveValue:dataArray forKey:self.title];
            }
            else {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((MainScreenWidth - 200) / 2, 100, 200, 30)];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:14];
                label.textColor = [UIColor lightGrayColor];
                label.text = @"此分类暂无卡券信息";
                [weakSelf.tableView addSubview:label];
            }
            [weakSelf.tableView reloadData];
            if (dataArray.count >= pageSize) {
                weakSelf.tableView.mj_footer.hidden = NO;
            }
            else {
                weakSelf.tableView.mj_footer.hidden = YES;
            }
            [weakSelf.tableView.mj_header endRefreshing];
        } withErrorBlock:^(NSError *error) {
            [weakSelf.tableView.mj_header endRefreshing];
            weakSelf.tableView.mj_footer.hidden = YES;
            [self hideHub];
            [weakSelf.tableView reloadData];
        }];
    }
}

- (void)loadMoreData
{
    __weak VoucherTabViewController *weakSelf = self;
    _page = _page + 1;
    if (!self.catId) {
        [[NetworkAPI shared]getVoucherListByCatId:@"" page:_page WithFinish:^(NSArray *dataArray) {
            if (dataArray != nil) {
                NSMutableArray *resultArray = [[NSMutableArray alloc]init];
                [resultArray addObjectsFromArray:[[ModelCache shared]readValueByKey:@"全部卡"]];
                [[ModelCache shared]saveValue:dataArray forKey:@"全部卡"];
                [_resultDic setObject:[NSNumber numberWithInteger:_page] forKey:@"全部卡"];
                [weakSelf.tableView reloadData];
            }
            if (dataArray.count >= pageSize) {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            else {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } withErrorBlock:^(NSError *error) {
            [weakSelf.tableView.mj_footer endRefreshing];
        }];
    }
    else {
        [[NetworkAPI shared]getVoucherListByCatId:_catId page:_page WithFinish:^(NSArray *dataArray) {
            if (dataArray != nil) {
                NSMutableArray *resultArray = [[NSMutableArray alloc]init];
                [resultArray addObjectsFromArray:[[ModelCache shared]readValueByKey:self.title]];
                [[ModelCache shared]saveValue:resultArray forKey:self.title];
                [_resultDic setObject:[NSNumber numberWithInteger:_page] forKey:self.title];
                [weakSelf.tableView reloadData];
            }
            if (dataArray.count >= pageSize) {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            else {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } withErrorBlock:^(NSError *error) {
            [weakSelf.tableView.mj_footer endRefreshing];
        }];
    }
}


@end
