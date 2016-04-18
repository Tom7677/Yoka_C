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
#import "UIImage+Resize.h"
#import "CacheUserInfo.h"
#import "YZSDK.h"
#import "YZUserModel.h"

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
            CacheUserInfo *cacheModel = [CacheUserInfo sharedManage];
            cacheModel.bid = responseObject[@"data"][@"token"];
            cacheModel.gender = @"1";
            cacheModel.name = responseObject[@"data"][@"nick_name"];
            cacheModel.telephone = responseObject[@"data"][@"mobile"];
            cacheModel.avatar = responseObject[@"data"][@"avatar"];
            if(!cacheModel.isValid) {
                YZUserModel *userModel = [CacheUserInfo getYZUserModelFromCacheUserModel:cacheModel];
                [YZSDK registerYZUser:userModel callBack:^(NSString *message, BOOL isError) {
                    if(isError) {
                        cacheModel.isValid = NO;
                    }
                    else {
                        cacheModel.isValid = YES;
                    }
                }];
            } else {
                cacheModel.isValid = YES;
            }
            block(YES,responseObject[@"msg"]);
        }else {
            block(NO,responseObject[@"msg"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
        NSLog(@"%@",error.userInfo);
    }];
}

- (void)wechatLoginByWXCode:(NSString *)code WithFinish:(void(^)(BOOL isSuccess, NSString *msg))block withErrorBlock:(void(^)(NSError *error)) errorBlock {
    NSString *urlStr = [hostUrl stringByAppendingString:@"User/wx_login"];
    NSDictionary *param = @{@"code":code};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"data"]
             [@"token"] forKey:@"accessToken"];
            if (![responseObject[@"data"][@"mobile"] isEqualToString:@""]) {
                [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"data"][@"mobile"] forKey:@"phoneNum"];
                CacheUserInfo *cacheModel = [CacheUserInfo sharedManage];
                cacheModel.bid = responseObject[@"data"][@"token"];
                cacheModel.gender = @"1";
                cacheModel.name = responseObject[@"data"][@"nick_name"];
                cacheModel.telephone = responseObject[@"data"][@"mobile"];
                cacheModel.avatar = responseObject[@"data"][@"avatar"];
                cacheModel.isValid = NO;
                cacheModel.isLogined = YES;
                if(!cacheModel.isValid) {
                    YZUserModel *userModel = [CacheUserInfo getYZUserModelFromCacheUserModel:cacheModel];
                    [YZSDK registerYZUser:userModel callBack:^(NSString *message, BOOL isError) {
                        if(isError) {
                            cacheModel.isValid = NO;
                        }
                        else {
                            cacheModel.isValid = YES;
                        }
                    }];
                } else {
                    cacheModel.isValid = YES;
                }
            }
            block(YES, responseObject[@"msg"]);
        }else {
            block(NO, responseObject[@"msg"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
    }];
}

