//
//  ModelCache.h
//  MembershipCard
//
//  Created by 孙鹏 on 16/4/27.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelCache : NSObject
+ (ModelCache *)shared;
- (void)saveValue:(id)value forKey:(NSString *)key;
- (BOOL)containsObjectForKey:(NSString *)key;
- (id)readValueByKey:(NSString *)key;
@end
