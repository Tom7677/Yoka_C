//
//  MartWebViewController.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/3/23.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "MartWebViewController.h"
#import "YZSDK.h"
#import "CacheUserInfo.h"

@interface MartWebViewController ()<UIWebViewDelegate>

@end

@implementation MartWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView.delegate = self;
}

- (void)loadRequestFromString:(NSString*)urlString {
    CacheUserInfo *cacheModel = [CacheUserInfo sharedManage];
    if(!cacheModel.isValid) {
        YZUserModel *userModel = [CacheUserInfo getYZUserModelFromCacheUserModel:cacheModel];
        [YZSDK registerYZUser:userModel callBack:^(NSString *message, BOOL isError) {
            if(isError) {
                cacheModel.isValid = NO;
            } else {
                cacheModel.isValid = YES;
                NSURL *url = [NSURL URLWithString:urlString];
                NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
                [_webView loadRequest:urlRequest];
            }
        }];
    } else {
        cacheModel.isValid = YES;
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:urlRequest];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - webview delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.navigationItem.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [_webView stringByEvaluatingJavaScriptFromString:[[YZSDK sharedInstance] jsBridgeWhenWebDidLoad]];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = [request URL];
    
    if(![[url absoluteString] hasPrefix:@"http"]){//非http
        NSString *jsBridageString = [[YZSDK sharedInstance] parseYOUZANScheme:url];
        if(jsBridageString) {
            CacheUserInfo *cacheModel = [CacheUserInfo sharedManage];
            if([jsBridageString isEqualToString:CHECK_LOGIN] && !cacheModel.isValid) {
                if(cacheModel.isLogined) {//【如果是您是先登录，在打开我们商城，走这种方式】
                    YZUserModel *userModel = [CacheUserInfo getYZUserModelFromCacheUserModel:cacheModel];
                    NSString *string = [[YZSDK sharedInstance] webUserInfoLogin:userModel];
                    [_webView stringByEvaluatingJavaScriptFromString:string];
                    return YES;
                }
            } else if([jsBridageString isEqualToString:SHARE_DATA]) {//【分享请看这里】
                
                NSDictionary * shareDic = [[YZSDK sharedInstance] shareDataInfo:url];
                NSString *message = [NSString stringWithFormat:@"title:%@ \\n 链接: %@ " , shareDic[SHARE_TITLE],shareDic[SHARE_LINK]];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"数据已经获取到了,赶紧来分享吧" message:message delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
                [alertView show];
                
            } else if([jsBridageString isEqualToString:WEB_READY]) {
                
                self.navigationItem.rightBarButtonItem.enabled = YES;
                //_shareButton.hidden = NO;
                
            } else if ([[url absoluteString] hasSuffix:@"common/prefetching"]) {//加载静态资源 暂时先屏蔽
                
                return YES;
                
            }  else if([jsBridageString isEqualToString:WX_PAY]) { //【微信支付暂时用的有赞wap微信支付，我们给您的链接已经包含了微信支付所有信息，直接可以唤起您手机上的微信，进行支付，分享之后因为不是走微信注册的模式，所以无法直接返回您的App，详细可以看文档说明】
                
                //如果是微信自有支付或者app支付，现在基本没有商户在使用app支付了，因此这里默认是微信自有支付
                
                [YZSDK selfWXPayURL:url callback:^(NSDictionary *response, NSError *error) {
                    
                    //返回的是一个包含微信支付的字典，取出微信支付相对应的参数
                    /*
                     PayReq* req  = [[PayReq alloc] init];
                     req.openID   = response[@"response"][@"appid"];
                     req.partnerId  = response[@"response"][@"partnerid"];
                     req.prepayId  = response[@"response"][@"prepayid"];
                     req.nonceStr  = response[@"response"][@"noncestr"];
                     req.timeStamp   = (unsigned int)[response[@"response"][@"timestamp"] longValue];
                     req.package  = response[@"response"][@"package"];
                     req.sign   = response[@"response"][@"sign"];
                     [WXApi sendReq:req]; */
                }];
            }
        }
    } else {
        //_shareButton.hidden = YES;//进入新的链接后，记得隐藏分享按钮，等到下个页面完全打开(获取webready后显示)
    }
    return YES;
}
@end
