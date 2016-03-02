//
//  NetworkAPI.h
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/29.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString* hostUrl = @"http://api-ecstore.yw.bycache.com:81/index.php/appapi/";
@interface NetworkAPI : NSObject
+ (NetworkAPI *)shared;
- (void)getMyCardBagListByMemId:(NSString *)memId WithFinish:(void(^)(NSArray *imageUrlArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock;
@end
