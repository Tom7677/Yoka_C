//
//  CommentsViewController.m
//  MembershipCard
//
//  Created by  on 16/3/11.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "CommentsViewController.h"

@interface CommentsViewController ()
@property (weak, nonatomic) IBOutlet UITextView *commentsTextView;
@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改备注";
    self.commentsTextView.text = _commentsStr;
    [self.commentsTextView becomeFirstResponder];
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 28)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn setTitleColor:UIColorFromRGB(0xE33572) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(saveBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)saveBtnAction {
    [self showHub];
    NSString *newComments = _commentsTextView.text;
    if (newComments.length == 0) {
        newComments = @" ";
    }
    [[NetworkAPI shared]saveCardInfoByCardId:_cardId remark:newComments f_image:nil b_image:nil WithFinish:^(BOOL isSuccess, NSString *msg) {
        [self hideHub];
        if (isSuccess) {
            [_delegate passRemark:_commentsTextView.text];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } withErrorBlock:^(NSError *error) {
        [self hideHub];
    }];
}

@end
