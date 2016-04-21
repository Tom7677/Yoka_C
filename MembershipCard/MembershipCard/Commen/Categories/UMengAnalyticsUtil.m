//
//  UMengAnalyticsUtil.m
//  MembershipCard
//
//  Created by tom.sun on 16/3/10.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "UMengAnalyticsUtil.h"
#import <MobClick.h>

@implementation UMengAnalyticsUtil
+ (id)shared
{
    static UMengAnalyticsUtil *instance;
    if (instance == nil) {
        instance = [[UMengAnalyticsUtil alloc]init];
    }
    return instance;
}

/*!
 *  @brief  手机登陆
 */
- (void)loginByMobile
{
    [MobClick event:@"LoginByMobile"];
}

/*!
 *  @brief  微信登录
 */
- (void)loginByWX
{
    [MobClick event:@"LoginByWX"];
}

/*!
 *  @brief  添加新卡
 */
- (void)addNewCard
{
    [MobClick event:@"AddNewCard"];
}

/*!
 *  @brief  查看通知
 */
- (void)seeNotice
{
    [MobClick event:@"SeeNotice"];
}

/*!
 *  @brief  清空通知
 */
- (void)clearNotice
{
    [MobClick event:@"ClearNotice"];
}

/*!
 *  @brief  扫码识别卡片
 */
- (void)qrCard
{
    [MobClick event:@"QRCard"];
}

/*!
 *  @brief  手工输入卡片
 */
- (void)manuallyInputCard
{
    [MobClick event:@"ManuallyInputCard"];
}

/*!
 *  @brief  添加无卡好会员卡片
 */
- (void)addElectronicCard
{
    [MobClick event:@"AddElectronicCard"];
}
/*!
 *  @brief  列表选择卡片
 */
- (void)listChooseCard
{
    [MobClick event:@"ListChooseCard"];
}

/*!
 *  @brief  保存新卡片
 *
 *  @param name 商家名称
 *  @param type 添加方式（扫码，手动输入，列表选择）
 */
- (void)saveCardByMerchantsName:(NSString *)name type:(NSString *)type
{
     NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:name, @"商家名称",type, @"添加方式", nil];
    [MobClick event:@"SaveNewCard" attributes:dic];
}

/*!
 *  @brief  删除卡片
 *
 *  @param name 商家名称
 */
- (void)deleteCardByMerchantsName:(NSString *)name
{
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:name, @"商家名称", nil];
    [MobClick event:@"SaveNewCard" attributes:dic];
}

/*!
 *  @brief  点击账户详情按钮
 */
- (void)seeCardInfo
{
    [MobClick event:@"CardInfo"];
}

/*!
 *  @brief  点击发现页面左上角按钮（爆料）
 */
- (void)factBtn
{
    [MobClick event:@"Fact"];
}

/*!
 *  @brief  点击发现页面右上角按钮（商户）
 */
- (void)merchants
{
    [MobClick event:@"Merchants"];
}

/*!
 *  @brief  点击更多页面右上角按钮（设置）
 */
- (void)setting
{
    [MobClick event:@"Setting"];
}

/*!
 *  @brief  卡券商城
 */
- (void)cardBrokerageCity
{
    [MobClick event:@"CardBrokerageCity"];
}

/*!
 *  @brief  二手卡券
 */
- (void)secondHandCardVoucher
{
    [MobClick event:@"Second-handCardVoucher"];
}

/*!
 *  @brief  选择城市
 *
 *  @param city 所选择的城市
 */
- (void)chooseCityByCityName:(NSString *)city
{
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:city, @"所选择的城市", nil];
    [MobClick event:@"ChooseCity" attributes:dic];
}

/*!
 *  @brief  分享APP
 */
- (void)shareApp
{
    [MobClick event:@"ShareApp"];
}

/*!
 *  @brief  退出登录
 */
- (void)loginOut
{
    [MobClick event:@"LoginOut"];
}

@end
