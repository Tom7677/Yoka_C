//
//  UIView+border.m
//  Hiking
//
//  Created by benny on 13-11-26.
//  Copyright (c) 2013年 augmentum. All rights reserved.
//

#import "UIView+border.h"
#import "QuartzCore/QuartzCore.h"
#import "Macro.h"

@implementation UIView (border)
/*!
 *  @brief  画固定弧度
 */
- (void)circularBead
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0;
}

/*!
 *  @brief  画指定高度和颜色的框
 *
 *  @param width 线的高度
 *  @param color 线的颜色
 */
- (void)border:(float)width color:(UIColor*)color
{
    self.layer.borderWidth = width;
    self.layer.borderColor = [color CGColor];
}

- (void)border:(float)width
{
    self.layer.borderWidth = width;
}


/*!
 *  @brief  画指定弧度
 *
 *  @param width 弧度
 */
- (void)circularBead:(float)width
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = width;
}

/*!
 *  @brief  画弧度
 *
 *  @param width 弧度
 *  @param w     线的高度
 */
- (void)circularBoarderBead:(float)width withBoarder:(float)w
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = width;
    self.layer.borderWidth = w;
    self.layer.borderColor = [UIColorFromRGB(0xcccccc) CGColor];
}

- (void)circularBoarderBead:(float)width withBoarder:(float)w color:(UIColor *)color
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = width;
    self.layer.borderWidth = w;
    self.layer.borderColor = [color CGColor];
}

- (void)rightBorder:(float)width
{
    CALayer *rightBorder = [CALayer layer];
    rightBorder.frame = CGRectMake(self.frame.size.width - width, 0.0f, width, self.frame.size.height);
    rightBorder.backgroundColor = [UIColorFromRGB(0xcccccc) CGColor];
    [self.layer addSublayer:rightBorder];
}

- (void)leftBorder:(float)width
{
    CALayer *leftBorder = [CALayer layer];
    leftBorder.frame = CGRectMake(0.0f, 0.0f, width, self.frame.size.height);
    leftBorder.backgroundColor = [UIColorFromRGB(0xcccccc) CGColor];
    [self.layer addSublayer:leftBorder];
}

- (void)bottomBorder:(float)width
{
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.frame.size.height - width, self.frame.size.width, width);
    bottomBorder.backgroundColor = [UIColorFromRGB(0xcccccc) CGColor];
    [self.layer addSublayer:bottomBorder];
}

- (void)topBorder:(float)width
{
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, width);
    topBorder.backgroundColor = [UIColorFromRGB(0xcccccc) CGColor];
    [self.layer addSublayer:topBorder];
}

//圆
- (void)circular
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.width/2;
}
@end
