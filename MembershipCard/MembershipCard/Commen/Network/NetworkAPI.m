//
//  NetworkAPI.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/29.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "NetworkAPI.h"
#import "YKModel.h"
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

/**
 *  获取卡包列表
 *
 *  @param memId      会员ID
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)getMyCardBagListByMemId:(NSString *)memId WithFinish:(void(^)(NSArray *dataArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock
{
    NSMutableDictionary *tempParam = [[NSMutableDictionary alloc]init];
    [tempParam setObject:@"appapi_response.get_mycardpkg_list" forKey:@"method"];
    NSDictionary *dic = @{@"member_id":memId};
    [tempParam setObject:dic forKey:@"data"];
    NSDictionary *param = @{@"info":[self dictionaryToJson:tempParam]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:hostUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            NSMutableArray *dataArray = [[NSMutableArray alloc]init];
//            for (NSDictionary *dic in responseObject[@"data"]) {
//                MyCardModel *model = [[MyCardModel alloc]init];
//                model.name = dic[@"name"];
//                model.merchant_id = dic[@"merchant_id"];
//                [dataArray addObject:model];
//            }
            block (dataArray);
        }
        else {
            block (nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
    }];
}

/**
 *  获取我的卡包列表中卡简介
 *
 *  @param memId      会员ID
 *  @param merchantId 商户ID
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)getMyCardInfoByMemId:(NSString *)memId merchantId:(NSString *)merchantId WithFinish:(void(^)(CardInfoModel *model))block withErrorBlock:(void(^)(NSError *error)) errorBlock
{
    NSMutableDictionary *tempParam = [[NSMutableDictionary alloc]init];
    [tempParam setObject:@"appapi_response.get_card_info" forKey:@"method"];
    NSDictionary *dic = @{@"member_id":memId,@"merchant_id":merchantId};
    [tempParam setObject:dic forKey:@"data"];
    NSDictionary *param = @{@"info":[self dictionaryToJson:tempParam]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:hostUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            NSDictionary *dic = responseObject[@"data"];
            CardInfoModel *model = [[CardInfoModel alloc]init];
            model.merchant_id = dic[@"merchant_id"];
            model.name = dic[@"name"];
            model.merchant_bn = dic[@"merchant_bn"];
            model.area = dic[@"area"];
            model.addr = dic[@"addr"];
            model.tel = dic[@"tel"];
            model.business_hous = dic[@"business_hous"];
            model.addon = dic[@"addon"];
            model.remark = dic[@"remark"];
            model.card_bn = dic[@"card_bn"];
            block (model);
        }
        else {
            block (nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
    }];
}

- (void)getMyCardInfoListByMemId:(NSString *)memId merchantId:(NSString *)merchantId WithFinish:(void(^)(CardInfoModel *model))block withErrorBlock:(void(^)(NSError *error)) errorBlock
{
    NSMutableDictionary *tempParam = [[NSMutableDictionary alloc]init];
    [tempParam setObject:@"appapi_response.get_card_list" forKey:@"method"];
    NSDictionary *dic = @{@"member_id":memId,@"merchant_id":merchantId};
    [tempParam setObject:dic forKey:@"data"];
    NSDictionary *param = @{@"info":[self dictionaryToJson:tempParam]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:hostUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            NSDictionary *dic = responseObject[@"data"];
            CardInfoModel *model = [[CardInfoModel alloc]init];
            model.merchant_id = dic[@"merchant_id"];
            model.name = dic[@"name"];
            model.merchant_bn = dic[@"merchant_bn"];
            model.area = dic[@"area"];
            model.addr = dic[@"addr"];
            model.tel = dic[@"tel"];
            model.business_hous = dic[@"business_hous"];
            model.addon = dic[@"addon"];
            model.remark = dic[@"remark"];
            model.card_bn = dic[@"card_bn"];
            block (model);
        }
        else {
            block (nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
    }];
}

/**
 *  dic转json
 *
 *  @param dic dic description
 *
 *  @return return value description
 */
- (NSString *)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end
