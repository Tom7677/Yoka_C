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

#define LINE_WIDTH  40
@interface DisoveryViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *typeArray;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) CGFloat btnWidth;
@property (nonatomic, strong) NSMutableArray *tableViewArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) UITableView *currentTableView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableDictionary *resultDic;
@property (nonatomic, assign) BOOL hasimage;
@property (nonatomic, strong) NSMutableDictionary *imgDic;
@end

@implementation DisoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNameNotification) name:@"ChangeNameNotification" object:nil];
    _index = 0;
    self.title = @"发现";
    _tableViewArray = [[NSMutableArray alloc]init];
    _currentTableView = [[UITableView alloc]init];
    _imgDic = [[NSMutableDictionary alloc]init];
    _cityName = [[NSUserDefaults standardUserDefaults]objectForKey:@"MyCity"];
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
    [leftBtn setTitle:@"爆料" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftBtn addTarget:self action:@selector(feedbackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [self.navigationItem setRightBarButtonItem:leftItem];
    [self getType];
    _contentScrollView.delegate = self;
    _resultDic = [[NSMutableDictionary alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeNameNotification
{
    _page = 1;
    _cityName = [[NSUserDefaults standardUserDefaults]objectForKey:@"MyCity"];
    [self refreshData];
}

- (void)getType
{
    _typeArray = [[NSMutableArray alloc]init];
    [[NetworkAPI shared]getArticleTypeWithFinish:^(NSArray *dataArray) {
        [_typeArray addObjectsFromArray:dataArray];
        [self createBtn];
        [self refreshData];
    } withErrorBlock:^(NSError *error) {
        
    }];
}

/**
 *  爆料
 */
- (void)feedbackAction {
    [[NetworkAPI shared]getFeedbackURLWithFinish:^(BOOL isSuccess, NSString *urlStr) {
        if (isSuccess) {
            WebViewController *vc = [[WebViewController alloc]initWithURLString:urlStr titleLabel:@"爆料"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            [self showAlertViewController:@"请检查您的网络"];
        }
    } withErrorBlock:^(NSError *error) {
        [self showAlertViewController:@"请检查您的网络"];
    }];
    [[UMengAnalyticsUtil shared]factBtn];
}

/**
 *  创建顶部选择按钮
 */
- (void) createBtn {
    if (_typeArray.count + 1 >= 7) {
        _btnWidth = (MainScreenWidth-40) / 7;
    }
    else {
        _btnWidth = (MainScreenWidth-40) / (_typeArray.count + 1);
    }
    for (int i = 0; i < _typeArray.count + 1; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(20 + _btnWidth * i, 0, _btnWidth, _typeScrollView.height)];
        NSMutableArray *dataArray = [[NSMutableArray alloc]init];
        if (i == 0) {
            [btn setTitle:@"推荐" forState:UIControlStateNormal];
            [_resultDic setObject:dataArray forKey:@"推荐"];
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
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, _typeScrollView.size.height + _typeScrollView.originY - 0.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
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
        [tableView registerNib:[UINib nibWithNibName:@"DiscoveryTableViewCell" bundle:nil] forCellReuseIdentifier:@"myIdentify"];
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
            tableView.mj_footer.hidden = YES;
        });
    }
}

- (void)refreshData
{
    __weak DisoveryViewController *weakSelf = self;
    _page = 1;
    if (_index == 0) {
        [[NetworkAPI shared]getTopArticleListByCity:_cityName page:_page WithFinish:^(NSArray *dataArray) {
            if (dataArray != nil) {
                [_resultDic setObject:dataArray forKey:@"推荐"];
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
        [[NetworkAPI shared]getArticleListByCatId:model.cat_id cityName:_cityName page:_page WithFinish:^(NSArray *dataArray) {
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
    __weak DisoveryViewController *weakSelf = self;
    _page = _page + 1;
    if (_index == 0) {
        [[NetworkAPI shared]getTopArticleListByCity:_cityName page:_page WithFinish:^(NSArray *dataArray) {
            if (dataArray != nil) {
                NSMutableArray *resultArray = [[NSMutableArray alloc]init];
                [resultArray addObjectsFromArray:_resultDic[@"推荐"]];
                [_resultDic setObject:resultArray forKey:@"推荐"];
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
        [[NetworkAPI shared]getArticleListByCatId:model.cat_id cityName:_cityName page:_page WithFinish:^(NSArray *dataArray) {
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
        if ([_resultDic[@"推荐"] count] <= pageSize) {
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
        return [_resultDic[@"推荐"] count];
    }
    else {
        ArticleTypeModel *model = _typeArray[_index - 1];
        return [_resultDic[model.cat_name] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *dataArray;
    if (_index == 0) {
        dataArray = _resultDic[@"推荐"];
    }
    else {
        ArticleTypeModel *model = _typeArray[_index - 1];
        dataArray = _resultDic[model.cat_name];
    }
    ArticleModel *model = dataArray[indexPath.row];
    if ([self isEmpty:model.image]) {
        DiscoveryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myIdentify"];
        cell.titleLabel.text = model.title;
        cell.detailsLabel.text = [NSString stringWithFormat:@"阅读：%@   点赞：%@   分享：%@",  model.read_num, model.like_num, model.share_num];
        return cell;
    }else {
        DiscoveryWithImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentify"];
        cell.titleLabel.text = model.title;
        cell.contentLabel.text = model.preview;
        cell.detailsLabel.text = [NSString stringWithFormat:@"阅读：%@   点赞：%@   分享：%@", model.read_num, model.like_num, model.share_num];
        [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:[imageUrl stringByAppendingString:model.image]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [_imgDic setObject:image forKey:[imageURL description]];
        }];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *dataArray;
    if (_index == 0) {
        dataArray = _resultDic[@"推荐"];
    }
    else {
        ArticleTypeModel *model = _typeArray[_index - 1];
        dataArray = _resultDic[model.cat_name];
    }
    ArticleModel *model = dataArray[indexPath.row];
    ArticleViewController *vc = [[ArticleViewController alloc]init];
    vc.urlStr = model.jump_link;
    vc.articleTitle = model.title;
    vc.articleContent = model.preview;
    vc.articleId = model.article_id;
    vc.coverImage = [_imgDic objectForKey:[imageUrl stringByAppendingString:model.image]];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    [[NetworkAPI shared]updateArticleDataByType:hasread AndArticleId:model.article_id];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *dataArray;
    if (_index == 0) {
        dataArray = _resultDic[@"推荐"];
    }
    else {
        ArticleTypeModel *model = _typeArray[_index - 1];
        dataArray = _resultDic[model.cat_name];
    }
    ArticleModel *model = dataArray[indexPath.row];
    if ([self isEmpty:model.image]) {
        DiscoveryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myIdentify"];
        cell.titleLabel.text = model.title;
        cell.titleLabel.width = MainScreenWidth - 32;
        return [cell.titleLabel getTextHeight] + cell.detailsLabel.height + 36;
    }else {
        DiscoveryWithImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentify"];
        cell.titleLabel.text = model.title;
        cell.titleLabel.width = MainScreenWidth - 20;
        cell.contentLabel.text = model.preview;
        cell.contentLabel.width = MainScreenWidth - 20;
        //12是coverImageView距离cell顶部距离
        CGFloat height = 12;
        //133是屏幕宽为320情况下coverImageView高 300是宽
        height = height + 133 * (MainScreenWidth - 20) / 300;
        //18是titleLabel与coverImageView间距
        height = height + [cell.titleLabel getTextHeight] + 18;
        //2是detailsLabel与titleLabel间距 16是detailsLabel高
        height = height + 2 + 16;
        //8是contentLabel与detailsLabel间距
        height = height + 8 + [cell.contentLabel getTextHeight];
        //8是阅读更多label与contentLabel间距 30是其高度，18是线的高度及阅读更多label与线间距的和
        height = height + 8 + 30 + 18;
        return height;
    }
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
