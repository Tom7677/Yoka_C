//
//  DiscoveryWithImageCell.m
//  MembershipCard
//
//  Created by tom.sun on 16/3/8.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "DiscoveryWithImageCell.h"
#import "Macro.h"

@implementation DiscoveryWithImageCell

- (void)awakeFromNib {
    self.contentView.bounds = [UIScreen mainScreen].bounds;
    _moreLabel.textColor = UIColorFromRGB(0xFF526E);
    _moreLabel.layer.borderWidth = 1;
    _moreLabel.layer.borderColor = [UIColorFromRGB(0xFF526E) CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
