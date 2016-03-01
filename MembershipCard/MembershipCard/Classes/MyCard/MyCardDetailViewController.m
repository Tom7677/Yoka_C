//
//  MyCardDetailViewController.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/22.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "MyCardDetailViewController.h"
#import "UIView+frame.h"

@interface MyCardDetailViewController ()
@property (nonatomic, strong) NSNumber *fromValue;
@property (nonatomic, strong) UIImageView *hornTopImageView;
@end

@implementation MyCardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _hornTopImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 130, 14, 8)];
    _cardInfoBtn.selected = YES;
    _hornTopImageView.image = [UIImage imageNamed:@"icon_horn_top"];
    [_headView addSubview:_hornTopImageView];
    float centerX = 10 + ((MainScreenWidth - 20) / 3 - _hornTopImageView.width) / 2;
    [_hornTopImageView.layer addAnimation:[self moveTime:0.1 X:[NSNumber numberWithFloat:centerX]] forKey:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cardInfoBtnAction:(id)sender {
    float centerX = 10 + ((MainScreenWidth - 20) / 3 - _hornTopImageView.width) / 2;
    [_hornTopImageView.layer addAnimation:[self moveTime:0.1 X:[NSNumber numberWithFloat:centerX]] forKey:nil];
    _cardInfoBtn.selected = YES;
    _cardValueBtn.selected = NO;
    _announcementBtn.selected = NO;
}

- (IBAction)cardValueBtnAction:(id)sender {
    [_hornTopImageView.layer addAnimation:[self moveTime:0.1 X:[NSNumber numberWithFloat:(MainScreenWidth / 2 - _hornTopImageView.width / 2)]] forKey:nil];
    _cardInfoBtn.selected = NO;
    _cardValueBtn.selected = YES;
    _announcementBtn.selected = NO;
}

- (IBAction)announcementBtnAction:(id)sender {
    float centerX = 10 + ((MainScreenWidth - 20) / 3 - _hornTopImageView.width) / 2 + (MainScreenWidth - 20) / 3 * 2;
    [_hornTopImageView.layer addAnimation:[self moveTime:0.1 X:[NSNumber numberWithFloat:centerX]] forKey:nil];
    _cardInfoBtn.selected = NO;
    _cardValueBtn.selected = NO;
    _announcementBtn.selected = YES;
}

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
@end
