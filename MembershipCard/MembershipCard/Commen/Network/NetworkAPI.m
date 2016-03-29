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

#pragma mark Login
- (void)getMobileCodeByMobile:(NSString *)mobile WithFinish:(void(^)(BOOL isSuccess ,NSString *msg))block withErrorBlock:(void(^)(NSError *error)) errorBlock
{
    NSString *urlStr = [hostUrl stringByAppendingString:@"User/get_mobile_code"];
    NSDictionary *param = @{@"mobile":mobile};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"data"][@"token"] forKey:@"accessToken"];
            block(YES,responseObject[@"msg"]);
        }else {
            block(NO,responseObject[@"msg"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
    }];
}

- (void)userLoginByMobile:(NSString *)mobile AndCode:(NSString *)code WithFinish:(void(^)(BOOL isSuccess ,NSString *msg))block withErrorBlock:(void(^)(NSError *error)) errorBlock {
    NSString *urlStr = [hostUrl stringByAppendingString:@"User/login"];
    NSDictionary *param = @{@"mobile":mobile, @"code":code};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"data"][@"token"] forKey:@"accessToken"];
            block(YES,responseObject[@"msg"]);
        }else {
            block(NO,responseObject[@"msg"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
        NSLog(@"%@",error.userInfo);
    }];
}

- (void)getCityListWithFinish:(void(^)(BOOL isSuccess ,NSArray *cityArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlStr = [hostUrl stringByAppendingString:@"Index/get_city"];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            NSMutableArray *dataArray = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in responseObject[@"data"]) {
                CityListModel *model = [[CityListModel alloc]init];
                model = [CityListModel mj_objectWithKeyValues:dic];
                [dataArray addObject:model];
            }
            block(YES,dataArray);
        }else {
            block(NO,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
    }];
}

