//
//  NetworkAPI.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/29.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "NetworkAPI.h"
#import <AFHTTPRequestOperationManager.h>
@implementation NetworkAPI

+ (NetworkAPI *)shared
{
    static NetworkAPI *sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedClient = [[self alloc]init];
    });
    return sharedClient;
}

- (void)getMyCardBagListByMemId:(NSString *)memId WithFinish:(void(^)(NSArray *imageUrlArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock
{
    NSMutableDictionary *tempParam = [[NSMutableDictionary alloc]init];
    [tempParam setObject:@"appapi_response.get_mycardpkg_list" forKey:@"method"];
    NSDictionary *dic = @{@"member_id":memId};
    [tempParam setObject:dic forKey:@"data"];
    NSDictionary *param = @{@"info":tempParam};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:hostUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
@end
