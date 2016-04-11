//
//  MyCardBagTableViewCell.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/22.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "MyCardBagTableViewCell.h"
#import "UIView+border.h"

@implementation MyCardBagTableViewCell

- (void)awakeFromNib {
    [_logoImageView circularBead:10];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
