//
//  AddNewCardViewController.h
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/22.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "BaseViewController.h"

@interface AddNewCardViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *addNewCardView;

- (IBAction)qrBtnAction:(id)sender;
- (IBAction)inputBtnAction:(id)sender;
- (IBAction)guessBtnAction:(id)sender;
@end
