//
//  WebViewController.m
//  MembershipCard
//
//  Created by tom.sun on 16/3/29.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    [self.view addSubview:_webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
