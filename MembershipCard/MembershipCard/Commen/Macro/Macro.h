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

//相关链接地址
#define ABOUTUS @"http://114.215.174.185:8080/wordpress/%e5%85%ac%e5%8f%b8%e7%ae%80%e4%bb%8b/"
#define TEMSOFUSE @"http://114.215.174.185:8080/wordpress/%e6%b3%95%e5%be%8b%e5%a3%b0%e6%98%8e/"

//定义存储key
#define ARTICLE_TYPE @"articleType"
#define VOUCHER_TYPE @"voucherType"
#define BRANDLIST @"brandList"
#define CARDLIST @"cardList"


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define MainScreenWidth [[UIScreen mainScreen] bounds].size.width
#define MainScreenHeight [[UIScreen mainScreen] bounds].size.height

#define NavAndStatusBarHeight 64
#define StatusBarHeight 20
#define NavgationBarHeight 44
#define TabbarHeight 49
#endif /* Macro_h */
