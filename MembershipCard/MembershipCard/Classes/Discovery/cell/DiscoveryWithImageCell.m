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
    _moreLabel.textColor = UIColorFromRGB(0xFF526E);
    _moreLabel.layer.borderWidth = 1;
    _moreLabel.layer.borderColor = [UIColorFromRGB(0xFF526E) CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGFloat totalHeight = 0;
    totalHeight += [self.coverImageView sizeThatFits:size].height;
    totalHeight += [self.titleLabel sizeThatFits:size].height;
    totalHeight += [self.contentLabel sizeThatFits:size].height;
    totalHeight += [self.detailsLabel sizeThatFits:size].height;
    totalHeight += [self.moreLabel sizeThatFits:size].height;
    totalHeight += 40; // margins
    return CGSizeMake(size.width, totalHeight);
}
@end
