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
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(13, self.frame.size.height - 1, [UIScreen mainScreen].bounds.size.width - 26, 0.5)];
    lineView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
