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
#import <UIButton+WebCache.h>
#import "ZXingObjC.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "UIView+border.h"
#import "takePhoto.h"
#import "NotificationTableViewCell.h"
#import "UILabel+caculateSize.h"
#import "CommentsViewController.h"
#import "BaseViewController.h"
#import "MidImageLeftButton.h"
#import "WebViewController.h"
#import "ExplainViewController.h"
#import "ClipImageViewController.h"
#import "BrandListViewController.h"

@interface MyCardDetailViewController ()<UIGestureRecognizerDelegate,ClipImageDelegate,CommentsViewControllerDelegate>
@property (nonatomic, strong) NSNumber *fromValue;
@property (nonatomic, strong) UIImageView *hornTopImageView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSDictionary *cardInfo;
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
    [_servicesScrollView setContentSize:CGSizeMake(MainScreenWidth, _serviceView.height)];
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
    [_bindBrandBtn circularBoarderBead:5 withBoarder:1 color:UIColorFromRGB(0xFF526E)];
}

- (void)getCradInfo
{
    [self showHub];
    [[NetworkAPI shared]getMyCardInfoByCardId:_model.card_id WithFinish:^(CardInfoModel *model) {
        [self showHub];
        _cardInfo = model.merchant_info;
        [self showViewByModel:model];
        if (![model.merchant_id isEqualToString:@"0"]) {
            [self layoutServiceView];
        }
        if (![self isEmpty:model.remark]) {
            _markNotesLabel.hidden = YES;
            _markTextView.text = model.remark;
        }
        if (![self isEmpty:model.f_image]) {
            [_frontPicBtn setTitle:@"" forState:UIControlStateNormal];
            [_frontPicBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[imageUrl stringByAppendingString:model.f_image]] forState:UIControlStateNormal];
        }
        if (![self isEmpty:model.b_image]) {
            [_backPicBtn setTitle:@"" forState:UIControlStateNormal];
            [_backPicBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[imageUrl stringByAppendingString:model.b_image]] forState:UIControlStateNormal];
        }
    } withErrorBlock:^(NSError *error) {
        [self showHub];
        [self showAlertViewController:@"您无法连接到网络，请确认网络连接。"];
    }];
}

- (void)layoutServiceView
{
    NSArray *titleArray = @[@"帐户卡值",@"公告咨询",@"门店官网",@"活动展示",@"品牌商城"];
    for (int i = 0; i < titleArray.count; i++) {
        MidImageLeftButton *button = [[MidImageLeftButton alloc]initWithFrame: CGRectMake(15, (10 + 60) * i + 10, MainScreenWidth - 30, 60)];
        button.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
        button.tag = i;
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ser-0%d", i + 1]] forState:UIControlStateNormal];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor blackColor] forState:0];
        [button circularBoarderBead:8 withBoarder:1 color:UIColorFromRGB(0xf0f0f0)];
        [button addTarget:self action:@selector(serviceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_serviceView addSubview:button];
    }
}

- (void)serviceButtonClick:(MidImageLeftButton *)sender {
    NSString *urlStr;
    switch (sender.tag) {
        case 0:
            urlStr = _cardInfo[@"account_value"];
            break;
        case 1:
            urlStr = _cardInfo[@"announcement"];
            break;
        case 2:
            urlStr = _cardInfo[@"website"];
            break;
        case 3:
            urlStr = _cardInfo[@"activities"];
            break;
        default:
            urlStr = _cardInfo[@"estore"];
            break;
    }
    if ([self isEmpty:urlStr]) {
        urlStr = EMPTYWEBURL;
    }
    WebViewController *vc = [[WebViewController alloc]initWithWebNavigationAndURLString:urlStr];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)passRemark:(NSString *)remark
{
    _markNotesLabel.hidden = YES;
    _markTextView.text = remark;
}

- (void)tapCommentsView:(UITapGestureRecognizer *)gr {
    CommentsViewController *commentsVC = [CommentsViewController new];
    commentsVC.delegate = self;
    commentsVC.cardId = _model.card_id;
    [self.navigationController pushViewController:commentsVC animated:YES];
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
        CGRect frame = _qrCodeImageView.frame;
        _qrCodeImageView.frame = CGRectMake((MainScreenWidth-300)/2, frame.origin.y, 300, frame.size.height);
    }else if ([model.type isEqualToString:@"EAN-13"]){
        type = kBarcodeFormatEan13;
    }else if ([model.type isEqualToString:@"EAN-8"]){
        type = kBarcodeFormatEan8;
    }else {
        type = kBarcodeFormatCode128;
    }
    ZXBitMatrix* result = [writer encode:model.card_no format: type width:270 height:80 error:&error];
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
    [_hornTopImageView.layer addAnimation:[self moveTime:0.3 X:[NSNumber numberWithFloat:centerX]] forKey:nil];
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
    [_hornTopImageView.layer addAnimation:[self moveTime:0.3 X:[NSNumber numberWithFloat:centerX]] forKey:nil];
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
 *  无法扫描注释
 */
- (IBAction)explainBtnAction:(id)sender {
    ExplainViewController *vc = [[ExplainViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 *  绑定品牌商户
 */
- (IBAction)bindBrandAction:(id)sender {
    BrandListViewController *vc = [[BrandListViewController alloc]init];
    vc.cardIdFromBind = _model.card_id;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  删除卡片
 *
 *  @param sender description
 */
- (IBAction)deleteBtnAction:(id)sender {
    [self showConfirmAlertViewControllerWithTitle:@"确认删除" andAction:^{
        [[UMengAnalyticsUtil shared]deleteCardByMerchantsName:_model.name];
        [[NetworkAPI shared]deleteCardByCardId:_model.card_id WithFinish:^(BOOL isSuccess, NSString *msg) {
            if (isSuccess) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else {
                [self showAlertViewController:msg];
            }
        } withErrorBlock:^(NSError *error) {
            
        }];
    }];
}

/**
 *  选择正面照
 *
 *  @param sender description
 */
- (IBAction)frontBtnAction:(id)sender {
    [takePhoto sharePicture:NO sendPicture:^(UIImage *image) {
        ClipImageViewController *vc = [[ClipImageViewController alloc]init];
        vc.image = image;
        vc.width = MainScreenWidth - 80;
        vc.height = ((MainScreenWidth - 80) * 90)/ 135;
        vc.isFront = YES;
        vc.delegate = self;
        vc.cardId = _model.card_id;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)ClipImageViewController:(ClipImageViewController *)clipImageViewController finishClipImage:(UIImage *)editImage isFront:(BOOL)isFront
{
    if (isFront) {
        [_frontPicBtn setBackgroundImage:editImage forState:UIControlStateNormal];
        [_frontPicBtn setTitle:@"" forState:UIControlStateNormal];
    }
    else {
        [_backPicBtn setBackgroundImage:editImage forState:UIControlStateNormal];
        [_backPicBtn setTitle:@"" forState:UIControlStateNormal];
    }
}

/**
 *  选择背面照
 *
 *  @param sender description
 */
- (IBAction)backPicAction:(id)sender {
    [takePhoto sharePicture:NO sendPicture:^(UIImage *image) {
        ClipImageViewController *vc = [[ClipImageViewController alloc]init];
        vc.image = image;
        vc.width = MainScreenWidth - 80;
        vc.height = ((MainScreenWidth - 80) * 90)/ 135;
        vc.isFront = NO;
        vc.delegate = self;
        vc.cardId = _model.card_id;
        [self.navigationController pushViewController:vc animated:YES];
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
