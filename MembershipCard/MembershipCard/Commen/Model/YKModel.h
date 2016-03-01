//
//  YKModel.h
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/28.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCardBagModel : NSObject
@property (copy, nonatomic) NSString *logoUrl;
@property (copy, nonatomic) NSString *cardName;
@property (copy, nonatomic) NSString *cardType;
@property (copy, nonatomic) NSString *cardId;
@end

@interface CardModel : NSObject
@property (copy, nonatomic) NSString *logoUrl;
@property (copy, nonatomic) NSString *cardName;
@property (copy, nonatomic) NSString *cardId;
@end