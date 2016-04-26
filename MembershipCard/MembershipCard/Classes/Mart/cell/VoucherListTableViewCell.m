//
//  VoucherListTableViewCell.m
//  MembershipCard
//
//  Created by tom.sun on 16/3/31.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "VoucherListTableViewCell.h"
#import "UIView+border.h"
#import "Macro.h"

@implementation VoucherListTableViewCell

- (void)awakeFromNib {
    [_typeLabel circularBead:4];
    [_deleteLabel circularBoarderBead:4 withBoarder:1 color:UIColorFromRGB(0xf0f0f0)];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(13, self.frame.size.height - 1, [UIScreen mainScreen].bounds.size.width - 13, 0.5)];
    lineView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)deleteAction:(id)sender {
    [_delegate deleteVoucher:_vouchertModel];
}
@end
