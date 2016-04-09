//
//  BaseViewController.h
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/21.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
#import "NetworkAPI.h"
#import "YKModel.h"
#import "UMengAnalyticsUtil.h"

@interface BaseViewController : UIViewController
- (BOOL)isEmpty:(NSString *)str;
- (void)showAlertViewController:(NSString *)msg;
- (BOOL)checkTelNumber:(NSString *) telNumber;
@end
