//
//  ;
//  MembershipCard
//
//  Created by tom.sun on 16/3/10.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UMengAnalyticsUtil : NSObject
+ (id)shared;
- (void)loginByMobile;
- (void)loginByWX;
- (void)addNewCard;
- (void)seeNotice;
- (void)clearNotice;
- (void)qrCard;
- (void)manuallyInputCard;
- (void)addElectronicCard;
- (void)listChooseCard;
- (void)saveCardByMerchantsName:(NSString *)name type:(NSString *)type;
- (void)deleteCardByMerchantsName:(NSString *)name;
- (void)seeCardInfo;
- (void)factBtn;
- (void)merchants;
- (void)setting;
- (void)cardBrokerageCity;
- (void)secondHandCardVoucher;
- (void)chooseCityByCityName:(NSString *)city;
- (void)shareApp;
- (void)loginOut;
@end
