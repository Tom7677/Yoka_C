//
//  AddNewVoucherViewController.h
//  MembershipCard
//
//  Created by tom.sun on 16/3/31.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "BaseViewController.h"
#import <TPKeyboardAvoidingTableView.h>

@interface AddNewVoucherViewController : BaseViewController

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UIView *footView;
@end
