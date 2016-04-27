//
//  YKModel.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/28.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "YKModel.h"

@implementation CityListModel
@end

@implementation MyCardModel
@end

@implementation CardInfoModel
@end

@implementation CardListModel
@end

@implementation UsedDetailModel
@end

@implementation NoticeModel
@end

@implementation AnnouncementModel
@end

@implementation BrandCardListModel
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _merchant_id = [aDecoder decodeObjectForKey:@"merchant_id"];
        _name = [aDecoder decodeObjectForKey:@"name"];
        _f_logo = [aDecoder decodeObjectForKey:@"f_logo"];
        _y_logo = [aDecoder decodeObjectForKey:@"y_logo"];
        _name_index = [aDecoder decodeObjectForKey:@"name_index"];
        _has_card = [[aDecoder decodeObjectForKey:@"has_card"] boolValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_merchant_id forKey:@"merchant_id"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_f_logo forKey:@"f_logo"];
    [aCoder encodeObject:_y_logo forKey:@"y_logo"];
    [aCoder encodeObject:_name_index forKey:@"name_index"];
    [aCoder encodeObject:[NSNumber numberWithBool:_has_card]  forKey:@"has_card"];
}
@end

@implementation ArticleTypeModel
@end

@implementation ArticleModel
@end

@implementation UserInfoModel
@end

@implementation VoucherListModel
@end

@implementation VoucherDetailModel
@end