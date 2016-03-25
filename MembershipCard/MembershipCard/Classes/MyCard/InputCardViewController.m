//
//  InputCardViewController.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/22.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "InputCardViewController.h"
#import "UIView+frame.h"
#import "takePhoto.h"
#import "UIView+border.h"

@interface InputCardViewController ()

@end

@implementation InputCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手工输入卡号";
    _bgView.width = MainScreenWidth;
    _bgView.height = MainScreenHeight;
    _scrollView.contentSize = CGSizeMake(_bgView.width, _bgView.height - NavAndStatusBarHeight);
    [_scrollView addSubview:_bgView];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 28)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn setTitleColor:UIColorFromRGB(0xE33572) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(saveBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];
    if (_brandName) {
        _nameText.text = _brandName;
        [_nameText setTextColor:[UIColor grayColor]];
        _nameText.enabled = NO;
    }
    if (_cardNum) {
        _cardNumText.text = _cardNum;
        [_cardNumText setTextColor:[UIColor grayColor]];
        _cardNumText.enabled = NO;
    }
    
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(takePhoto)];
//    _logoLabel.userInteractionEnabled = YES;
//    [_logoLabel addGestureRecognizer:tap1];
//    
//    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(takePhoto)];
//    _logoImageView.userInteractionEnabled = YES;
//    [_logoImageView addGestureRecognizer:tap2];
//    [_logoLabel circular];
//    [_logoImageView circularBoarderBead:_logoImageView.width / 2 withBoarder:1 color:UIColorFromRGB(0xf0f0f0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)takePhoto
{
    [takePhoto sharePicture:YES sendPicture:^(UIImage *image) {
        _logoLabel.hidden = YES;
        _logoImageView.image = image;
    }];
}


- (void)saveBtnAction
{
    if (_brandId) {
        [[NetworkAPI shared] addNewBrandCardByMerchantID:_brandId AndCardNum:_cardNumText.text WithFinish:^(BOOL isSuccess, NSString *msg) {
           [self.navigationController popToRootViewControllerAnimated:YES];
        } withErrorBlock:^(NSError *error) {
            
        }];
    }else {
        [[NetworkAPI shared] addNewNonBrandCardByMerchantName:_nameText.text cardNum:_cardNumText.text WithFinish:^(BOOL isSuccess, NSString *msg) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        } withErrorBlock:^(NSError *error) {
        }];
    }
    if (!_cardNum) {
      [[UMengAnalyticsUtil shared]saveCardByMerchantsName:_nameText.text type:@"手动输入"];
    }else {
       [[UMengAnalyticsUtil shared]saveCardByMerchantsName:_nameText.text type:@"扫码"];
    }
    

}
@end
