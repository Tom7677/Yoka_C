//
//  WebViewController.m
//  MembershipCard
//
//  Created by tom.sun on 16/3/29.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) NSString *urlStr;
@end

@implementation WebViewController
- (instancetype)initWithURLString:(NSString *)urlStr titleLabel:(NSString *)title
{
    self = [super init];
    if (self) {
        _urlStr = urlStr;
        _titleString = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _titleString;
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    [self.view addSubview:_webView];
    _webView.delegate = self;
    //webVeiw禁止左右滑动
    _webView.scrollView.contentSize = CGSizeMake(MainScreenWidth, MainScreenHeight);
    _webView.scrollView.bounces = YES;
    _webView.scalesPageToFit = NO;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
