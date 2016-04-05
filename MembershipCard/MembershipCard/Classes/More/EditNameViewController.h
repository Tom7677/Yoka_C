//
//  EditNameViewController.h
//  MembershipCard
//
//  Created by tom.sun on 16/4/5.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "BaseViewController.h"

@interface EditNameViewController : BaseViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@end
