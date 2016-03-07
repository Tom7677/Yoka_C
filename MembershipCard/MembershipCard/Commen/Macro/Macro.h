//
//  Macro.h
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/21.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define MainScreenWidth [[UIScreen mainScreen] bounds].size.width
#define MainScreenHeight [[UIScreen mainScreen] bounds].size.height

#define NavAndStatusBarHeight 64
#define StatusBarHeight 20
#define NavgationBarHeight 44
#define TabbarHeight 49
#endif /* Macro_h */
