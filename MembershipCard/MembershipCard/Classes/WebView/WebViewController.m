//
//  WebViewController.m
//  MembershipCard
//
//  Created by tom.sun on 16/3/29.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>
//@property (nonatomic, strong) UIWebView *webView;
//@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) NSString *urlStr;
@end

@implementation WebViewController

- (instancetype)initWithURLString:(NSString *)urlStr titleLabel:(NSString *)title
{
    self = [super init];
    if (self) {
        _urlStr = urlStr;
        self.title = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = _titleString;
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    [self.view addSubview:_webView];
    _webView.delegate = self;
    //webVeiw禁止左右滑动
    _webView.scrollView.contentSize = CGSizeMake(MainScreenWidth, MainScreenHeight);
    _webView.scrollView.bounces = YES;
    _webView.scalesPageToFit = YES;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]]];
}

- (instancetype)initWithWebNavigationAndURLString:(NSString *)urlStr {
    self = [super init];
    if (self) {
        _urlStr = urlStr;
    }
    [self setupWebNavigation];
    return self;
}
- (void)setupWebNavigation{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        if (i == 0) {
            [btn setImage:[UIImage imageNamed:@"web_share"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(webShare) forControlEvents:UIControlEventTouchUpInside];
        }else if (i == 1) {
            [btn setImage:[UIImage imageNamed:@"web_refresh"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(webReload) forControlEvents:UIControlEventTouchUpInside];
        }else {
            [btn setImage:[UIImage imageNamed:@"web_back"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(webGoBack) forControlEvents:UIControlEventTouchUpInside];
        }
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
        [tempArray addObject:item];
    }
    self.navigationItem.rightBarButtonItems = [tempArray copy];
}

- (void)webGoBack {
    if (_webView.canGoBack) {
        [_webView goBack];
    }
}
- (void)webReload {
    [_webView reload];
}

- (void)webShare {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
