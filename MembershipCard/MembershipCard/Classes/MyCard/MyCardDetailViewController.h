//
//  MyCardDetailViewController.h
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/22.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "BaseViewController.h"

@interface MyCardDetailViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *cardTitle;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIButton *cardInfoBtn;
@property (weak, nonatomic) IBOutlet UIButton *serviceBtn;
@property (weak, nonatomic) IBOutlet UIButton *cardValueBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *codeScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *markScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *servicesScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UIButton *frontPicBtn;
@property (weak, nonatomic) IBOutlet UIButton *backPicBtn;
@property (weak, nonatomic) IBOutlet UITextView *markTextView;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIView *markView;
@property (weak, nonatomic) IBOutlet UIView *serviceView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (strong, nonatomic) MyCardModel *model;

- (IBAction)cardValueBtnAction:(id)sender;
- (IBAction)cardInfoBtnAction:(id)sender;
- (IBAction)serviceBtnAction:(id)sender;
- (IBAction)deleteBtnAction:(id)sender;
- (IBAction)frontBtnAction:(id)sender;
- (IBAction)backPicAction:(id)sender;
- (IBAction)backBtnAction:(id)sender;
- (IBAction)infoBtnAction:(id)sender;

@end
