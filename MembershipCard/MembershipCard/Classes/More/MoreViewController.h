//
//  MoreViewController.h
//  MembershipCard
//
//  Created by  on 16/3/3.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "BaseViewController.h"

@interface MoreViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *avatarBtn;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (strong, nonatomic) IBOutlet UIView *bgView;


- (IBAction)avatarBtnAction:(id)sender;
- (IBAction)editBtnAction:(id)sender;
- (IBAction)cardMartBtnAction:(id)sender;
- (IBAction)secondHandBtnAction:(id)sender;
- (IBAction)btnAction:(id)sender;

@end
