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
- (void)getMyCardBagListByMemId:(NSString *)memId WithFinish:(void(^)(NSArray *imageUrlArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

/**
 *  获取某个会员卡简介
 *
 *  @param memId      会员ID
 *  @param merchantId 商户ID
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)getMyCardInfoByMemId:(NSString *)memId merchantId:(NSString *)merchantId WithFinish:(void(^)(CardInfoModel *model))block withErrorBlock:(void(^)(NSError *error)) errorBlock;
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
/**
 *  添加消费记录
 *
 *  @param model      消费记录模型
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)saveCardUsedDetailByModel:(UsedDetailModel *)model WithFinish:(void(^)(UsedDetailModel *model))block withErrorBlock:(void(^)(NSError *error)) errorBlock;
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

@end
