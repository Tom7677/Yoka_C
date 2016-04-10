//
//  YKModel.h
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/28.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 城市列表模型 */
@interface CityListModel : NSObject
@property (nonatomic, copy) NSString *city_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *name_index;
@end

/** 我的会员卡模型 */
@interface MyCardModel : NSObject
@property(nonatomic,strong) NSString *card_id; //卡ID
@property(nonatomic,strong) NSString *name;//商户名称
@property(nonatomic,strong) NSString *f_logo;//方logo
@property(nonatomic,strong) NSString *y_logo;//圆logo
@end

/** 会员卡信息模型 */
@interface CardInfoModel : NSObject
@property(nonatomic,strong) NSString *merchant_id;//商户ID
@property(nonatomic,strong) NSString *merchant_name;//商户名称
@property(nonatomic,strong) NSString *merchant_bn;//商户编号
@property(nonatomic,strong) NSString *type;//条码类型
@property(nonatomic,strong) NSString *remark;//备注
@property(nonatomic,strong) NSString *card_no;//卡号
@property(nonatomic,strong) NSString *f_image;//正面照
@property(nonatomic,strong) NSString *b_image;//背面照
@property(nonatomic,strong) NSDictionary *merchant_info;

@end

/** 会员卡子卡信息模型 */
@interface CardListModel : NSObject
@property(nonatomic,strong) NSString *card_id;//卡ID
@property(nonatomic,strong) NSString *name;//卡名称
@property(nonatomic,strong) NSString *price;//累计金额
@property(nonatomic,strong) NSString *store;//累计次数
@property(nonatomic,strong) NSString *count_type;//计算类型（1次数,2金额）
@end

/** 卡消费明细模型 */
@interface UsedDetailModel : NSObject
@property(nonatomic,strong) NSString *card_id;//卡ID
@property(nonatomic,strong) NSString *title;//标题
@property(nonatomic,strong) NSString *create_time;//消费时间
@property(nonatomic,strong) NSString *number;//本次消费额度
@property(nonatomic,strong) NSString *price;//累计金额
@property(nonatomic,strong) NSString *store;//累计次数
@property(nonatomic,strong) NSString *count_type;//计算类型（1次数,2金额）

@end

/** 通知模型*/
@interface NoticeModel : NSObject
@property(nonatomic,strong) NSString *message_id;//通知ID
@property(nonatomic,strong) NSString *create_date;//创建时间
@property(nonatomic,strong) NSString *jump_link;//跳转链接
@property(nonatomic,strong) NSString *content;//内容
@end

/** 商户公告模型 */
@interface AnnouncementModel : NSObject
@property(nonatomic,strong) NSString *merchant_id;
@property(nonatomic,strong) NSString *title;//标题
@property(nonatomic,strong) NSString *content;//内容
@property(nonatomic,strong) NSString *create_time;//公告创建时间
@property(nonatomic,strong) NSString *announcement_id;//公告id
@end

/** 品牌列表模型 */
@interface BrandCardListModel : NSObject
@property(nonatomic,strong) NSString *merchant_id; //商户ID
@property(nonatomic,strong) NSString *name;//商户名称
@property(nonatomic,strong) NSString *f_logo;//方logo
@property(nonatomic,strong) NSString *y_logo;//圆logo
@property(nonatomic,strong) NSString *name_index;
@end

/** 文章分类模型 */
@interface ArticleTypeModel : NSObject
@property(nonatomic,strong) NSString *cat_id; //文章分类ID
@property(nonatomic,strong) NSString *cat_name;//文章名称
@end

/** 文章模型 */
@interface ArticleModel : NSObject
@property(nonatomic,strong) NSString *article_id; //文章ID
@property(nonatomic,strong) NSString *title;//文章标题
@property(nonatomic,strong) NSString *image;//图片地址
@property(nonatomic,strong) NSString *create_date;//创建时间
@property(nonatomic,strong) NSString *preview;//文章预览信息
@property(nonatomic,strong) NSString *content;//文章内容
@property(nonatomic, strong) NSString *read_num;//阅读次数
@property(nonatomic, strong) NSString *like_num;//点赞次数
@property(nonatomic, strong) NSString *share_num;//分享次数
@property(nonatomic, strong) NSString *jump_link;//跳转链接
@end

/** 用户信息模型 */
@interface UserInfoModel : NSObject
@property(nonatomic,strong) NSString *mobile;//手机号
@property(nonatomic,strong) NSString *nick_name;//创建时间
@property(nonatomic,strong) NSString *avatar;//文章内容
@end

/** 二手卡券列表模型 */
@interface VoucherListModel : NSObject
@property(nonatomic,strong) NSString *voucher_id;//卡券ID
@property(nonatomic,strong) NSString *title;//标题
@property(nonatomic,strong) NSString *type;//方式
@property(nonatomic,strong) NSString *name;//城市
@property(nonatomic,strong) NSString *location;//地点
@property(nonatomic,strong) NSNumber *price;//价格
@property(nonatomic,strong) NSString *create_date;//创建时间
@end

/** 二手卡券信息模型 */
@interface VoucherDetailModel : NSObject
@property(nonatomic,copy) NSString *voucher_id;//卡券ID
@property(nonatomic,copy) NSString *title;//标题
@property(nonatomic,copy) NSString *type;//方式
@property(nonatomic,copy) NSString *city_name;//城市
@property(nonatomic,copy) NSString *city_id;//城市ID
@property(nonatomic,copy) NSString *location;//地点
@property(nonatomic,copy) NSString *price;//价格
@property(nonatomic,copy) NSString *create_date;//创建时间
@property(nonatomic,copy) NSString *content;//内容
@property(nonatomic,copy) NSString *cat_name;//卡片类别名字
@property(nonatomic,copy) NSString *mobile;//联系人手机号码
@property(nonatomic,copy) NSString *contact;//联系人
@property(nonatomic,strong) NSArray *images;//图片
@end