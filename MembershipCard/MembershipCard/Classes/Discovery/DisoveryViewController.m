//
//  DisoveryViewController.m
//  MembershipCard
//
//  Created by  on 16/3/3.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "DisoveryViewController.h"
#import "DiscoveryWithImageCell.h"
#import "UIView+frame.h"

#define LINE_WIDTH  40
@interface DisoveryViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) NSArray *typeArray;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) CGFloat btnWidth;
@end

@implementation DisoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发现";
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
    [leftBtn setTitle:@"爆料" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftBtn addTarget:self action:@selector(topNews) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 28)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"商户" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(NearbyMerchant) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];
    _typeArray = [NSArray arrayWithObjects:@"推荐",@"美食",@"丽人",@"亲子",@"购物",@"娱乐",@"其他", nil];
    [self createBtn];
    _contentScrollView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  商户
 */
- (void) NearbyMerchant {
    
}

/**
 *  爆料
 */
- (void) topNews {
    
}

/**
 *  创建顶部选择按钮
 */
- (void) createBtn {
    _btnWidth = MainScreenWidth / 7;
    for (int i = 0; i < _typeArray.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(_btnWidth * i, 0, _btnWidth, _typeScrollView.height)];
        [btn setTitle:[_typeArray objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0xFF526E) forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = i + 1;
        if (i == 0) {
            [self actionbtn:btn];
        }
        [btn addTarget:self action:@selector(actionbtn:) forControlEvents:UIControlEventTouchUpInside];
        [_typeScrollView addSubview:btn];
    }
    [_typeScrollView setContentSize:CGSizeMake(_btnWidth * _typeArray.count + 10, _typeScrollView.height)];
    _scrollBgView = [[UIView alloc] initWithFrame:CGRectMake((_btnWidth - LINE_WIDTH) / 2, _typeScrollView.height - 3, LINE_WIDTH, 3)];
    [_scrollBgView setBackgroundColor:UIColorFromRGB(0xffd500)];
    [_typeScrollView addSubview:_scrollBgView];
    [_contentScrollView setContentSize:CGSizeMake(MainScreenWidth * _typeArray.count, 0)];
    //[self addTableViewToScrollView:_contentScrollView frame:CGRectZero];
}

- (void)actionbtn:(UIButton *)btn
{
    [_contentScrollView setContentOffset:CGPointMake(MainScreenWidth * (btn.tag - 1), 0) animated:YES];
    float xx = MainScreenWidth * (btn.tag - 1) * (_btnWidth / MainScreenWidth) - _btnWidth;
    [_typeScrollView scrollRectToVisible:CGRectMake(xx, 0, MainScreenWidth, _typeScrollView.height) animated:YES];
}

- (void)changeView:(float)x
{
    float xx = x * (_btnWidth / MainScreenWidth);
    [_scrollBgView setFrame:CGRectMake(xx + (_btnWidth - LINE_WIDTH) / 2, _scrollBgView.originY, _scrollBgView.width, _scrollBgView.height)];
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
