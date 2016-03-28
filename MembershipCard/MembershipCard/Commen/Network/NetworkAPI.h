//
//  NetworkAPI.h
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/29.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKModel.h"

static NSString* hostUrl = @"http://www.51mumaren.com:8080/index.php/Client/";
static NSInteger pageSize = 20;
@interface NetworkAPI : NSObject
+ (NetworkAPI *)shared;

/*!
 *  @brief  用户获取验证码
 *
 *  @param mobile     手机号
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)getMobileCodeByMobile:(NSString *)mobile WithFinish:(void(^)(BOOL isSuccess ,NSString *msg))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

/**
 *  用户登录注册
 *
 *  @param mobile     手机号
 *  @param code       验证码
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)userLoginByMobile:(NSString *)mobile AndCode:(NSString *)code WithFinish:(void(^)(BOOL isSuccess ,NSString *msg))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

/**
 *  获取城市列表
 *
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)getCityListWithFinish:(void(^)(BOOL isSuccess ,NSArray *cityArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

/**
 *  获取卡包列表
 *
 *  @param memId      会员ID
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)getMyCardBagListWithFinish:(void(^)(NSArray *imageUrlArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

/**
 *  获取某个会员卡简介
 *
 *  @param merchantId 商户ID
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)getMyCardInfoByMerchantId:(NSString *)merchantId WithFinish:(void(^)(CardInfoModel *model))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

/*!
 *  @brief  删除卡片
 *
 *  @param cardId     卡片ID
 *  @param block      <#block description#>
 *  @param errorBlock <#errorBlock description#>
 */
- (void)deleteCardByCardId:(NSString *)cardId WithFinish:(void(^)(BOOL isSuccess , NSString *msg))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

/**
 *  获取某张会员卡的子卡信息
 *
 *  @param memId      会员ID
 *  @param merchantId 商户ID
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)getMyCardInfoListByMemId:(NSString *)memId merchantId:(NSString *)merchantId WithFinish:(void(^)(NSArray *dataArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

/*!
 *  @brief  获取品牌列表
 *
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)getMerchantListWithFinish:(void(^)(NSArray *dataArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

/**
 *  查询平台通知
 *
 *  @param memberId   会员Id
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)getNoticeListByMemberId:(NSString *)memberId WithFinish:(void(^)(NSArray *dataArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

/*!
 *  @brief  获取商户公告
 *
 *  @param memberId   会员ID
 *  @param merchantId 商户ID
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)getMerchantAnnouncementByMerchantId:(NSString *)merchantId WithFinish:(void(^)(NSArray *dataArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock;
/*!
 *  @brief  会员删除商户公告
 *
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)deleteAnnouncementWithFinish:(void(^)(BOOL isSuccess))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

/*!
 *  @brief  会员添加非品牌卡片
 *
 *  @param name       商户名
 *  @param cardNum    卡号
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)addNewNonBrandCardByMerchantName:(NSString *)name cardNum:(NSString *)cardNum WithFinish:(void(^)(BOOL isSuccess, NSString *msg))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

/*!
 *  @brief  会员添加品牌卡片
 *
 *  @param merchantId 商户ID
 *  @param cardNum    卡号
 *  @param type       条码类型
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)addNewBrandCardByMerchantID:(NSString *)merchantId cardNum:(NSString *)cardNum cardType:(NSString *)type WithFinish:(void(^)(BOOL isSuccess, NSString *msg))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

/**
 *  删除／恢复卡
 *
 *  @param merchantId 商户ID
 *  @param isDelete   YES删除，NO恢复
 */
- (void)updateCardRelationByMerchantId:(NSString *)merchantId WithDeleteAction:(BOOL)isDelete WithFinish:(void(^)(BOOL isSuccess))block withErrorBlock:(void(^)(NSError *error))errorBlock;

/*!
 *  @brief  查询文章分类列表
 *
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)getArticleTypeWithFinish:(void(^)(NSArray *dataArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

/*!
 *  @brief  发现文章列表
 *
 *  @param catId      分类ID
 *  @param city       城市
 *  @param page       第几页
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)getArticleListByCatId:(NSString *)catId cityName:(NSString *)city page:(NSInteger)page WithFinish:(void(^)(NSArray *dataArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock;
/*!
 *  @brief  获取用户信息
 *
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)getUserInfoWithFinish:(void(^)(UserInfoModel *model))block withErrorBlock:(void(^)(NSError *error)) errorBlock;


@end
