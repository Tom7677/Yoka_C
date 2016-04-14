//
//  NotificationTableViewCell.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/22.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "NotificationTableViewCell.h"

@implementation NotificationTableViewCell

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
    totalHeight += 31; // margins
    return CGSizeMake(size.width, totalHeight);
}
@end
