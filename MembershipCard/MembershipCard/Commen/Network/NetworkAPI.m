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

- (void)getMyCardBagListByMemId:(NSString *)memId WithFinish:(void(^)(NSArray *dataArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock
{
    NSDictionary *param = [self creatRequestParamByMethod:@"get_mycardpkg_list" WithParamData:@{@"member_id":memId}];
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

- (void)getMyCardInfoByMemId:(NSString *)memId merchantId:(NSString *)merchantId WithFinish:(void(^)(CardInfoModel *model))block withErrorBlock:(void(^)(NSError *error)) errorBlock
{

    NSDictionary *param = [self creatRequestParamByMethod:@"get_card_info" WithParamData:@{@"member_id":memId,@"merchant_id":merchantId}];
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

- (void)getMyCardInfoListByMemId:(NSString *)memId merchantId:(NSString *)merchantId WithFinish:(void(^)(NSArray *dataArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock
{
    NSDictionary *param = [self creatRequestParamByMethod:@"get_card_list" WithParamData:@{@"member_id":memId,@"merchant_id":merchantId}];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:hostUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            NSMutableArray *tempArr = [NSMutableArray array];
            for (NSDictionary *dic in responseObject[@"data"]) {
                CardListModel *model = [[CardListModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [tempArr addObject:model];
            }
            block ([tempArr copy]);
        }
        else {
            block (nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
    }];
}

- (void)getCardUsedDetailByCardId:(NSString *)cardId WithFinish:(void(^)(NSArray *dataArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock {
    NSDictionary *param = [self creatRequestParamByMethod:@"get_used_detail" WithParamData:@{@"card_id":cardId}];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:hostUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            NSMutableArray *tempArr = [NSMutableArray array];
            for (NSDictionary *dic in responseObject[@"data"]) {
                UsedDetailModel *model = [[UsedDetailModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [tempArr addObject:model];
            }
            block([tempArr copy]);
        }else {
            block(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
    }];
}


- (void)saveCardUsedDetailByModel:(UsedDetailModel *)model WithFinish:(void(^)(UsedDetailModel *model))block withErrorBlock:(void(^)(NSError *error)) errorBlock {
    NSDictionary *param = [self creatRequestParamByMethod:@"save_used_detail" WithParamData:@{@"card_id":model.card_id, @"title":model.title, @"num":model.number, @"type":model.count_type}];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:hostUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            UsedDetailModel *model = [[UsedDetailModel alloc]init];
            [model setValuesForKeysWithDictionary:responseObject[@"data"]];
            block(model);
        }else {
            block(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
    }];
}


- (void)getNoticeListByMemberId:(NSString *)memberId WithFinish:(void(^)(NSArray *dataArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock {
    NSDictionary *param = [self creatRequestParamByMethod:@"get_notice_list" WithParamData:@{@"member_id":memberId}];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:hostUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            NSMutableArray *tempArr = [NSMutableArray array];
            for (NSDictionary *dic in responseObject[@"data"]) {
                NoticeModel *model = [[NoticeModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [tempArr addObject:model];
            }
            block([tempArr copy]);
        }else {
            block(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
    }];
}

- (void)saveMerchantAnnouncementByModel:(AnnouncementModel *)model WithFinish:(void(^)(AnnouncementModel *model))block withErrorBlock:(void(^)(NSError *error)) errorBlock {
    NSDictionary *param = [self creatRequestParamByMethod:@"save_merchant_announcement" WithParamData:@{@"merchant_id":model.merchant_id, @"title":model.title, @"content":model.content}];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:hostUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            AnnouncementModel *model = [[AnnouncementModel alloc]init];
            [model setValuesForKeysWithDictionary:responseObject[@"data"]];
            block(model);
        }else {
            block(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
    }];
}



/**
 *  生成请求参数
 *
 *  @param methodName 接口名称
 *  @param ParamData  参数设置
 *
 *  @return 请求参数param
 */
- (NSDictionary *)creatRequestParamByMethod:(NSString *)methodName WithParamData:(NSDictionary *)ParamData 
 {
    NSMutableDictionary *tempParam = [[NSMutableDictionary alloc]init];
    [tempParam setObject:[NSString stringWithFormat:@"appapi_response.%@", methodName] forKey:@"method"];
    [tempParam setObject:ParamData forKey:@"data"];
    return @{@"info":[self dictionaryToJson:tempParam]};
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
