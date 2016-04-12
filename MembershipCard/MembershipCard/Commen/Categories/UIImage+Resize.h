//
//  UIImage+Resize.h
//  MembershipCard
//
//  Created by tom.sun on 16/4/11.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

- (UIImage*)imageWithProportion:(CGSize)ProportionSize percent:(CGFloat)percent;
- (UIImage*)imageWithMaxImagePix:(CGFloat)maxImagePix compressionQuality:(CGFloat)compressionQuality;
- (UIImage *)croppedImage:(CGRect)bounds;
@end
