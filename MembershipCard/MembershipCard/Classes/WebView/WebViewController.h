//
//  WebViewController.h
//  MembershipCard
//
//  Created by tom.sun on 16/3/29.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "BaseViewController.h"

@interface WebViewController : BaseViewController
@property (nonatomic, strong) UIWebView *webView;
- (instancetype)initWithURLString:(NSString *)urlStr titleLabel:(NSString *)title;
- (instancetype)initWithWebNavigationAndURLString:(NSString *)urlStr;
- (void)setupWebNavigation;

@end
