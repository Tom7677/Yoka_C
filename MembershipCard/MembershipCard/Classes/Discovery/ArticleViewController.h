//
//  ArticleViewController.h
//  MembershipCard
//
//  Created by  on 16/3/31.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ArticleViewController : BaseViewController
@property(nonatomic,strong) NSString *urlStr;
@property(nonatomic,strong) NSString *articleId;
@property(nonatomic,strong) NSString *articleTitle;
@property(nonatomic,strong) NSString *articleContent;

- (IBAction)shareToWXAction:(id)sender;
- (IBAction)shareToCirelAction:(id)sender;

@end
