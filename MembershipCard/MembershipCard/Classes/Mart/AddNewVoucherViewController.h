//
//  AddNewVoucherViewController.h
//  MembershipCard
//
//  Created by tom.sun on 16/3/31.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "BaseViewController.h"
#import <TPKeyboardAvoidingTableView.h>
#import "TSImageLeftButton.h"

@interface AddNewVoucherViewController : BaseViewController

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet TSImageLeftButton *transferBtn;
@property (weak, nonatomic) IBOutlet TSImageLeftButton *buyBtn;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (assign, nonatomic) BOOL isNew;

- (IBAction)chooseAreaAction:(id)sender;
- (IBAction)sendAction:(id)sender;
- (IBAction)transferAction:(id)sender;
- (IBAction)buyAction:(id)sender;

@end
