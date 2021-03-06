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

//测试环境 http://www.51mumaren.com:8080
//正式环境 http://114.215.174.185:8080/kabao
static NSString* hostUrl = @"http://114.215.174.185:8080/kabao/index.php/Client/";
static NSString* imageUrl = @"http://114.215.174.185:8080/kabao";
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

/*!
 *  @brief  获取推荐APP链接
 */
- (void)getAPPRecommendURLWithFinish:(void(^)(BOOL isSuccess, NSString *urlStr))block withErrorBlock:(void(^)(NSError *error))errorBlock;


/**
 *  启动页广告图
 *
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)getAdURLWithFinish:(void(^)(BOOL isSuccess, NSString *urlStr, NSString  *linkStr))block withErrorBlock:(void(^)(NSError *error))errorBlock;

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

/**
 *  编辑卡片
 *
 *  @param cardId     卡片id
 *  @param remark     备注
 *  @param f_image    正面照
 *  @param b_image    背面照
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)saveCardInfoByCardId:(NSString *)cardId remark:(NSString *)remark f_image:(NSData *)f_image b_image:(NSData *)b_image WithFinish:(void(^)(BOOL isSuccess , NSString *msg))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

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
- (void)addNewNonBrandCardByMerchantName:(NSString *)name cardNum:(NSString *)cardNum type:(NSString *)type WithFinish:(void(^)(BOOL isSuccess, NSString *msg))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

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

/**
 *  用户添加猜你有卡
 *
 *  @param merchantId 商户ID
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)addCardYunsuoWithMerchantId:(NSString *)merchantId WithFinish:(void(^)(BOOL isSuccess, NSString *msg))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

/*!
 *  @brief  非品牌卡片绑定品牌
 *
 *  @param cardId     卡片ID
 *  @param merchantId 品牌ID
 *  @param block      block description
 *  @param errorBlock errorBlock description
 */
- (void)bindBrandCardWithCardId:(NSString *)cardId AndMerchantId:(NSString *)merchantId WithFinish:(void(^)(BOOL isSuccess, NSString *msg))block withErrorBlock:(void(^)(NSError *error)) errorBlock;

/**
 *  获取快速登录云所商户C端查询卡值链接地址
 *
 *  @param merchantId 品牌ID
 *
 *  @return 链接地址
 */
- (NSString *)getQuickLoginYSAccountLinkUrlWithMerchantId:(NSString *)merchantId;

/**
 *  获取快速登录查看公告
 *
 *  @param merchantId 品牌ID
 *
 *  @return 链接地址
 */
- (NSString *)getQuickLoginYSNoticeLinkUrlWithMerchantId:(NSString *)merchantId;

#pragma mark 发现

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
