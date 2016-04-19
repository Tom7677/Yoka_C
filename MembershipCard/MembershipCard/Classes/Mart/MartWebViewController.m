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
#import "TSImageLeftButton.h"
#import "UIView+frame.h"
#import "WXApi.h"
#import "WXApiObject.h"

@interface MartWebViewController ()<UIWebViewDelegate>
@property (nonatomic, copy) NSString *martTitle;
@property (nonatomic, copy) NSString *martUrl;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) TSImageLeftButton *shareBtn;
@end

@implementation MartWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView.delegate = self;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - NavAndStatusBarHeight);
    _shareView.hidden = YES;
    _shareBtn = [[TSImageLeftButton alloc]initWithFrame:CGRectMake(0, 0, 56, 30)];
    [_shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _shareBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [_shareBtn setImage:[UIImage imageNamed:@"web_share"] forState:UIControlStateNormal];
    [_shareBtn addTarget:self action:@selector(webShareAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_shareBtn];
    [self loadRequestFromString:_commonWebViewUrl];
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
- (void)webShareAction {
    NSString *jsonString = [[YZSDK sharedInstance] jsBridgeWhenShareBtnClick];
    [_webView stringByEvaluatingJavaScriptFromString:jsonString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - webview delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.navigationItem.title = @"载入中...";
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
            if([jsBridageString isEqualToString:CHECK_LOGIN] && cacheModel.isValid) {
                if(cacheModel.isLogined) {
                    //【如果是您是先登录，在打开我们商城，走这种方式】
                    YZUserModel *userModel = [CacheUserInfo getYZUserModelFromCacheUserModel:cacheModel];
                    NSString *string = [[YZSDK sharedInstance] webUserInfoLogin:userModel];
                    [_webView stringByEvaluatingJavaScriptFromString:string];
                    return YES;
                }
            } else if([jsBridageString isEqualToString:SHARE_DATA]) {
                //【分享请看这里】
                _shareView.hidden = NO;
                NSDictionary * shareDic = [[YZSDK sharedInstance] shareDataInfo:url];
                _martUrl = shareDic[SHARE_LINK];
                _martTitle = shareDic[SHARE_TITLE];
                _desc = shareDic[SHARE_DESC];
                _image = [self getImageFromURL:shareDic[SHARE_IMAGE_URL]];
            } else if([jsBridageString isEqualToString:WEB_READY]) {
                self.navigationItem.rightBarButtonItem.enabled = YES;
                _shareBtn.hidden = NO;
                
            } else if ([[url absoluteString] hasSuffix:@"common/prefetching"]) {
                //加载静态资源 暂时先屏蔽
                return YES;
                
            }  else if([jsBridageString isEqualToString:WX_PAY]) {
                //【微信支付暂时用的有赞wap微信支付，我们给您的链接已经包含了微信支付所有信息，直接可以唤起您手机上的微信，进行支付，分享之后因为不是走微信注册的模式，所以无法直接返回您的App，详细可以看文档说明】
                //如果是微信自有支付或者app支付，现在基本没有商户在使用app支付了，因此这里默认是微信自有支付
                [YZSDK selfWXPayURL:url callback:^(NSDictionary *response, NSError *error) {
                     PayReq* req  = [[PayReq alloc] init];
                     req.openID   = response[@"response"][@"appid"];
                     req.partnerId  = response[@"response"][@"partnerid"];
                     req.prepayId  = response[@"response"][@"prepayid"];
                     req.nonceStr  = response[@"response"][@"noncestr"];
                     req.timeStamp   = (unsigned int)[response[@"response"][@"timestamp"] longValue];
                     req.package  = response[@"response"][@"package"];
                     req.sign   = response[@"response"][@"sign"];
                     [WXApi sendReq:req];
                }];
            }
        }
    } else {
        //进入新的链接后，记得隐藏分享按钮，等到下个页面完全打开(获取webready后显示)
        _shareBtn.hidden = YES;
    }
    return YES;
}

- (IBAction)wxAction:(id)sender {
    _shareView.hidden = YES;
    UIButton *btn = sender;
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = _martTitle;
    message.description = _desc;
    if (_image != nil) {
        [message setThumbImage:_image];
    }
    else {
        [message setThumbImage:[UIImage imageNamed:@"icon_logo"]];
    }
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = _martUrl;
    message.mediaObject = webpageObject;
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.bText = NO;
    req.message = message;
    if (btn.tag == 0) {
        req.scene = WXSceneSession;
    }
    if (btn.tag == 1) {
        req.scene = WXSceneTimeline;
    }
    [WXApi sendReq:req];
}

- (UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage *result;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}
@end
