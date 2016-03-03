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

#define MENU_BUTTON_WIDTH  70
@interface DisoveryViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) NSArray *typeArray;
@property (nonatomic, assign) CGFloat scrollBeginX;
@end

@implementation DisoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发现";
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 28)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"商户" forState:UIControlStateNormal];
    [rightBtn setTitleColor:UIColorFromRGB(0xFF526E) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(NearbyMerchant) forControlEvents:UIControlEventTouchUpInside];
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

- (void)NearbyMerchant {
    
}

- (void)createBtn
{
    for (int i = 0; i < _typeArray.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(MENU_BUTTON_WIDTH * i, 0, MENU_BUTTON_WIDTH, _typeScrollView.height)];
        [btn setTitle:[_typeArray objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0xFF526E) forState:UIControlStateSelected];
        if (i == 0) {
            btn.selected = YES;
        }
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = i + 1;
        [btn addTarget:self action:@selector(actionbtn:) forControlEvents:UIControlEventTouchUpInside];
        [_typeScrollView addSubview:btn];
    }
    [_typeScrollView setContentSize:CGSizeMake(MENU_BUTTON_WIDTH * _typeArray.count, _typeScrollView.height)];
    _scrollBgView = [[UIView alloc] initWithFrame:CGRectMake(0, _typeScrollView.height - 2, MENU_BUTTON_WIDTH, 2)];
    [_scrollBgView setBackgroundColor:UIColorFromRGB(0xFF526E)];
    [_typeScrollView addSubview:_scrollBgView];
    [_contentScrollView setContentSize:CGSizeMake(MainScreenWidth * _typeArray.count, 0)];
    //[self addTableViewToScrollView:_contentScrollView frame:CGRectZero];
}

- (void)actionbtn:(UIButton *)btn
{
    [_contentScrollView setContentOffset:CGPointMake(MainScreenWidth * (btn.tag - 1), 0) animated:YES];
    float xx = MainScreenWidth * (btn.tag - 1) * (MENU_BUTTON_WIDTH / MainScreenWidth) - MENU_BUTTON_WIDTH;
    [_typeScrollView scrollRectToVisible:CGRectMake(xx, 0, MainScreenWidth, _typeScrollView.height) animated:YES];
}

- (void)changeView:(float)x
{
    float xx = (_scrollBeginX + MainScreenWidth) * (MENU_BUTTON_WIDTH / MainScreenWidth);
    [_scrollBgView setFrame:CGRectMake(xx, _scrollBgView.originY, _scrollBgView.width, _scrollBgView.height)];
//    if (fabs(x - _scrollBeginX) > MainScreenWidth / 2) {
//        if (x > _scrollBeginX) {
//            float xx = (_scrollBeginX + MainScreenWidth) * (MENU_BUTTON_WIDTH / MainScreenWidth);
//            [_scrollBgView setFrame:CGRectMake(xx, _scrollBgView.originY, _scrollBgView.width, _scrollBgView.height)];
//        }
//        else {
//            float xx = (_scrollBeginX - MainScreenWidth) * (MENU_BUTTON_WIDTH / MainScreenWidth);
//            [_scrollBgView setFrame:CGRectMake(xx, _scrollBgView.originY, _scrollBgView.width, _scrollBgView.height)];
//        }
//    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"%f",scrollView.contentOffset.x);
    _scrollBeginX = scrollView.contentOffset.x;
}


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
        float xx = scrollView.contentOffset.x * (MENU_BUTTON_WIDTH / MainScreenWidth) - MENU_BUTTON_WIDTH;
        [_typeScrollView scrollRectToVisible:CGRectMake(xx, 0, MainScreenWidth, _typeScrollView.height) animated:YES];
    }
}
@end
