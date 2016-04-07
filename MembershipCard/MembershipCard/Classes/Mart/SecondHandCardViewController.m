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
#import "VoucherListTableViewCell.h"
#import "AlbumPickerViewController.h"
#import "TZImagePickerController.h"

#define LINE_WIDTH  50
@interface SecondHandCardViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,TZImagePickerControllerDelegate>
@property (nonatomic, strong) NSMutableArray *typeArray;
@property (nonatomic, assign) CGFloat btnWidth;
@property (nonatomic, strong) NSMutableArray *tableViewArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UITableView *currentTableView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableDictionary *resultDic;
@property (strong, nonatomic) UIView *scrollBgView;
@end

@implementation SecondHandCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"二手卡券";
    _typeArray = [[NSMutableArray alloc]init];
    _tableViewArray = [[NSMutableArray alloc]init];
    _currentTableView = [[UITableView alloc]init];
    _resultDic = [[NSMutableDictionary alloc]init];
    _index = 0;
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 28)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"发布" forState:UIControlStateNormal];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(releaseAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    _contentScrollView.delegate = self;
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"VoucherType"] != nil) {
        NSArray *resultArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"VoucherType"];
        [self getTypeArray:resultArray];
        [self createBtn];
        [self refreshData];
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
            [self refreshData];
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
//    SellCardViewController *vc = [[SellCardViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//    AssignmentInfoViewController *vc = [[AssignmentInfoViewController alloc]init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//    AlbumPickerViewController *vc = [[AlbumPickerViewController alloc]init];
//    vc.isToAlbum = NO;
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVc.allowPickingOriginalPhoto = NO;
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void) createBtn
{
    if (_typeArray.count + 1 >= 6) {
        _btnWidth = (MainScreenWidth-40) / 6;
    }
    else {
        _btnWidth = (MainScreenWidth-40) / (_typeArray.count + 1);
    }
    for (int i = 0; i < _typeArray.count + 1; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(20 + _btnWidth * i, 0, _btnWidth, _typeScrollView.height)];
        NSMutableArray *dataArray = [[NSMutableArray alloc]init];
        if (i == 0) {
            [btn setTitle:@"全部" forState:UIControlStateNormal];
            [_resultDic setObject:dataArray forKey:@"全部"];
        }
        else {
            ArticleTypeModel *model = _typeArray[i - 1];
            [btn setTitle:model.cat_name forState:UIControlStateNormal];
            [_resultDic setObject:dataArray forKey:model.cat_name];
        }
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0xFF526E) forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = i + 1;
        [btn addTarget:self action:@selector(actionbtn:) forControlEvents:UIControlEventTouchUpInside];
        
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            [_typeScrollView addSubview:btn];
        });
    }
    [_typeScrollView setContentSize:CGSizeMake(_btnWidth * (_typeArray.count + 1) + 40, _typeScrollView.height)];
    _scrollBgView = [[UIView alloc] initWithFrame:CGRectMake((_btnWidth - LINE_WIDTH) / 2 + 20, _typeScrollView.height - 4, LINE_WIDTH, 10)];
    [_scrollBgView setBackgroundColor:UIColorFromRGB(0xffd500)];
    [_typeScrollView addSubview:_scrollBgView];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, _typeScrollView.size.height + _typeScrollView.originY - 1, [UIScreen mainScreen].bounds.size.width, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [_typeScrollView addSubview:lineView];
    _typeScrollView.backgroundColor = [UIColor whiteColor];
    [_contentScrollView setContentSize:CGSizeMake(MainScreenWidth * (_typeArray.count + 1), 0)];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // 处理耗时操作的代码块...
        [self addTableViewToScrollView:_contentScrollView count:_typeArray.count + 1];
    });
}

- (void)addTableViewToScrollView:(UIScrollView *)scrollView count:(NSUInteger)pageCount
{
    for (int i = 0; i < pageCount; i++) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(MainScreenWidth * i, 0 , MainScreenWidth, MainScreenHeight - 40 - NavAndStatusBarHeight - TabbarHeight)];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        tableView.tag = i;
        [tableView registerNib:[UINib nibWithNibName:@"VoucherListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
        [_tableViewArray addObject:tableView];
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            [scrollView addSubview:tableView];
            if (i == 0) {
                _currentTableView = tableView;
            }
            tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [self refreshData];
            }];
            tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [self loadMoreData];
            }];
            tableView.mj_footer.hidden = YES;
        });
    }
}

- (void)refreshData
{
    __weak SecondHandCardViewController *weakSelf = self;
    _page = 1;
    if (_index == 0) {
        [[NetworkAPI shared]getVoucherListByCatId:@"" page:_page WithFinish:^(NSArray *dataArray) {
            if (dataArray != nil) {
                [_resultDic setObject:dataArray forKey:@"全部"];
                [weakSelf.currentTableView reloadData];
            }
            if (dataArray.count >= pageSize) {
                weakSelf.currentTableView.mj_footer.hidden = NO;
            }
            else {
                weakSelf.currentTableView.mj_footer.hidden = YES;
            }
            [weakSelf.currentTableView.mj_header endRefreshing];
        } withErrorBlock:^(NSError *error) {
            
        }];
    }
    else {
        ArticleTypeModel *model = _typeArray[_index - 1];
        [[NetworkAPI shared]getVoucherListByCatId:model.cat_id page:_page WithFinish:^(NSArray *dataArray) {
            if (dataArray != nil) {
                [_resultDic setObject:dataArray forKey:model.cat_name];
                [weakSelf.currentTableView reloadData];
            }
            if (dataArray.count >= pageSize) {
                weakSelf.currentTableView.mj_footer.hidden = NO;
            }
            else {
                weakSelf.currentTableView.mj_footer.hidden = YES;
            }
            [weakSelf.currentTableView.mj_header endRefreshing];
        } withErrorBlock:^(NSError *error) {
            
        }];
    }
}

