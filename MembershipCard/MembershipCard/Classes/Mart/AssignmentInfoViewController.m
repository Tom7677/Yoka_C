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

@interface AssignmentInfoViewController ()
@property (nonatomic, copy) NSString *phoneNum;
@end

@implementation AssignmentInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    _voucherTypeLabel.text = model.cat_name;
    _contentLabel.text = model.content;
    _contactName.text = [@"联系人：" stringByAppendingString:model.contact];
    _contactMobile.text = [@"电话：" stringByAppendingString:model.mobile];
    _phoneNum = model.mobile;
    
    CGFloat height = 0;
    //11为contentLabel距离priceView底部的距离
    _priceView.height = _contentLabel.originY + [_contentLabel getTextHeight] + 11;
    //15为间隔高度
    height = _infoView.height + _picView.height + _phoneNumView.height + 15 * 3 + _priceView.height;
    [_scrollView setContentSize:CGSizeMake(MainScreenWidth, height + 25)];
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
