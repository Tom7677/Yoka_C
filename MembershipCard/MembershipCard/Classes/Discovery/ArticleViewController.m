//
//  ArticleViewController.m
//  MembershipCard
//
//  Created by  on 16/3/31.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "ArticleViewController.h"
#import "TSImageLeftButton.h"
#import "NetworkAPI.h"
#import "UIView+border.h"

@interface ArticleViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UIButton *shareToWXBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareToCircelBtn;
@end

@implementation ArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_shareToWXBtn circularBoarderBead:_shareToWXBtn.frame.size.width/2 withBoarder:1 color:[UIColor lightGrayColor]];
    [_shareToCircelBtn circularBoarderBead:_shareToCircelBtn.frame.size.width/2 withBoarder:1 color:[UIColor lightGrayColor]];

    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < 2; i++) {
        TSImageLeftButton *btn = [[TSImageLeftButton alloc]initWithFrame:CGRectMake(0, 0, 56, 30)];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        if (i == 0) {
            [btn setTitle:@"分享" forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
        }else {
            [btn setTitle:@"点赞" forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"like_selected"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(likeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
        [tempArray addObject:item];
    }
    self.navigationItem.rightBarButtonItems = [tempArray copy];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    webView.delegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    
}
- (void)shareButtonClick {

}

- (void)likeButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [[NetworkAPI shared]updateArticleDataByType:like AndArticleId:_articleId];
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
