//
//  MartWebViewController.h
//  MembershipCard
//
//  Created by 孙鹏 on 16/3/23.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "BaseViewController.h"

@interface MartWebViewController : BaseViewController
@property (copy, nonatomic) NSString *commonWebViewUrl;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *shareView;

- (IBAction)wxAction:(id)sender;
@end
