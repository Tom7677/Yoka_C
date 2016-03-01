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

@interface InputCardViewController ()

@end

@implementation InputCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    _cardNumText.text = _cardNum;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(takePhoto)];
    _logoLabel.userInteractionEnabled = YES;
    [_logoLabel addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(takePhoto)];
    _logoImageView.userInteractionEnabled = YES;
    [_logoImageView addGestureRecognizer:tap2];
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
    
}



@end
