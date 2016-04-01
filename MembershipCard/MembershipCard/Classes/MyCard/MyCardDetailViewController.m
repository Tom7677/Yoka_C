//
//  MyCardDetailViewController.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/22.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "MyCardDetailViewController.h"
#import "UIView+frame.h"
#import <UIImageView+WebCache.h>
#import "ZXingObjC.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "UIView+border.h"
#import "takePhoto.h"
#import "NotificationTableViewCell.h"
#import "UILabel+caculateSize.h"
#import "CommentsViewController.h"
#import "BaseViewController.h"
#import "MidImageLeftButton.h"
#import "ServiceViewController.h"

@interface MyCardDetailViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSNumber *fromValue;
@property (nonatomic, strong) UIImageView *hornTopImageView;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation MyCardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.cardTitle.text = _model.name;
    if ([self isEmpty:_model.y_logo]) {
        _logoImageView.image = [UIImage imageNamed:@"mjlogo_round.jpg"];
    }else {
        [_logoImageView sd_setImageWithURL:[NSURL URLWithString:[imageUrl stringByAppendingString:_model.y_logo]]];
    }
    _hornTopImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 178, 14, 8)];
    _cardInfoBtn.selected = YES;
    _hornTopImageView.image = [UIImage imageNamed:@"icon_horn_top"];
    [_headView addSubview:_hornTopImageView];
    
    float centerX = 10 + ((MainScreenWidth - 20) / 2 - _hornTopImageView.width) / 2;
    _hornTopImageView.originX = centerX;
    _codeScrollView.hidden = NO;
    _servicesScrollView.hidden = YES;
    [_codeScrollView addSubview:_codeView];
    _codeView.width = MainScreenWidth;
    [_codeScrollView setContentSize:CGSizeMake(MainScreenWidth, _codeView.height)];
    [_servicesScrollView addSubview:_serviceView];
    _serviceView.width = MainScreenWidth;
    [_frontPicBtn circularBoarderBead:8 withBoarder:1 color:UIColorFromRGB(0xf0f0f0)];
    [_backPicBtn circularBoarderBead:8 withBoarder:1 color:UIColorFromRGB(0xf0f0f0)];
    [_markTextView circularBoarderBead:8 withBoarder:1 color:UIColorFromRGB(0xf0f0f0)];
    /** 备注文字框添加点击动作打开修改视图 */
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCommentsView:)];
    [_markTextView addGestureRecognizer:tapGR];
    if (_markTextView.text.length != 0) {
        _markNotesLabel.hidden = YES;
    }
    [_logoImageView circular];
    [self getCradInfo];
    [self layoutServiceView];
//    [self getAnnouncementList];
}

- (void)getCradInfo
{
    [[NetworkAPI shared]getMyCardInfoByCardId:_model.card_id WithFinish:^(CardInfoModel *model) {
        [self showViewByModel:model];
    } withErrorBlock:^(NSError *error) {
        
    }];
}

