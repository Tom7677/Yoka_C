//
//  ImageTopButton.m
//  MembershipCard
//
//  Created by tom.sun on 16/3/14.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "ImageTopButton.h"

@implementation ImageTopButton

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
    imageFrame.origin.x = (self.bounds.size.width - imageFrame.size.width)/ 2;
    imageFrame.origin.y = (self.bounds.size.height - imageFrame.size.height - labelFrame.size.height - 2) / 2;
    label.textAlignment = NSTextAlignmentCenter;//设置文字居中
    labelFrame.origin.x = 0;
    labelFrame.origin.y = imageFrame.origin.y + imageFrame.size.height + 2;
    labelFrame.size.width = self.bounds.size.width;
    labelFrame.size.height = 20;
    label.frame = labelFrame;
    imageView.frame = imageFrame;
}
@end
