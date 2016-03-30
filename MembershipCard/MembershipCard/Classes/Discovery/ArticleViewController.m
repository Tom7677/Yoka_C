//
//  ArticleViewController.m
//  MembershipCard
//
//  Created by  on 16/3/24.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "ArticleViewController.h"
#import "TSImageLeftButton.h"

@interface ArticleViewController ()<UIWebViewDelegate>

@end

@implementation ArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        if (i == 1) {
            UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            fixedSpace.width = 20;
            [tempArray addObject:fixedSpace];
        }else {
            TSImageLeftButton *btn = [[TSImageLeftButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            if (i == 0) {
                [btn setTitle:@"分享" forState:UIControlStateNormal];
//图片暂缺                [btn setImage:@"" forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
            }else {
                [btn setTitle:@"点赞" forState:UIControlStateNormal];
//图片暂缺                  [btn setImage:@"" forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(likeButtonClick) forControlEvents:UIControlEventTouchUpInside];
            }
            UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
            [tempArray addObject:item];
        }
     }
    self.navigationItem.rightBarButtonItems = [tempArray copy];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    webView.delegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
}
- (void)shareButtonClick {

    
}

- (void)likeButtonClick {
    
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