#pragma mark cardBag
- (void)getMyCardBagListWithFinish:(void(^)(NSArray *dataArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock
{
    NSString *urlStr = [hostUrl stringByAppendingString:@"User/get_card_list"];
    NSDictionary *param = @{@"token":[self getAccessToken]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            NSMutableArray *dataArray = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in responseObject[@"data"]) {
                MyCardModel *model = [[MyCardModel alloc]init];
                model = [MyCardModel mj_objectWithKeyValues:dic];
                [dataArray addObject:model];
            }
            block (dataArray);
        }
        else {
            block (nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
    }];
}

- (void)getMyCardInfoByMerchantId:(NSString *)merchantId WithFinish:(void(^)(CardInfoModel *model))block withErrorBlock:(void(^)(NSError *error)) errorBlock
{
    NSString *urlStr = [hostUrl stringByAppendingString:@"Card/get_card_info"];
    NSDictionary *param = @{@"token":[self getAccessToken]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            NSDictionary *dic = [self jsonObjectWithJsonString:responseObject[@"data"]];
            CardInfoModel *model = [[CardInfoModel alloc]init];
            model = [CardInfoModel mj_objectWithKeyValues:dic];
            block (model);
        }
        else {
            block (nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
    }];
}

- (void)deleteCardByCardId:(NSString *)cardId WithFinish:(void(^)(BOOL isSuccess , NSString *msg))block withErrorBlock:(void(^)(NSError *error)) errorBlock
{
    NSString *urlStr = [hostUrl stringByAppendingString:@"Card/delete_card"];
    NSDictionary *param = @{@"token":[self getAccessToken],@"card_id":cardId};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            block(YES, responseObject[@"msg"]);
        }
        else {
            block(NO, responseObject[@"msg"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock (error);
    }];
}

- (void)getMerchantListWithFinish:(void(^)(NSArray *dataArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock
{
    NSString *urlStr = [hostUrl stringByAppendingString:@"Merchant/get_list"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            NSMutableArray *dataArray = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in responseObject[@"data"]) {
                BrandCardListModel *model = [[BrandCardListModel alloc]init];
                model = [BrandCardListModel mj_objectWithKeyValues:dic];
                [dataArray addObject:model];
            }
            block (dataArray);
        }
        else {
            block (nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock (error);
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
                model = [CardListModel mj_objectWithKeyValues:dic];
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
                model = [UsedDetailModel mj_objectWithKeyValues:dic];
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
            model = [UsedDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
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
                model = [NoticeModel mj_objectWithKeyValues:dic];
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

- (void)getMerchantAnnouncementByMerchantId:(NSString *)merchantId WithFinish:(void(^)(NSArray *dataArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock
{
    NSDictionary *param = [self creatRequestParamByMethod:@"get_announcement_list" WithParamData:@{@"merchant_id":merchantId, @"member_id":[self getMemId]}];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:hostUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            NSMutableArray *dataArray = [[NSMutableArray alloc]init];
            NSArray *resultArray = [self jsonObjectWithJsonString:responseObject[@"data"]];
            for (NSDictionary *dic in resultArray) {
                AnnouncementModel *model = [[AnnouncementModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [dataArray addObject:model];
            }
            block (dataArray);
        }else {
            block(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
    }];
}

- (void)deleteAnnouncementWithFinish:(void(^)(BOOL isSuccess))block withErrorBlock:(void(^)(NSError *error)) errorBlock;
{
    NSDictionary *param = [self creatRequestParamByMethod:@"get_announcement_list" WithParamData:@{@"id":[self getMemId]}];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:hostUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            block (YES);
        }else {
            block(NO);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
    }];
}

- (void)addNewNonBrandCardByMerchantName:(NSString *)name cardNum:(NSString *)cardNum WithFinish:(void(^)(BOOL isSuccess, NSString *msg))block withErrorBlock:(void(^)(NSError *error)) errorBlock
{
    NSString *urlStr = [hostUrl stringByAppendingString:@"User/add_card_nonbrand"];
    NSDictionary *param = @{@"merchant_name":name,@"card_no":cardNum,@"token":[self getAccessToken]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
   [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            block(YES, responseObject[@"msg"]);
        }else {
            block(NO, responseObject[@"msg"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
    }];
}

- (void)addNewBrandCardByMerchantID:(NSString *)merchantId cardNum:(NSString *)cardNum cardType:(NSString *)type WithFinish:(void(^)(BOOL isSuccess, NSString *msg))block withErrorBlock:(void(^)(NSError *error)) errorBlock {
    NSString *urlStr = [hostUrl stringByAppendingString:@"User/add_card_brand"];
    NSDictionary  *param = @{@"merchant_id":merchantId,@"card_no":cardNum,@"token":[self getAccessToken],@"type":type};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            block(YES, responseObject[@"msg"]);
        }else {
            block(NO, responseObject[@"msg"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
    }];
}

- (void)updateCardRelationByMerchantId:(NSString *)merchantId WithDeleteAction:(BOOL)isDelete WithFinish:(void(^)(BOOL isSuccess))block withErrorBlock:(void(^)(NSError *error))errorBlock{
    NSDictionary *param = [self creatRequestParamByMethod:@"update_card_relation" WithParamData:@{@"member_id":[self getMemId],@"merchant_id":merchantId,@"action":(isDelete ? @"0" : @"1" )}];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:hostUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            block(YES);
        }else {
            block(NO);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
    }];
}

#pragma mark Discovery
- (void)getArticleTypeWithFinish:(void(^)(NSArray *dataArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock
{
    NSString *urlStr = [hostUrl stringByAppendingString:@"Article/get_cat_list"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            NSMutableArray *resultArray = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in responseObject[@"data"]) {
                ArticleTypeModel *model = [[ArticleTypeModel alloc]init];
                model = [ArticleTypeModel mj_objectWithKeyValues:dic];
                [resultArray addObject:model];
            }
            block (resultArray);
        }
        else {
            block (nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
    }];
}

- (void)getArticleListByCatId:(NSString *)catId cityName:(NSString *)city page:(NSInteger)page WithFinish:(void(^)(NSArray *dataArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock {
    NSString *urlStr = [hostUrl stringByAppendingString:@"Article/get_article_list"];
    NSDictionary *param = @{@"cat_id":catId,@"city":city,@"page":[NSNumber numberWithInteger:page],@"limit":[NSNumber numberWithInteger:pageSize]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            NSMutableArray *dataArray = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in responseObject[@"data"]) {
                ArticleModel *model = [[ArticleModel alloc]init];
                model = [ArticleModel mj_objectWithKeyValues:dic];
                [dataArray addObject:model];
            }
            block([dataArray copy]);
        }else{
            block(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
    }];
}

#pragma mark More
- (void)getUserInfoWithFinish:(void(^)(UserInfoModel *model))block withErrorBlock:(void(^)(NSError *error)) errorBlock
{
    NSString *urlStr = [hostUrl stringByAppendingString:@"User/get_user_info"];
    NSDictionary *param = @{@"token":[self getAccessToken]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            UserInfoModel *model = [UserInfoModel mj_objectWithKeyValues:responseObject[@"data"]];
            block (model);
        }
        else {
            block (nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
    }];
}

- (void)saveUserInfoByNickName:(NSString *)nickName avatar:(NSData *)avatar WithFinish:(void(^)(BOOL isSuccess ,NSString *msg))block withErrorBlock:(void(^)(NSError *error)) errorBlock
{
    NSString *urlStr = [hostUrl stringByAppendingString:@"User/set_user_info"];
    NSDictionary *param;
    if ([nickName isEqualToString:@""]) {
        param = @{@"token":[self getAccessToken]};
    }
    else {
        param = @{@"token":[self getAccessToken],@"nick_name":nickName};
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (avatar != nil) {
            NSString *fileName = @"user_avatar.jpg";
            [formData appendPartWithFileData:avatar name:@"avatar" fileName:fileName mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(YES,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
    }];
}

#pragma Action
/*!
 *  @brief  获取memberId
 *
 *  @return return value description
 */
- (NSString *)getMemId
{
    return @"2";
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

/*!
 *  @brief  json转obj
 *
 *  @param jsonString json
 *
 *  @return return value description
 */
- (id)jsonObjectWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id jsonObject = [NSJSONSerialization
                     JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments
                     error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return jsonObject;
}

/**
 *  获取Token
 *
 *  @return token
 */
- (NSString *)getAccessToken
{
    return  [[NSUserDefaults standardUserDefaults]objectForKey:@"accessToken"];
}
@end
