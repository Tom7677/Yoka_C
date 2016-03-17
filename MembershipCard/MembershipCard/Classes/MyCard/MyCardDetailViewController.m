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

@interface MyCardDetailViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSNumber *fromValue;
@property (nonatomic, strong) UIImageView *hornTopImageView;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation MyCardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.cardTitle.text = _model.name;
    if ([self isEmpty:_model.round_image]) {
        _logoImageView.image = [UIImage imageNamed:@"mjlogo_round.jpg"];
    }else {
        [_logoImageView sd_setImageWithURL:[NSURL URLWithString:_model.round_image]];
    }
    _hornTopImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 178, 14, 8)];
    _cardInfoBtn.selected = YES;
    _hornTopImageView.image = [UIImage imageNamed:@"icon_horn_top"];
    [_headView addSubview:_hornTopImageView];
    
    float centerX = 10 + ((MainScreenWidth - 20) / 3 - _hornTopImageView.width) / 2;
    _hornTopImageView.originX = centerX;
    _codeScrollView.hidden = NO;
    _markScrollView.hidden = YES;
    _newsTableView.hidden = YES;
    [_codeScrollView addSubview:_codeView];
    _codeView.width = MainScreenWidth;
    [_markScrollView addSubview:_markView];
    _markView.width = MainScreenWidth;
    [_codeScrollView setContentSize:CGSizeMake(MainScreenWidth, _codeView.height)];
    [_markScrollView setContentSize:CGSizeMake(MainScreenWidth, _markView.height)];
    [_frontPicBtn circularBoarderBead:8 withBoarder:1 color:UIColorFromRGB(0xf0f0f0)];
    [_backPicBtn circularBoarderBead:8 withBoarder:1 color:UIColorFromRGB(0xf0f0f0)];
    [_markTextView circularBoarderBead:8 withBoarder:1 color:UIColorFromRGB(0xf0f0f0)];
    /** 备注文字框添加点击动作打开修改视图 */
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCommentsView:)];
    [_markTextView addGestureRecognizer:tapGR];
    [_logoImageView circular];
    _newsTableView.delegate = self;
    _newsTableView.dataSource = self;
    [_newsTableView registerNib:[UINib nibWithNibName:@"NotificationTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
    
    [self getCradInfo];
    [self getAnnouncementList];
}

- (void)getCradInfo
{
    [[NetworkAPI shared]getMyCardInfoByMerchantId:_model.merchant_id WithFinish:^(CardInfoModel *model) {
        [self showViewByModel:model];
    } withErrorBlock:^(NSError *error) {
        
    }];
}

- (void)getAnnouncementList
{
    [[NetworkAPI shared]getMerchantAnnouncementByMerchantId:_model.merchant_id WithFinish:^(NSArray *dataArray) {
        _dataArray = dataArray;
        [_newsTableView reloadData];
    } withErrorBlock:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tapCommentsView:(UITapGestureRecognizer *)gr {
    CommentsViewController *commentsVC = [CommentsViewController new];
    [self showViewController:commentsVC sender:self];
}

#pragma mark Action
- (void)showViewByModel:(CardInfoModel *)model
{
    //卡号生成条形码
    NSError *error = nil;
    ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
    ZXBitMatrix* result = [writer encode:model.card_bn format:kBarcodeFormatCode128 width:180 height:60 error:&error];
    if (result) {
        CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage ];
        _qrCodeImageView.image = [UIImage imageWithCGImage:image];
    }
    _codeLabel.text = [self countNumAndChangeformat:model.card_bn];
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
 *  条码
 *
 *  @param sender description
 */
- (IBAction)cardInfoBtnAction:(id)sender {
    float centerX = 0;
    [_hornTopImageView.layer addAnimation:[self moveTime:0.1 X:[NSNumber numberWithFloat:centerX]] forKey:nil];
    _cardInfoBtn.selected = YES;
    _cardValueBtn.selected = NO;
    _announcementBtn.selected = NO;
    _codeScrollView.hidden = NO;
    _markScrollView.hidden = YES;
    _newsTableView.hidden = YES;
    
}

/**
 *  备注
 *
 *  @param sender description
 */
- (IBAction)cardValueBtnAction:(id)sender {
    [_hornTopImageView.layer addAnimation:[self moveTime:0.1 X:[NSNumber numberWithFloat: (MainScreenWidth - 20) / 3]] forKey:nil];
    _cardInfoBtn.selected = NO;
    _cardValueBtn.selected = YES;
    _announcementBtn.selected = NO;
    _codeScrollView.hidden = YES;
    _markScrollView.hidden = NO;
    _newsTableView.hidden = YES;
}

/**
 *  公告
 *
 *  @param sender description
 */
- (IBAction)announcementBtnAction:(id)sender {
    float centerX = 2 * (MainScreenWidth - 20) / 3 ;
    [_hornTopImageView.layer addAnimation:[self moveTime:0.1 X:[NSNumber numberWithFloat:centerX]] forKey:nil];
    _cardInfoBtn.selected = NO;
    _cardValueBtn.selected = NO;
    _announcementBtn.selected = YES;
    _codeScrollView.hidden = YES;
    _markScrollView.hidden = YES;
    _newsTableView.hidden = NO;
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
    [[NetworkAPI shared] updateCardRelationByMerchantId:_model.merchant_id WithDeleteAction:YES WithFinish:^(BOOL isSuccess) {
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

/**
 *  账户信息
 *
 *  @param sender description
 */
- (IBAction)infoBtnAction:(id)sender {
    [[UMengAnalyticsUtil shared]seeCardInfo];
}

#pragma mark UITableViewDelegate/UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
//    AnnouncementModel *model = _dataArray[indexPath.row];
//    cell.contentLabel.text = model.content;
//    cell.timeLabel.text = model.create_time;
    cell.contentLabel.text = @"有点经验的都会觉得这种效果实现起来很简单但麻烦，常用的方法 Delegate、target-action、KVC 等组合使用，而且代码页面的粘合性也比很强。现在我们使用 ReactiveCocoa 来实现不但统一所有的消息，代码也更加的简洁直观，与页面的粘合性也不再这么强，相对在重用时会简单点。";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    cell.contentLabel.text = @"有点经验的都会觉得这种效果实现起来很简单但麻烦，常用的方法 Delegate、target-action、KVC 等组合使用，而且代码页面的粘合性也比很强。现在我们使用 ReactiveCocoa 来实现不但统一所有的消息，代码也更加的简洁直观，与页面的粘合性也不再这么强，相对在重用时会简单点。";
    cell.contentLabel.width = MainScreenWidth - 20;
    CGFloat labelHeight = [cell.contentLabel getTextHeight];
    return labelHeight + 52;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //[dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
    }
}
@end
