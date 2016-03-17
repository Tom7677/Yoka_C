//
//  InputCardViewController.h
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/22.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "BaseViewController.h"
#import <TPKeyboardAvoidingScrollView.h>

@interface InputCardViewController : BaseViewController
@property (nonatomic, copy) NSString *brandName;
@property (nonatomic, copy) NSString *cardNum;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *logoLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *cardNumText;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (copy, nonatomic) NSString *logoUrl;



@end
