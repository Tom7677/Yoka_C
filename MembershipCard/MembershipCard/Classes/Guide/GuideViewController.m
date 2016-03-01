//
//  GuideViewController.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/21.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "GuideViewController.h"

@interface GuideViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,MainScreenHeight  - 30, MainScreenWidth, 30)];
    _pageControl.numberOfPages = 3;
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [self.view addSubview:_pageControl];
    _scrollView.contentSize = CGSizeMake(MainScreenWidth * 3, _scrollView.frame.size.height);
    
    NSArray *picArray = [NSArray arrayWithObjects:@"guide_1",@"guide_2",@"guide_3", nil];
    for (int i = 0; i < picArray.count; i ++) {
        CGFloat originWidth = MainScreenWidth;
        CGFloat originHeight = MainScreenHeight;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(originWidth * i, 0, originWidth, originHeight)];
        imageView.image = [UIImage imageNamed:picArray[i]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_scrollView addSubview:imageView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)enter
{
    if (self.EnterMainVC) {
        self.EnterMainVC();
    }
}

/**
 *  UIScrollViewDelegate
 *
 *  @param scrollView 代理方法
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = CGRectGetWidth(self.view.frame);
    CGFloat pageFraction = self.scrollView.contentOffset.x / pageWidth;
    self.pageControl.currentPage = roundf(pageFraction);
    if (pageFraction > 2) {
        [self enter];
    }
}
@end
