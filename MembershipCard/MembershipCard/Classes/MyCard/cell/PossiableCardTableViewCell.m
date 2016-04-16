//
//  PossiableCardTableViewCell.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/3/20.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "PossiableCardTableViewCell.h"
#import "UIView+border.h"

@implementation PossiableCardTableViewCell

- (void)awakeFromNib {
    [_addCardBtn circularBead:4];
    [_cardImageView circularBead:10];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addCardAction:(id)sender {
    [_delegate possiableCardTableViewCell:self merchantId:_merchantId];
}
@end
