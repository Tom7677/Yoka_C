//
//  ModelCache.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/4/27.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "ModelCache.h"
#import <YYDiskCache.h>

@implementation ModelCache
+ (ModelCache *)shared
{
    static ModelCache *sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedClient = [[self alloc]init];
    });
    return sharedClient;
}

- (NSString *)getDocPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

- (void)saveValue:(id)value forKey:(NSString *)key
{
    YYDiskCache *cache = [[YYDiskCache alloc]initWithPath:[self getDocPath]];
    [cache removeObjectForKey:key];
    [cache setObject:value forKey:key];
}

- (BOOL)containsObjectForKey:(NSString *)key
{
    YYDiskCache *cache = [[YYDiskCache alloc]initWithPath:[self getDocPath]];
    if ([cache containsObjectForKey:key]) {
        return YES;
    }
    return NO;
}

- (id)readValueByKey:(NSString *)key
{
    YYDiskCache *cache = [[YYDiskCache alloc]initWithPath:[self getDocPath]];
    return [cache objectForKey:key];
}
@end
