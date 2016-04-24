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
#import "WXApi.h"
#import "WXApiObject.h"
#import "YZSDK.h"
#import "CacheUserInfo.h"
#import "UIImage+Resize.h"

@interface ArticleViewController ()<UIWebViewDelegate,UIAlertViewDelegate>


@property (strong, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UIButton *shareToWXBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareToCircelBtn;
@end

@implementation ArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_shareToWXBtn circularBoarderBead:_shareToWXBtn.frame.size.width/2 withBoarder:1 color:[UIColor lightGrayColor]];
    [_shareToCircelBtn circularBoarderBead:_shareToCircelBtn.frame.size.width/2 withBoarder:1 color:[UIColor lightGrayColor]];

    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        TSImageLeftButton *btn = [[TSImageLeftButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        if (i == 0) {
            [btn setTitle:@"分享" forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"web_share"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
        }else if (i == 2) {
            [btn setTitle:@"点赞" forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"web_like"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"web_like_selected"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(likeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }else {
            UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFixedSpace target:nil action:nil];
            fixedItem.width = 20;
            [tempArray addObject:fixedItem];
            continue;
        }
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
        [tempArray addObject:item];
    }
    self.navigationItem.rightBarButtonItems = [tempArray copy];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - NavAndStatusBarHeight)];
    [self.view addSubview:webView];
    webView.delegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    _shareView.frame = CGRectMake(0, MainScreenHeight - 150 - NavAndStatusBarHeight, MainScreenWidth, 150);
    [self.view addSubview:_shareView];
    _shareView.hidden = YES;
}
- (void)shareButtonClick {
    _shareView.hidden = NO;
}

- (void)likeButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [[NetworkAPI shared]updateArticleDataByType:like AndArticleId:_articleId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareToWXAction:(id)sender {
    _shareView.hidden = YES;
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = _articleTitle;
    message.description = _articleContent;
    if (_coverImage == nil) {
        [message setThumbImage:[UIImage imageNamed:@"icon_logo"]];
    }
    else {
        NSData *data = UIImageJPEGRepresentation(_coverImage, 1);
        [message setThumbImage:[UIImage thumbnailImageMaxPixelSize:100 forImageData:data]];
    }
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = _urlStr;
    message.mediaObject = webpageObject;
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    [WXApi sendReq:req];
}

- (IBAction)shareToCirelAction:(id)sender {
    _shareView.hidden = YES;
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = _articleTitle;
    message.description = _articleContent;
    if (_coverImage == nil) {
        [message setThumbImage:[UIImage imageNamed:@"icon_logo"]];
    }
    else {
        [message setThumbImage:_coverImage];
    }
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = _urlStr;
    message.mediaObject = webpageObject;
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    [WXApi sendReq:req];
}

#pragma mark - UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [webView stringByEvaluatingJavaScriptFromString:[[YZSDK sharedInstance] jsBridgeWhenWebDidLoad]];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = [request URL];
    NSString *jsBridageString = [[YZSDK sharedInstance] parseYOUZANScheme:url];
    if(jsBridageString) {
        CacheUserInfo *cacheModel = [CacheUserInfo sharedManage];
        if([jsBridageString isEqualToString:CHECK_LOGIN] && !cacheModel.isValid) {
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
