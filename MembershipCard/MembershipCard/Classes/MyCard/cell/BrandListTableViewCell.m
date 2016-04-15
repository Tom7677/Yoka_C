//
//  BrandListTableViewCell.m
//  MembershipCard
//
//  Created by tom.sun on 16/3/15.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "BrandListTableViewCell.h"
#import "UIView+border.h"

@implementation BrandListTableViewCell

- (void)awakeFromNib {
    [_logoImageView circular];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
