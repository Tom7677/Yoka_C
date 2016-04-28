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
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _cat_id = [aDecoder decodeObjectForKey:@"cat_id"];
        _cat_name = [aDecoder decodeObjectForKey:@"cat_name"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_cat_id forKey:@"cat_id"];
    [aCoder encodeObject:_cat_name forKey:@"cat_name"];
}
@end

@implementation ArticleModel
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _article_id = [aDecoder decodeObjectForKey:@"article_id"];
        _title = [aDecoder decodeObjectForKey:@"title"];
        _image = [aDecoder decodeObjectForKey:@"image"];
        _create_date = [aDecoder decodeObjectForKey:@"create_date"];
        _preview = [aDecoder decodeObjectForKey:@"preview"];
        _content = [aDecoder decodeObjectForKey:@"content"];
        _read_num = [aDecoder decodeObjectForKey:@"read_num"];
        _like_num = [aDecoder decodeObjectForKey:@"like_num"];
        _share_num = [aDecoder decodeObjectForKey:@"share_num"];
        _jump_link = [aDecoder decodeObjectForKey:@"jump_link"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_article_id forKey:@"article_id"];
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_image forKey:@"image"];
    [aCoder encodeObject:_create_date forKey:@"create_date"];
    [aCoder encodeObject:_preview forKey:@"preview"];
    [aCoder encodeObject:_content forKey:@"content"];
    [aCoder encodeObject:_read_num forKey:@"read_num"];
    [aCoder encodeObject:_like_num forKey:@"like_num"];
    [aCoder encodeObject:_share_num forKey:@"share_num"];
    [aCoder encodeObject:_jump_link forKey:@"jump_link"];
}
@end

@implementation UserInfoModel
@end

@implementation VoucherListModel
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _voucher_id = [aDecoder decodeObjectForKey:@"voucher_id"];
        _title = [aDecoder decodeObjectForKey:@"title"];
        _type = [aDecoder decodeObjectForKey:@"type"];
        _name = [aDecoder decodeObjectForKey:@"name"];
        _location = [aDecoder decodeObjectForKey:@"location"];
        _price = [aDecoder decodeObjectForKey:@"price"];
        _create_date = [aDecoder decodeObjectForKey:@"create_date"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_voucher_id forKey:@"voucher_id"];
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_type forKey:@"type"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_location forKey:@"location"];
    [aCoder encodeObject:_price forKey:@"price"];
    [aCoder encodeObject:_create_date forKey:@"create_date"];
}
@end

@implementation VoucherDetailModel
@end