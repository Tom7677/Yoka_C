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
#import "UITableView+FDTemplateLayoutCell.h"
#import "ArticleViewController.h"
#import "YKModel.h"
#import <UIImageView+WebCache.h>


#define LINE_WIDTH  40
@interface DisoveryViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *typeArray;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) CGFloat btnWidth;
@property (nonatomic, strong) NSMutableArray *tableViewArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) UITableView *currentTableView;
@end

@implementation DisoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeNameNotification) name:@"ChangeNameNotification" object:nil];
    _page = 1;
    self.title = @"发现";
    _tableViewArray = [[NSMutableArray alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    _currentTableView = [[UITableView alloc]init];
    _cityName = [[NSUserDefaults standardUserDefaults]objectForKey:@"MyCity"];
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
    [leftBtn setTitle:@"爆料" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftBtn addTarget:self action:@selector(topNews) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    [self getType];
    _contentScrollView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)ChangeNameNotification
{
    _page = 1;
    [self refreshData];
}

- (void)getType
{
    _typeArray = [[NSMutableArray alloc]init];
    [[NetworkAPI shared]getArticleTypeWithFinish:^(NSArray *dataArray) {
        [_typeArray addObjectsFromArray:dataArray];
        [self createBtn];
    } withErrorBlock:^(NSError *error) {
        
    }];
}

/**
 *  爆料
 */
- (void) topNews {
    [[UMengAnalyticsUtil shared]factBtn];
}

/**
 *  创建顶部选择按钮
 */
- (void) createBtn {
    _btnWidth = (MainScreenWidth-40) / (_typeArray.count + 1);
    for (int i = 0; i < _typeArray.count + 1; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(20 + _btnWidth * i, 0, _btnWidth, _typeScrollView.height)];
        if (i == 0) {
            [btn setTitle:@"推荐" forState:UIControlStateNormal];
        }
        else {
            ArticleTypeModel *model = _typeArray[i - 1];
            [btn setTitle:model.cat_name forState:UIControlStateNormal];
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
        [self addTableViewToScrollView:_contentScrollView count:_typeArray.count + 1 frame:CGRectZero];
        [self getTopArticleListByPage:1];
    });
}

- (void)addTableViewToScrollView:(UIScrollView *)scrollView count:(NSUInteger)pageCount frame:(CGRect)frame
{
    for (int i = 0; i < pageCount; i++) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(MainScreenWidth * i, 0 , MainScreenWidth, MainScreenHeight - 40 - NavAndStatusBarHeight - TabbarHeight)];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        tableView.tag = i;
//        [tableView registerNib:[UINib nibWithNibName:@"DiscoveryTableViewCell" bundle:nil] forCellReuseIdentifier:@"myIdentify"];
        [tableView registerNib:[UINib nibWithNibName:@"DiscoveryWithImageCell" bundle:nil] forCellReuseIdentifier:@"cellIdentify"];
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
        });
    }
}

- (void)refreshData
{
    [_currentTableView reloadData];
}

- (void)loadMoreData
{
    
}
- (void)getTopArticleListByPage:(NSInteger)pageNo{
    if (pageNo == 1) {
        [_dataArray removeAllObjects];
    }
    [[NetworkAPI shared]getTopArticleListByCity:_cityName page:pageNo WithFinish:^(NSArray *dataArray) {
        [_dataArray addObjectsFromArray:dataArray];
        [self refreshData];
    } withErrorBlock:^(NSError *error) {
        
    }];
}
- (void)getArticleListByCatId:(NSString *)catId AndPage:(NSInteger)pageNo {
    if (pageNo == 1) {
        [_dataArray removeAllObjects];
    }
    [[NetworkAPI shared]getArticleListByCatId:catId cityName:_cityName page:pageNo WithFinish:^(NSArray *dataArray) {
        [_dataArray addObjectsFromArray:dataArray];
        [self refreshData];
    } withErrorBlock:^(NSError *error) {
        
    }];
}

- (void)actionbtn:(UIButton *)btn
{
    if (_tableViewArray.count > 0) {
        _currentTableView = _tableViewArray[btn.tag - 1];

    }
    [_contentScrollView setContentOffset:CGPointMake(MainScreenWidth * (btn.tag - 1), 0) animated:YES];
    if (btn.tag > 1) {
        ArticleTypeModel *model = _typeArray[btn.tag - 2];
        [self getArticleListByCatId:model.cat_id AndPage:1];
    }else {
        [self getTopArticleListByPage:1];
    }
    float xx = MainScreenWidth * (btn.tag - 1) * (_btnWidth / MainScreenWidth) - _btnWidth;
    [_typeScrollView scrollRectToVisible:CGRectMake(xx, 0, MainScreenWidth, _typeScrollView.height) animated:YES];

}

- (void)changeView:(float)x
{
    float xx = x * (_btnWidth / MainScreenWidth);
    [_scrollBgView setFrame:CGRectMake(xx + (_btnWidth - LINE_WIDTH) / 2 + 20, _scrollBgView.originY, _scrollBgView.width, _scrollBgView.height)];
}

#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiscoveryWithImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentify"];
    cell.fd_enforceFrameLayout = YES;
    ArticleModel *model = _dataArray[indexPath.row];
    cell.titleLabel.text = model.title;
    cell.contentLabel.text = model.preview;
    [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleViewController *vc = [[ArticleViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"cellIdentify" configuration:^(DiscoveryWithImageCell *cell) {
            
        }];
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
    }
}
@end
