//
//  MartViewController.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/28.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "MartViewController.h"
#import "CacheUserInfo.h"
#import "YZSDK.h"
#import "YZUserModel.h"
#import "MartWebViewController.h"

static NSString *homePageUrl = @"https://shop16479842.koudaitong.com/v2/showcase/homepage?kdt_id=16287674";
@interface MartViewController ()<UIWebViewDelegate>

@end

@implementation MartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"马夹商城";
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    [[NetworkAPI shared]getMJShopURLWithFinish:^(BOOL isSuccess, NSString *urlStr) {
        if (isSuccess) {
            [self loadRequestFromString:urlStr];
        }
        else {
            [self loadRequestFromString:homePageUrl];
        }
    } withErrorBlock:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadRequestFromString:(NSString*)urlString
{
    CacheUserInfo *cacheModel = [CacheUserInfo sharedManage];
    if(!cacheModel.isValid) {//无效的话 可以调用sdk的同步方法去同步信息，不会在webview中有多次交互的现象
        YZUserModel *userModel = [CacheUserInfo getYZUserModelFromCacheUserModel:cacheModel];
        //注意:只要调用接口，一定要记得appID和appSecret的值的设置
        [YZSDK registerYZUser:userModel callBack:^(NSString *message, BOOL isError) {
            if(isError) {
                cacheModel.isValid = NO;
            } else {
                cacheModel.isValid = YES;
                NSURL *url = [NSURL URLWithString:urlString];
                NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
                [self.webView loadRequest:urlRequest];
            }
        }];
    } else {
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:urlRequest];
    }
}

#pragma mark - webview delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [_webView stringByEvaluatingJavaScriptFromString:[[YZSDK sharedInstance] jsBridgeWhenWebDidLoad]];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

/**
 *  页面监听请看这里
 *
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = [request URL];
    if([[url absoluteString] isEqualToString:homePageUrl]) {//第一个页面加载
        
    }
    else if(![[url absoluteString] hasPrefix:@"http"]){//非http
        NSString *jsBridageString = [[YZSDK sharedInstance] parseYOUZANScheme:url];
        if(jsBridageString) {
            if([jsBridageString isEqualToString:CHECK_LOGIN]) {
                //首页面不涉及到登录
            }
            else if([jsBridageString isEqualToString:WX_PAY]) {
                //首页面不涉及到微信支付
            }
        }
    }
    else if ([[url absoluteString] hasSuffix:@"common/prefetching"]) {
        //加载静态资源 暂时先屏蔽
        return YES;
    }
    else {
        MartWebViewController *vc = [[MartWebViewController alloc]init];
        vc.commonWebViewUrl = [url absoluteString];
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    return YES;
}
@end
