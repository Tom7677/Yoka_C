//
//  MyCardDetailViewController.h
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/22.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "BaseViewController.h"

@interface MyCardDetailViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIButton *cardInfoBtn;
@property (weak, nonatomic) IBOutlet UIButton *announcementBtn;
@property (weak, nonatomic) IBOutlet UIButton *cardValueBtn;

- (IBAction)cardValueBtnAction:(id)sender;
- (IBAction)cardInfoBtnAction:(id)sender;
- (IBAction)announcementBtnAction:(id)sender;
@end
