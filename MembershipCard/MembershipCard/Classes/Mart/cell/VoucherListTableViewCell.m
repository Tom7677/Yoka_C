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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)deleteAction:(id)sender {
    [_delegate deleteVoucher:_vouchertModel];
}
@end