- (void)layoutServiceView
{
    NSArray *titleArray = @[@"帐户卡值",@"公告咨询",@"门店官网",@"活动展示",@"品牌商城"];
    for (int i = 0; i < titleArray.count; i++) {
        MidImageLeftButton *button = [[MidImageLeftButton alloc]initWithFrame: CGRectMake(15, (10 + 70) * i + 15, MainScreenWidth - 30, 70)];
        button.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
        button.tag = i;
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ser-0%d", i + 1]] forState:UIControlStateNormal];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitleColor:[UIColor blackColor] forState:0];
        [button circularBoarderBead:8 withBoarder:1 color:UIColorFromRGB(0xf0f0f0)];
        [button addTarget:self action:@selector(serviceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_serviceView addSubview:button];
    }
}

- (void)serviceButtonClick:(MidImageLeftButton *)sender {
    ServiceViewController *vc = [[ServiceViewController alloc]init];
    vc.title = sender.titleLabel.text;
    vc.urlStr = @"www.baidu.com";
    switch (sender.tag) {
        case 0:
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            break;
        default:
            break;
    }

    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tapCommentsView:(UITapGestureRecognizer *)gr {
    _markNotesLabel.hidden = YES;
    CommentsViewController *commentsVC = [CommentsViewController new];
    [self showViewController:commentsVC sender:self];
}

#pragma mark Action
- (void)showViewByModel:(CardInfoModel *)model
{
    //卡号生成条形码
    NSError *error = nil;
    ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
    ZXBarcodeFormat type;
    if ([model.type isEqualToString:@"pdf417"]) {
        type = kBarcodeFormatPDF417;
    }else if ([model.type isEqualToString:@"EAN-13"]){
        type = kBarcodeFormatEan13;
    }else if ([model.type isEqualToString:@"EAN-8"]){
        type = kBarcodeFormatEan8;
    }else {
        type = kBarcodeFormatCode128;
    }
    ZXBitMatrix* result = [writer encode:model.card_no format: type width:180 height:60 error:&error];
    if (result) {
        CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage ];
        _qrCodeImageView.image = [UIImage imageWithCGImage:image];
    }
    _codeLabel.text = [self countNumAndChangeformat:model.card_no];
}

/**
 *  给卡号中每3位间加空格
 *
 *  @param num 卡号
 *
 *  @return value description
 */
- (NSString *)countNumAndChangeformat:(NSString *)num
{
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@" " atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
}

/**
 *  卡片信息展示
 *
 *  @param sender description
 */
- (IBAction)cardInfoBtnAction:(id)sender {
    float centerX = 0;
    [_hornTopImageView.layer addAnimation:[self moveTime:0.1 X:[NSNumber numberWithFloat:centerX]] forKey:nil];
    _cardInfoBtn.selected = YES;
    _serviceBtn.selected = NO;
    _codeScrollView.hidden = NO;
    _servicesScrollView.hidden = YES;
    
}

/**
 *  服务信息展示
 *
 *  @param sender description
 */
- (IBAction)serviceBtnAction:(id)sender {
    float centerX = (MainScreenWidth - 20) / 2;
    [_hornTopImageView.layer addAnimation:[self moveTime:0.1 X:[NSNumber numberWithFloat:centerX]] forKey:nil];
    _cardInfoBtn.selected = NO;
    _serviceBtn.selected = YES;
    _codeScrollView.hidden = YES;
    _servicesScrollView.hidden = NO;
}

/**
 *  尖角移动动画
 *
 *  @param time 时间
 *  @param x    x
 *
 *  @return value description
 */
- (CABasicAnimation *)moveTime:(float)time X:(NSNumber*)x
{
    CABasicAnimation *animation = [ CABasicAnimation animationWithKeyPath : @"transform.translation.x" ];
    animation.toValue = x;
    animation.duration = time;
    animation.removedOnCompletion = NO;
    animation.repeatCount = 0;
    animation.fillMode = kCAFillModeForwards ;
    return animation;
}

/**
 *  删除卡片
 *
 *  @param sender description
 */
- (IBAction)deleteBtnAction:(id)sender {
    [[UMengAnalyticsUtil shared]deleteCardByMerchantsName:_model.name];
    [[NetworkAPI shared] updateCardRelationByMerchantId:_model.card_id WithDeleteAction:YES WithFinish:^(BOOL isSuccess) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } withErrorBlock:^(NSError *error) {
        
    }];
}

/**
 *  选择正面照
 *
 *  @param sender description
 */
- (IBAction)frontBtnAction:(id)sender {
    [takePhoto sharePicture:NO sendPicture:^(UIImage *image) {
        [_frontPicBtn setBackgroundImage:image forState:UIControlStateNormal];
    }];
}

/**
 *  选择背面照
 *
 *  @param sender description
 */
- (IBAction)backPicAction:(id)sender {
    [takePhoto sharePicture:NO sendPicture:^(UIImage *image) {
        [_backPicBtn setBackgroundImage:image forState:UIControlStateNormal];
    }];
}

/**
 *  back
 *
 *  @param sender description
 */
- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