- (void)bindMobileByMobile:(NSString *)mobile AndCode:(NSString *)code WithFinish:(void(^)(BOOL isSuccess ,NSString *msg))block withErrorBlock:(void(^)(NSError *error)) errorBlock {
    NSString *urlStr = [hostUrl stringByAppendingString:@"User/bind_mobile"];
    NSDictionary *param = @{@"token":[self getAccessToken], @"code":code, @"mobile":mobile};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"data"]
             [@"token"] forKey:@"accessToken"];
            CacheUserInfo *cacheModel = [CacheUserInfo sharedManage];
            cacheModel.bid = responseObject[@"data"][@"token"];
            cacheModel.gender = @"1";
            cacheModel.name = responseObject[@"data"][@"nick_name"];
            cacheModel.telephone = responseObject[@"data"][@"mobile"];
            cacheModel.avatar = responseObject[@"data"][@"avatar"];
            if(!cacheModel.isValid) {
                YZUserModel *userModel = [CacheUserInfo getYZUserModelFromCacheUserModel:cacheModel];
                [YZSDK registerYZUser:userModel callBack:^(NSString *message, BOOL isError) {
                    if(isError) {
                        cacheModel.isValid = NO;
                    }
                    else {
                        cacheModel.isValid = YES;
                    }
                }];
            } else {
                cacheModel.isValid = YES;
            }
            block(YES, responseObject[@"msg"]);
        }else {
            block(NO, responseObject[@"msg"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
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

- (void)getFeedbackURLWithFinish:(void(^)(BOOL isSuccess, NSString *urlStr))block withErrorBlock:(void(^)(NSError *error))errorBlock{
    NSString *urlStr = [hostUrl stringByAppendingString:@"Index/feedback"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            block(YES, responseObject[@"data"]);
        }else {
            block(NO,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
    }];
}

- (void)getMJShopURLWithFinish:(void(^)(BOOL isSuccess, NSString *urlStr))block withErrorBlock:(void(^)(NSError *error))errorBlock {
    NSString *urlStr = [hostUrl stringByAppendingString:@"Index/emall"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            block(YES, responseObject[@"data"]);
        }else {
            block(NO,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
    }];
}

- (void)getAPPRecommendURLWithFinish:(void(^)(BOOL isSuccess, NSString *urlStr))block withErrorBlock:(void(^)(NSError *error))errorBlock
{
    NSString *urlStr = [hostUrl stringByAppendingString:@"Index/suggestion_app"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            block(YES, responseObject[@"data"]);
        }else {
            block(NO,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
    }];

}

- (void)getAdURLWithFinish:(void(^)(BOOL isSuccess, NSString *urlStr, NSString  *linkStr))block withErrorBlock:(void(^)(NSError *error))errorBlock {
    NSString *urlStr = [hostUrl stringByAppendingString:@"Index/start_page"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            block(YES, responseObject[@"data"][@"image"],responseObject[@"data"][@"link"]);
        }else {
            block(NO,nil,nil);
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

- (void)getMyCardInfoByCardId:(NSString *)cardId WithFinish:(void(^)(CardInfoModel *model))block withErrorBlock:(void(^)(NSError *error)) errorBlock
{
    NSString *urlStr = [hostUrl stringByAppendingString:@"Card/get_card_info"];
    NSDictionary *param = @{@"token":[self getAccessToken], @"card_id":cardId};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            NSDictionary *dic = responseObject[@"data"];
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
        if ([responseObject[@"status"] integerValue] == 1) {
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

- (void)saveCardInfoByCardId:(NSString *)cardId remark:(NSString *)remark f_image:(NSData *)f_image b_image:(NSData *)b_image WithFinish:(void(^)(BOOL isSuccess , NSString *msg))block withErrorBlock:(void(^)(NSError *error)) errorBlock {
    NSString *urlStr = [hostUrl stringByAppendingString:@"Card/set_card_info"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:cardId forKey:@"card_id"];
    [param setObject:[self getAccessToken] forKey:@"token"];
    if (remark!= nil) {
        [param setObject:remark forKey:@"remark"];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (f_image != nil) {
            NSString *fileName = [cardId stringByAppendingString:@"f.jpg"];
            [formData appendPartWithFileData:f_image name:@"f_image" fileName:fileName mimeType:@"image/jpeg"];
        }
        if (b_image != nil) {
            NSString *fileName = [cardId stringByAppendingString:@"b.jpg"];
            [formData appendPartWithFileData:b_image name:@"b_image" fileName:fileName mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            block (YES, responseObject[@"msg"]);
        }
        else {
            block (NO, responseObject[@"msg"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)getNoticeListWithFinish:(void(^)(NSArray *dataArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock {
    NSString *urlStr = [hostUrl stringByAppendingString:@"User/get_message"];
    NSDictionary *param = @{@"token":[self getAccessToken]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
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

- (void)deleteNoticeWithMessageId:(NSString *)messageId WithFinish:(void(^)(NSString *msg, BOOL isSuccess))block withErrorBlock:(void(^)(NSError *error)) errorBlock
{
    NSString *urlStr = [hostUrl stringByAppendingString:@"User/delete_message"];
    NSDictionary *param = @{@"token":[self getAccessToken],@"message_id":messageId};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            block(responseObject[@"msg"],YES);
        }
        else {
            block(responseObject[@"msg"],NO);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
    }];
}

- (void)clearNoticeWithFinish:(void(^)(NSString *msg, BOOL isSuccess))block withErrorBlock:(void(^)(NSError *error)) errorBlock
{
    NSString *urlStr = [hostUrl stringByAppendingString:@"User/clear_message"];
    NSDictionary *param = @{@"token":[self getAccessToken]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            block(responseObject[@"msg"],YES);
        }
        else {
            block(responseObject[@"msg"],NO);
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

- (void)addNewBrandCardByMerchantID:(NSString *)merchantId cardNum:(NSString *)cardNum WithFinish:(void(^)(BOOL isSuccess, NSString *msg))block withErrorBlock:(void(^)(NSError *error)) errorBlock {
    NSString *urlStr = [hostUrl stringByAppendingString:@"User/add_card_brand"];
    NSDictionary  *param = @{@"merchant_id":merchantId,@"card_no":cardNum,@"token":[self getAccessToken]};
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

- (void)getCooperatedMerchantListWithFinish:(void(^)(NSArray *dataArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock {
    NSString *urlStr = [hostUrl stringByAppendingString:@"Merchant/get_brand_list"];
    NSDictionary *param = @{@"token":[self getAccessToken]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

- (void)addCardYunsuoWithMerchantId:(NSString *)merchantId WithFinish:(void(^)(BOOL isSuccess, NSString *msg))block withErrorBlock:(void(^)(NSError *error)) errorBlock
{
    NSString *urlStr = [hostUrl stringByAppendingString:@"User/add_card_yunsuo"];
    NSDictionary *param = @{@"token":[self getAccessToken],@"merchant_id":merchantId};
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

- (void)bindBrandCardWithCardId:(NSString *)cardId AndMerchantId:(NSString *)merchantId WithFinish:(void(^)(BOOL isSuccess, NSString *msg))block withErrorBlock:(void(^)(NSError *error)) errorBlock
{
    NSString *urlStr = [hostUrl stringByAppendingString:@"Card/bind_brand_card"];
    NSDictionary *param = @{@"token":[self getAccessToken],@"card_id":cardId,@"merchant_id":merchantId};
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
        if ([responseObject[@"status"] integerValue] == 1) {
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

- (void)getTopArticleListByCity:(NSString *)city page:(NSInteger)page WithFinish:(void(^)(NSArray *dataArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock {
    NSString *urlStr = [hostUrl stringByAppendingString:@"Article/get_top_list"];
    NSDictionary *param = @{@"city":city,@"page":[NSNumber numberWithInteger:page],@"limit":[NSNumber numberWithInteger:pageSize]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue]) {
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

- (void)updateArticleDataByType:(ArticleDataType)dataType AndArticleId:(NSString *)articleId {
    NSString *type;
    switch (dataType) {
        case 0:
            type = @"like";
            break;
        case 1:
            type = @"share";
            break;
        default:
            type = @"read";
            break;
    }
    NSString *urlStr = [hostUrl stringByAppendingString:@"Article/add_num"];
    NSDictionary *param = @{@"type":type, @"article_id":articleId};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
        if ([responseObject[@"status"] integerValue] == 1) {
            block(YES,responseObject[@"msg"]);
        }
        else {
            block(NO,responseObject[@"msg"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
    }];
}

- (void)getVoucherTypeWithFinish:(void(^)(NSArray *dataArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock
{
    NSString *urlStr = [hostUrl stringByAppendingString:@"Voucher/get_voucher_cat_list"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            block (responseObject[@"data"]);
        }
        else {
            block (nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
    }];
}

- (void)getVoucherListByCatId:(NSString *)catId page:(NSInteger)page WithFinish:(void(^)(NSArray *dataArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock
{
    NSString *urlStr = [hostUrl stringByAppendingString:@"Voucher/get_voucher_list"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    NSString *cityId = [[NSUserDefaults standardUserDefaults]objectForKey:@"cityId"];
    if (cityId != nil && ![cityId isEqualToString:@""]) {
        [param setObject:cityId forKey:@"city_id"];
    }
    if ([catId isEqualToString:@""]) {
        [param setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
        [param setObject:[NSNumber numberWithInteger:pageSize] forKey:@"limit"];
    }
    else {
        [param setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
        [param setObject:[NSNumber numberWithInteger:pageSize] forKey:@"limit"];
        [param setObject:catId forKey:@"cat_id"];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            NSMutableArray *dataArray = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in responseObject[@"data"]) {
                VoucherListModel *model = [[VoucherListModel alloc]init];
                model = [VoucherListModel mj_objectWithKeyValues:dic];
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

- (void)getVoucherReleasedListByPage:(NSInteger)page WithFinish:(void(^)(NSArray *dataArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock
{
    NSString *urlStr = [hostUrl stringByAppendingString:@"Voucher/get_voucher_released"];
    NSDictionary *param = @{@"token":[self getAccessToken],@"page":[NSNumber numberWithInteger:page],@"limit":[NSNumber numberWithInteger:pageSize]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            NSMutableArray *dataArray = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in responseObject[@"data"]) {
                VoucherListModel *model = [[VoucherListModel alloc]init];
                model = [VoucherListModel mj_objectWithKeyValues:dic];
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

- (void)getVoucherInfoByVoucherId:(NSString *)voucherId WithFinish:(void(^)(VoucherDetailModel *model))block withErrorBlock:(void(^)(NSError *error)) errorBlock
{
    NSString *urlStr = [hostUrl stringByAppendingString:@"Voucher/get_voucher_info"];
    NSDictionary *param = @{@"voucher_id":voucherId};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            VoucherDetailModel *model = [VoucherDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
            block(model);
        }else{
            block(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
    }];
}

- (void)addVoucherWithInfo:(NSDictionary *)dic WithFinish:(void(^)(BOOL isSuccess, NSString *msg))block withErrorBlock:(void(^)(NSError *error)) errorBlock
{
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < [dic[@"images"] count]; i ++) {
        UIImage *image = dic[@"images"][i];
        NSData *data = UIImageJPEGRepresentation([image imageWithMaxImagePix:500 compressionQuality:0.5], 1.0);
        [imageArray addObject:data];
    }
    NSString *urlStr = [hostUrl stringByAppendingString:@"Voucher/add_voucher"];
    NSDictionary *param = [NSDictionary dictionary];
    param = @{@"token":[self getAccessToken],@"title":dic[@"title"],@"price":dic[@"price"],@"type":dic[@"type"],@"content":dic[@"content"],@"cat_id":dic[@"cat_id"],@"contact":dic[@"contact"],@"mobile":dic[@"mobile"],@"location":dic[@"location"],@"city_id":dic[@"city_id"]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (imageArray.count > 0) {
            for (int i = 0; i < imageArray.count; i ++) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyyMMddHHmmssSSS";
                NSString *timeStr = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@.jpg", timeStr];
                [formData appendPartWithFileData:imageArray[i] name:[NSString stringWithFormat:@"images_%d",i+1] fileName:fileName mimeType:@"image/jpeg"];
            }
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            block(YES, responseObject[@"msg"]);
        }else{
            block(NO, responseObject[@"msg"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock (error);
    }];
}

- (void)editVoucherWithInfo:(NSDictionary *)dic voucher_id:(NSString *)voucher_id  WithFinish:(void(^)(BOOL isSuccess, NSString *msg))block withErrorBlock:(void(^)(NSError *error)) errorBlock
{
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < [dic[@"images"] count]; i ++) {
        UIImage *image = dic[@"images"][i];
        NSData *data = UIImageJPEGRepresentation([image imageWithMaxImagePix:500 compressionQuality:0.5], 1.0);
        [imageArray addObject:data];
    }
    NSString *urlStr = [hostUrl stringByAppendingString:@"Voucher/edit_voucher"];
    NSDictionary *param = [NSDictionary dictionary];
    param = @{@"token":[self getAccessToken],@"title":dic[@"title"],@"price":dic[@"price"],@"type":dic[@"type"],@"content":dic[@"content"],@"cat_id":dic[@"cat_id"],@"contact":dic[@"contact"],@"mobile":dic[@"mobile"],@"location":dic[@"location"],@"city_id":dic[@"city_id"],@"voucher_id":voucher_id};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (imageArray.count > 0) {
            for (int i = 0; i < imageArray.count; i ++) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyyMMddHHmmssSSS";
                NSString *timeStr = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@.jpg", timeStr];
                [formData appendPartWithFileData:imageArray[i] name:[NSString stringWithFormat:@"images_%d",i+1] fileName:fileName mimeType:@"image/jpeg"];
            }
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            block(YES, responseObject[@"msg"]);
        }else{
            block(NO, responseObject[@"msg"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock (error);
    }];
}

- (void)deleteVoucherWithVoucherId:(NSString *)voucherId WithFinish:(void(^)(BOOL isSuccess, NSString *msg))block withErrorBlock:(void(^)(NSError *error)) errorBlock
{
    NSString *urlStr = [hostUrl stringByAppendingString:@"Voucher/delete_voucher"];
    NSDictionary *param = @{@"token":[self getAccessToken],@"voucher_id":voucherId};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            block(YES, responseObject[@"msg"]);
        }
        else {
            block(NO, responseObject[@"msg"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock (error);
    }];
}

#pragma Action
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
