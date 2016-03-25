//
//  ArticleViewController.m
//  MembershipCard
//
//  Created by  on 16/3/24.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "ArticleViewController.h"

@interface ArticleViewController ()<UIWebViewDelegate>

@end

@implementation ArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.articleTitle;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonClick)];
    self.navigationItem.rightBarButtonItem = item;
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    webView.delegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];

}
- (void)shareButtonClick {

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


@end
