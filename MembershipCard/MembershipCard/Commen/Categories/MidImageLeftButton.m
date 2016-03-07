//
//  MidImageLeftButton.m
//  MembershipCard
//
//  Created by tom.sun on 16/3/7.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "MidImageLeftButton.h"

@implementation MidImageLeftButton

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
    imageFrame.origin.x = (self.bounds.size.width - imageFrame.size.width)/ 2 - 10;
    labelFrame.origin.x = imageFrame.origin.x + imageFrame.size.width + 10;
    imageView.frame = imageFrame;
    label.frame = labelFrame;
}

@end
