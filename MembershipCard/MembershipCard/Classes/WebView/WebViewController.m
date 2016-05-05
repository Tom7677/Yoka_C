//
//  WebViewController.m
//  MembershipCard
//
//  Created by tom.sun on 16/3/29.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "WebViewController.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "YZSDK.h"
#import "CacheUserInfo.h"

@interface WebViewController ()<UIWebViewDelegate>
@property (nonatomic, copy) NSString *urlStr;
@property (strong, nonatomic) IBOutlet UIView *shareView;
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
    _shareView.hidden = YES;
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - NavAndStatusBarHeight)];
    [self.view insertSubview:_webView belowSubview:_shareView];
    _webView.delegate = self;
    //webVeiw禁止左右滑动
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.scrollView.bounces = YES;
    _webView.scalesPageToFit = YES;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]]];
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
    _shareView.hidden = !_shareView.hidden;
}

- (IBAction)shareToWXAction:(id)sender {
    _shareView.hidden = YES;
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"来自马夹的分享";
    message.description = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];

    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = _urlStr;
    message.mediaObject = webpageObject;
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    [WXApi sendReq:req];
}

- (IBAction)shartToCircleAction:(id)sender {
    _shareView.hidden = YES;
    WXMediaMessage *message = [WXMediaMessage message];
    message.title =  @"来自马夹的分享";
    message.description = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = _urlStr;
    message.mediaObject = webpageObject;
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    [WXApi sendReq:req];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - webview delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self showHub];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self hideHub];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self hideHub];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = [request URL];
    NSString *jsBridageString = [[YZSDK sharedInstance] parseYOUZANScheme:url];
    if(jsBridageString) {
        CacheUserInfo *cacheModel = [CacheUserInfo sharedManage];
        if([jsBridageString isEqualToString:CHECK_LOGIN] && cacheModel.isValid) {
            if(cacheModel.isLogined) {
                YZUserModel *userModel = [CacheUserInfo getYZUserModelFromCacheUserModel:cacheModel];
                NSString *string = [[YZSDK sharedInstance] webUserInfoLogin:userModel];
                [webView stringByEvaluatingJavaScriptFromString:string];
                return YES;
            }
        }
    }
    return YES;
}
@end
