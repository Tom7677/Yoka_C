//
//  AssignmentInfoViewController.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/3/1.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "AssignmentInfoViewController.h"
#import "UIView+frame.h"
#import "UILabel+caculateSize.h"
#import <UIImageView+WebCache.h>
#import "UIView+border.h"

@interface AssignmentInfoViewController ()
@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, strong) VoucherDetailModel *model;
@end

@implementation AssignmentInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_typeLabel circularBead:4];
    self.title = @"卡券详情";
    _contentView.width = MainScreenWidth;
    _contentView.height = MainScreenHeight;
    [_scrollView addSubview:_contentView];
    [_callBtn setTitle:@"拨打\n电话" forState:UIControlStateNormal];
    _callBtn.titleLabel.numberOfLines = 2;
    _callBtn.titleLabel.lineBreakMode = 0;
    [self loadData];
}

- (void)loadData
{
    [[NetworkAPI shared]getVoucherInfoByVoucherId:_voucher_id WithFinish:^(VoucherDetailModel *model) {
        if (model != nil) {
            _model = model;
            [self refreshViewByModel:model];
        }
    } withErrorBlock:^(NSError *error) {
        
    }];
}

- (void)refreshViewByModel :(VoucherDetailModel *)model
{
    _titleLabel.text = model.title;
    _loactionLabel.text = [NSString stringWithFormat:@"%@ - %@",model.city_name,model.location];
    if ([model.type isEqualToString:@"转让"]) {
        _typeLabel.backgroundColor = UIColorFromRGB(0xeeeeb5);
    }
    else {
        _typeLabel.backgroundColor = UIColorFromRGB(0xbbbbc4);
    }
    _typeLabel.text = model.type;
    _timeLabel.text = [@"发布时间：" stringByAppendingString:model.create_date];
    _priceLabel.text = model.price;
    _voucherTypeLabel.text = [@"类别：" stringByAppendingString:model.cat_name];
    _contentLabel.text = model.content;
    _contactName.text = [@"联系人：" stringByAppendingString:model.contact];
    _contactMobile.text = [@"电话：" stringByAppendingString:model.mobile];
    _phoneNum = model.mobile;
    
    CGFloat height = 0;
    //11为contentLabel距离priceView底部的距离
    _priceView.height = _contentLabel.originY + [_contentLabel getTextHeight] + 11;
    //15为间隔高度
    if (model.images.count > 0) {
        height = _infoView.height  + _picView.height + _phoneNumView.height + 15 * 3 + _priceView.height;
        _picView.originY = _priceView.originY + _priceView.height + 15;
        _phoneNumView.originY = _picView.originY + _picView.height + 15;
        _picView.width = MainScreenWidth;
        _phoneNumView.width = MainScreenWidth;
        [self refreshScrollView];
        [_contentView addSubview:_picView];
        [_contentView addSubview:_phoneNumView];
    }
    else {
        height = _infoView.height  + _phoneNumView.height + 15 * 2 + _priceView.height;
        _phoneNumView.originY = _priceView.originY + _priceView.height + 15;
        _phoneNumView.width = MainScreenWidth;
        [_contentView addSubview:_phoneNumView];
    }
    [_scrollView setContentSize:CGSizeMake(MainScreenWidth, height + 25)];
}

- (void)refreshScrollView
{
    [[_scrollView.subviews lastObject] removeFromSuperview];
    CGFloat width = (MainScreenWidth - 50) / 4;
    CGFloat originY = (90 - width) / 2;
    for (int i = 0; i < _model.images.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((10 + width) * i + 10, originY, width, width)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[imageUrl stringByAppendingString:_model.images[i]]]];
        [_picScrollView addSubview:imageView];
    }
    [_picScrollView setContentSize:CGSizeMake(_model.images.count * (width + 10) + 10, _picScrollView.height)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)callAction:(id)sender {
    UIWebView *callWebView = [[UIWebView alloc]init];
    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_phoneNum]]];
    [self.view addSubview:callWebView];
}
@end