- (void)loadMoreData
{
    __weak SecondHandCardViewController *weakSelf = self;
    _page = _page + 1;
    if (_index == 0) {
        [[NetworkAPI shared]getVoucherListByCatId:@"" page:_page WithFinish:^(NSArray *dataArray) {
            if (dataArray != nil) {
                NSMutableArray *resultArray = [[NSMutableArray alloc]init];
                [resultArray addObjectsFromArray:_resultDic[@"全部"]];
                [_resultDic setObject:resultArray forKey:@"全部"];
                [weakSelf.currentTableView reloadData];
            }
            if (dataArray.count >= pageSize) {
                [weakSelf.currentTableView.mj_footer endRefreshing];
            }
            else {
                [weakSelf.currentTableView.mj_footer endRefreshingWithNoMoreData];
            }
        } withErrorBlock:^(NSError *error) {
            
        }];
    }
    else {
        ArticleTypeModel *model = _typeArray[_index - 1];
        [[NetworkAPI shared]getVoucherListByCatId:model.cat_id page:_page WithFinish:^(NSArray *dataArray) {
            if (dataArray != nil) {
                NSMutableArray *resultArray = [[NSMutableArray alloc]init];
                [resultArray addObjectsFromArray:_resultDic[model.cat_name]];
                [_resultDic setObject:resultArray forKey:model.cat_name];
                [weakSelf.currentTableView reloadData];
            }
            if (dataArray.count >= pageSize) {
                [weakSelf.currentTableView.mj_footer endRefreshing];
            }
            else {
                [weakSelf.currentTableView.mj_footer endRefreshingWithNoMoreData];
            }
        } withErrorBlock:^(NSError *error) {
            
        }];
    }
}

- (void)actionbtn:(UIButton *)btn
{
    if (_tableViewArray.count > 0) {
        _currentTableView = _tableViewArray[btn.tag - 1];
    }
    _index = btn.tag - 1;
    [_contentScrollView setContentOffset:CGPointMake(MainScreenWidth * (btn.tag - 1), 0) animated:YES];
    float xx = MainScreenWidth * (btn.tag - 1) * (_btnWidth / MainScreenWidth) - _btnWidth;
    [_typeScrollView scrollRectToVisible:CGRectMake(xx, 0, MainScreenWidth, _typeScrollView.height) animated:YES];
    if (_index == 0) {
        if ([_resultDic[@"全部"] count] <= pageSize) {
            [self refreshData];
        }
    }
    else {
        ArticleTypeModel *model = _typeArray[_index - 1];
        if ([_resultDic[model.cat_name] count] <= pageSize) {
            [self refreshData];
        }
    }
}

- (void)changeView:(float)x
{
    float xx = x * (_btnWidth / MainScreenWidth);
    [_scrollBgView setFrame:CGRectMake(xx + (_btnWidth - LINE_WIDTH) / 2 + 20, _scrollBgView.originY, _scrollBgView.width, _scrollBgView.height)];
}

#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_index == 0) {
        return [_resultDic[@"全部"] count];
    }
    else {
        ArticleTypeModel *model = _typeArray[_index - 1];
        return [_resultDic[model.cat_name] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VoucherListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    NSArray *dataArray;
    if (_index == 0) {
        dataArray = _resultDic[@"全部"];
    }
    else {
        ArticleTypeModel *model = _typeArray[_index - 1];
        dataArray = _resultDic[model.cat_name];
    }
    VoucherListModel *model = dataArray[indexPath.row];
    cell.typeLabel.text = model.type;
    if ([model.type isEqualToString:@"转让"]) {
        cell.typeLabel.backgroundColor = UIColorFromRGB(0xeeeeb5);
    }
    else {
        cell.typeLabel.backgroundColor = UIColorFromRGB(0xbbbbc4);
    }
    cell.titleLabel.text = model.title;
    cell.locationLabel.text = [NSString stringWithFormat:@"%@ - %@",model.name,model.location];
    cell.priceLabel.text = [[model.price description] stringByAppendingString:@"元"];
    cell.titleLabel.text = model.create_date;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *dataArray;
    if (_index == 0) {
        dataArray = _resultDic[@"全部"];
    }
    else {
        ArticleTypeModel *model = _typeArray[_index - 1];
        dataArray = _resultDic[model.cat_name];
    }
    VoucherListModel *model = dataArray[indexPath.row];
    AssignmentInfoViewController *vc = [[AssignmentInfoViewController alloc]init];
    vc.voucher_id = model.voucher_id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        //tableView
    }
    else {
        [self changeView:scrollView.contentOffset.x];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        //tableView
    }
    else {
        float xx = scrollView.contentOffset.x * (_btnWidth / MainScreenWidth) - _btnWidth;
        [_typeScrollView scrollRectToVisible:CGRectMake(xx, 0, MainScreenWidth, _typeScrollView.height) animated:YES];
        int i = (scrollView.contentOffset.x / MainScreenWidth);
        _index = i;
    }
}
@end
