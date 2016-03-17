//
//  DiscoveryTableViewCell.m
//  MembershipCard
//
//  Created by tom.sun on 16/3/8.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "DiscoveryTableViewCell.h"

@implementation DiscoveryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 0;
    totalHeight += [self.contentLabel sizeThatFits:size].height;
    totalHeight += [self.timeLabel sizeThatFits:size].height;
    totalHeight += 40; // margins
    return CGSizeMake(size.width, totalHeight);
}
@end
