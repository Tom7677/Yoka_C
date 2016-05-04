//
//  DisoveryTabViewController.m
//  MembershipCard
//
//  Created by DT on 16/5/4.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "DisoveryTabViewController.h"
#import "DiscoveryTableViewCell.h"
#import "DiscoveryWithImageCell.h"
#import <UIImageView+WebCache.h>
#import "MJRefresh.h"
#import "ModelCache.h"
#import "UILabel+caculateSize.h"
#import "UIView+frame.h"
#import "CommonMacro.h"
#import "ArticleViewController.h"

@interface DisoveryTabViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign)   NSInteger page;

@property (nonatomic,copy ) NSString *catId;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableDictionary *imgDic;
@end

@implementation DisoveryTabViewController

#pragma mark - life cycle

-(instancetype)initWithCatId:(NSString *)catId cityName:(NSString*)cityName {
    self = [super init];
    if (self) {
        self.catId = catId;
        self.cityName = cityName;
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleModel *model = [[ArticleModel alloc]init];
    if (_items.count != 0) {
        model = _items[indexPath.row];
    }
    if ([self isEmpty:model.image]) {
        DiscoveryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myIdentify"];
        cell.titleLabel.text = model.title;
        cell.detailsLabel.text = [NSString stringWithFormat:@"阅读：%@   点赞：%@   分享：%@",  model.read_num, model.like_num, model.share_num];
        return cell;
    }else {
        DiscoveryWithImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentify"];
        cell.titleLabel.text = model.title;
        cell.contentLabel.text = model.preview;
        [cell.contentLabel setTextLineSpacing:4 paragraphSpacing:0];
        cell.detailsLabel.text = [NSString stringWithFormat:@"阅读：%@   点赞：%@   分享：%@", model.read_num, model.like_num, model.share_num];
        [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:[imageUrl stringByAppendingString:model.image]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image != nil) {
                [_imgDic setObject:image forKey:[imageURL description]];
            }
        }];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ArticleModel *model = _items[indexPath.row];
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


-(void)setupUI {
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.tableView.height = self.tableView.height - NavAndStatusBarHeight - TabbarHeight - NAV_TAB_BAR_HEIGHT;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registerNib:[UINib nibWithNibName:@"DiscoveryTableViewCell" bundle:nil] forCellReuseIdentifier:@"myIdentify"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DiscoveryWithImageCell" bundle:nil] forCellReuseIdentifier:@"cellIdentify"];
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    self.tableView.mj_footer.hidden = YES;
}

#pragma mark - request
-(void) refreshData {
    __weak DisoveryTabViewController *weakSelf = self;
    if (!self.catId) {
        [self showHub];
        [[NetworkAPI shared]getTopArticleListByCity:self.cityName page:self.page WithFinish:^(NSArray *dataArray) {
            [self hideHub];
            [self.items addObjectsFromArray:dataArray];
            if (dataArray != nil) {
                [[ModelCache shared]saveValue:dataArray forKey:self.title];
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
            NSArray *dataArray = [[ModelCache shared]readValueByKey:self.title];
            [self.items addObjectsFromArray:dataArray];
            
            [weakSelf.tableView.mj_header endRefreshing];
            weakSelf.tableView.mj_footer.hidden = YES;
            [self hideHub];
            [weakSelf.tableView reloadData];
            if (error.code == NSURLErrorNotConnectedToInternet) {
                [self showAlertViewController:@"您无法连接到网络，请确认网络连接。"];
            }
        }];
    }else {
        [[NetworkAPI shared]getArticleListByCatId:self.catId cityName:self.cityName page:self.page WithFinish:^(NSArray *dataArray) {
            [self hideHub];
            [self.items addObjectsFromArray:dataArray];
            if (dataArray != nil) {
                [[ModelCache shared]saveValue:dataArray forKey:self.title];
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
            NSArray *dataArray = [[ModelCache shared]readValueByKey:self.title];
            [self.items addObjectsFromArray:dataArray];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            weakSelf.tableView.mj_footer.hidden = YES;
            [self hideHub];
        }];
    }
}

- (void)loadMoreData
{
    __weak DisoveryTabViewController *weakSelf = self;
    _page= _page + 1;
    if (!self.catId) {
        [[NetworkAPI shared]getTopArticleListByCity:self.cityName page:self.page WithFinish:^(NSArray *dataArray) {
            if (dataArray != nil) {
                [_items addObjectsFromArray:dataArray];
                [[ModelCache shared]saveValue:_items forKey:self.title];
            }
            [weakSelf.tableView reloadData];
            if (dataArray.count >= pageSize) {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            else {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            };
        } withErrorBlock:^(NSError *error) {
            [weakSelf.tableView.mj_footer endRefreshing];
        }];
    }else {
        [[NetworkAPI shared]getArticleListByCatId:self.catId cityName:self.cityName page:self.page WithFinish:^(NSArray *dataArray) {
            if (dataArray != nil) {
                [_items addObjectsFromArray:dataArray];
                [[ModelCache shared]saveValue:_items forKey:self.title];
            }
            [weakSelf.tableView reloadData];
            if (dataArray.count >= pageSize) {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            else {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            };
        } withErrorBlock:^(NSError *error) {
            [weakSelf.tableView.mj_footer endRefreshing];
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleModel *model = [[ArticleModel alloc]init];
    if (_items.count != 0) {
        model = _items[indexPath.row];
    }
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
        //14是coverImageView距离cell顶部距离
        CGFloat height = 14;
        //150是屏幕宽为320情况下coverImageView高 300是宽
        height = height + 150 * (MainScreenWidth - 20) / 300;
        //14是titleLabel与coverImageView间距
        height = height + [cell.titleLabel getTextHeight] + 14;
        //2是detailsLabel与titleLabel间距 16是detailsLabel高
        height = height + 2 + 16;
        //8是contentLabel与detailsLabel间距
        height = height + 8 + [cell.contentLabel getTextHeightWithLineSpacing:4 paragraphSpacing:0];
        //12是阅读更多label与contentLabel间距 30是其高度，12是线的高度及阅读更多label与线间距的和
        height = height + 12 + 30 + 12;
        return height;
    }
}
@end
