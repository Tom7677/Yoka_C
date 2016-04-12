//
//  NetworkAPI.h
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/29.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKModel.h"
#import "MJExtension.h"

static NSString* hostUrl = @"http://www.51mumaren.com:8080/index.php/Client/";
static NSString* imageUrl = @"http://www.51mumaren.com:8080";
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

/*!
 *  @brief 第三方微信登录
 *
 *  @param code       微信code
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)wechatLoginByWXCode:(NSString *)code WithFinish:(void(^)(BOOL isSuccess ,NSString *msg))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

/*!
 *  @brief  绑定手机
 
 *  @param mobile     手机号
 *  @param code       验证码
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)bindMobileByMobile:(NSString *)mobile AndCode:(NSString *)code WithFinish:(void(^)(BOOL isSuccess ,NSString *msg))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

/**
 *  获取城市列表
 *
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)getCityListWithFinish:(void(^)(BOOL isSuccess ,NSArray *cityArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

/*!
 *  @brief  获取爆料链接
 */
- (void)getFeedbackURLWithFinish:(void(^)(BOOL isSuccess, NSString *urlStr))block withErrorBlock:(void(^)(NSError *error))errorBlock;

/*!
 *  @brief  获取马夹商城链接
 */
- (void)getMJShopURLWithFinish:(void(^)(BOOL isSuccess, NSString *urlStr))block withErrorBlock:(void(^)(NSError *error))errorBlock;

#pragma mark 卡包
/**
 *  获取卡包列表
 *
 *  @param memId      会员ID
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)getMyCardBagListWithFinish:(void(^)(NSArray *imageUrlArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

/*!
 *  @brief  获取某个会员卡简介
 *
 *  @param cardId     卡片ID
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)getMyCardInfoByCardId:(NSString *)cardId WithFinish:(void(^)(CardInfoModel *model))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

/*!
 *  @brief  删除卡片
 *
 *  @param cardId     卡片ID
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)deleteCardByCardId:(NSString *)cardId WithFinish:(void(^)(BOOL isSuccess , NSString *msg))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

/*!
 *  @brief  获取非合作品牌列表
 *
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)getMerchantListWithFinish:(void(^)(NSArray *dataArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

/**
 *  查询平台通知
 *
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)getNoticeListWithFinish:(void(^)(NSArray *dataArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

/**
 *  删除消息
 *
 *  @param messageId  消息ID
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)deleteNoticeWithMessageId:(NSString *)messageId WithFinish:(void(^)(NSString *msg, BOOL isSuccess))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

/*!
 *  @brief  清空消息
 *
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)clearNoticeWithFinish:(void(^)(NSString *msg, BOOL isSuccess))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

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
- (void)addNewBrandCardByMerchantID:(NSString *)merchantId cardNum:(NSString *)cardNum WithFinish:(void(^)(BOOL isSuccess, NSString *msg))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

/*!
 *  @brief  获取云所合作商户列表
 *
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)getCooperatedMerchantListWithFinish:(void(^)(NSArray *dataArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

#pragma mark 发现
///*!
// *  @brief  爆料链接
// *
// *  @param block      block description
// *  @param errorBlock errorBlock description
// */
//- (void)getTopNewsWithFinish:(void(^)(BOOL isSuccess, NSString *url))block withErrorBlock:(void(^)(NSError *error))errorBlock;

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
 *  @brief  发现推荐文章列表
 *
 *  @param city       城市
 *  @param page       第几页
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)getTopArticleListByCity:(NSString *)city page:(NSInteger)page WithFinish:(void(^)(NSArray *dataArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

typedef enum {
    like, // 喜欢
    share, // 分享
    hasread // 阅读
} ArticleDataType;

/*!
 *  @brief  更新文章数据
 *
 *  @param dataType   文章数据类别
 *  @param articleId  文章id
 */
- (void)updateArticleDataByType:(ArticleDataType)dataType AndArticleId:(NSString *)articleId;

#pragma mark 用户
/*!
 *  @brief  获取用户信息
 *
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)getUserInfoWithFinish:(void(^)(UserInfoModel *model))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

/*!
 *  @brief  保存用户信息
 *
 *  @param nickName   昵称
 *  @param avatar     头像
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)saveUserInfoByNickName:(NSString *)nickName avatar:(NSData *)avatar WithFinish:(void(^)(BOOL isSuccess ,NSString *msg))block withErrorBlock:(void(^)(NSError *error)) errorBlock;


#pragma mark 二手卡券
/*!
 *  @brief  获取二手卡券分类
 *
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)getVoucherTypeWithFinish:(void(^)(NSArray *dataArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

/*!
 *  @brief  获取二手卡券列表
 *
 *  @param catId      分类ID
 *  @param page       第几页
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)getVoucherListByCatId:(NSString *)catId page:(NSInteger)page WithFinish:(void(^)(NSArray *dataArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

/*!
 *  @brief  获取已发布卡券列表
 *
 *  @param page       第几页
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)getVoucherReleasedListByPage:(NSInteger)page WithFinish:(void(^)(NSArray *dataArray))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

/*!
 *  @brief  获取卡券信息
 *
 *  @param voucherId  卡券id
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)getVoucherInfoByVoucherId:(NSString *)voucherId WithFinish:(void(^)(VoucherDetailModel *model))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

/*!
 *  @brief  发布卡券
 *
 *  @param dic        卡券信息
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)addVoucherWithInfo:(NSDictionary *)dic WithFinish:(void(^)(BOOL isSuccess, NSString *msg))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

/**
 *  修改卡券
 *
 *  @param dic        卡券信息
 *  @param voucher_id 卡券ID
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)editVoucherWithInfo:(NSDictionary *)dic voucher_id:(NSString *)voucher_id  WithFinish:(void(^)(BOOL isSuccess, NSString *msg))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

/*!
 *  @brief  删除卡券
 *
 *  @param voucherId  卡券id
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)deleteVoucherWithVoucherId:(NSString *)voucherId WithFinish:(void(^)(BOOL isSuccess, NSString *msg))block withErrorBlock:(void(^)(NSError *error)) errorBlock;
@end
