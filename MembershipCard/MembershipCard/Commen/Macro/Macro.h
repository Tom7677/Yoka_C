//
//  Macro.h
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/21.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

/**************有赞***************/
//返回参数函数处理
static NSString *CHECK_LOGIN = @"check_login";
static NSString *SHARE_DATA = @"share_data";
static NSString *WEB_READY = @"web_ready";
static NSString *WX_PAY = @"wx_pay";

//分享相关参数
static NSString *SHARE_TITLE = @"title";
static NSString *SHARE_LINK = @"link";
static NSString *SHARE_IMAGE_URL = @"img_url";
static NSString *SHARE_DESC = @"desc";

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define MainScreenWidth [[UIScreen mainScreen] bounds].size.width
#define MainScreenHeight [[UIScreen mainScreen] bounds].size.height

#define NavAndStatusBarHeight 64
#define StatusBarHeight 20
#define NavgationBarHeight 44
#define TabbarHeight 49
#endif /* Macro_h */
