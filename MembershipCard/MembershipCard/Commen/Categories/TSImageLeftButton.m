//
//  TSImageLeftButton.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/3/6.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "TSImageLeftButton.h"

@implementation TSImageLeftButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    UILabel *label = [self titleLabel];
    UIImageView *imageView = [self imageView];
    CGRect imageFrame = imageView.frame;
    CGRect labelFrame = label.frame;
    imageFrame.origin.x = 0;
    labelFrame.origin.x = imageFrame.origin.x + imageFrame.size.width;
    imageView.frame = imageFrame;
    label.frame = labelFrame;
}

@end
