//
//  NetworkAPI.h
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/29.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CardInfoModel;
@class UsedDetailModel;
@class AnnouncementModel;


static NSString* hostUrl = @"http://api-ecstore.yw.bycache.com:81/index.php/appapi/";
@interface NetworkAPI : NSObject
+ (NetworkAPI *)shared;
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
 *  @param memId      会员ID
 *  @param merchantId 商户ID
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)getMyCardInfoByMerchantId:(NSString *)merchantId WithFinish:(void(^)(CardInfoModel *model))block withErrorBlock:(void(^)(NSError *error)) errorBlock;
/**
 *  获取某张会员卡的子卡信息
 *
 *  @param memId      会员ID
 *  @param merchantId 商户ID
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)getMyCardInfoListByMemId:(NSString *)memId merchantId:(NSString *)merchantId WithFinish:(void(^)(NSArray *dataArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock;
/**
 *  查询子卡消费明细
 *
 *  @param cardId     子卡ID
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)getCardUsedDetailByCardId:(NSString *)cardId WithFinish:(void(^)(NSArray *dataArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock;
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
/**
 *  添加商户公告
 *
 *  @param model      商户公告模型数据
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)saveMerchantAnnouncementByModel:(AnnouncementModel *)model WithFinish:(void(^)(AnnouncementModel *model))block withErrorBlock:(void(^)(NSError *error)) errorBlock;
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
 *  @brief  会员添加新卡
 *
 *  @param name       商户名
 *  @param cardNum    卡号
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)addNewCardByMerchantName:(NSString *)name cardNum:(NSString *)cardNum WithFinish:(void(^)(BOOL isSuccess))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

/**
 *  删除／恢复卡
 *
 *  @param merchantId 商户ID
 *  @param isDelete   YES删除，NO恢复
 */
- (void)updateCardRelationByMerchantId:(NSString *)merchantId WithDeleteAction:(BOOL)isDelete WithFinish:(void(^)(BOOL isSuccess))block withErrorBlock:(void(^)(NSError *error))errorBlock;

/*!
 *  @brief  查询文章/卡券分类列表
 *
 *  @param type       类型（1：文章，2：卡券）
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)getTypeListByType:(NSString *)type WithFinish:(void(^)(NSArray *dataArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

/** 发现文章 */
- (void)getArticleListWithFinish:(void(^)(NSArray *dataArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

@end
