//
//  UIImage+Resize.m
//  MembershipCard
//
//  Created by tom.sun on 16/4/11.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "UIImage+Resize.h"
#import <ImageIO/ImageIO.h>
#import "Macro.h"
#import "UIView+frame.h"

@interface UIImage ()
//@property(nonatomic,strong) UIView *bgView;

@end
@implementation UIImage (Resize)
- (UIImage*)imageWithProportion:(CGSize)ProportionSize percent:(CGFloat)percent
{
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat scaleFactor = 0.0;
    CGPoint thumbPoint = CGPointMake(0.0,0.0);
    CGFloat widthFactor = ProportionSize.width / width;
    CGFloat heightFactor = ProportionSize.height / height;
    if (widthFactor > heightFactor)  {
        scaleFactor = widthFactor;
    }else {
        scaleFactor = heightFactor;
    }
    CGFloat scaledWidth  = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    if (widthFactor > heightFactor) {
        thumbPoint.y = (ProportionSize.height - scaledHeight) * 0.5;
    }else if (widthFactor < heightFactor) {
        thumbPoint.x = (ProportionSize.width - scaledWidth) * 0.5;
    }
    UIGraphicsBeginImageContext(ProportionSize);
    CGRect thumbRect = CGRectZero;
    thumbRect.origin = thumbPoint;
    thumbRect.size.width  = scaledWidth;
    thumbRect.size.height = scaledHeight;
    [self drawInRect:thumbRect];
    
    UIImage *thumbImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *thumbImageData = UIImageJPEGRepresentation(thumbImage, percent);
    return [UIImage imageWithData:thumbImageData];
}

- (UIImage*)imageWithMaxImagePix:(CGFloat)maxImagePix compressionQuality:(CGFloat)compressionQuality
{
    CGFloat width = 0.0;
    CGFloat height = 0.0;
    if (self.size.width >= self.size.height) {
        width = maxImagePix;
        height = self.size.height*maxImagePix/self.size.width;
    }else{
        height = maxImagePix;
        width = self.size.width*maxImagePix/self.size.height;
    }
    
    CGSize sizeImageSmall = CGSizeMake(width, height);
    
    UIGraphicsBeginImageContext(sizeImageSmall);
    CGRect smallImageRect = CGRectMake(0, 0, sizeImageSmall.width, sizeImageSmall.height);
    [self drawInRect:smallImageRect];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *dataImage = UIImageJPEGRepresentation(smallImage, compressionQuality);
    return [UIImage imageWithData:dataImage];
}

/*!
 *  @brief  截取指定位置的图片
 *
 *  @param bounds bounds description
 *
 *  @return return value description
 */
- (UIImage *)croppedImage:(CGRect)bounds {
    CGFloat scale = MAX(self.scale, 1.0f);
    CGRect scaledBounds = CGRectMake(bounds.origin.x * scale, bounds.origin.y * scale, bounds.size.width * scale, bounds.size.height * scale);
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], scaledBounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    return croppedImage;
}

+ (UIImage *)thumbnailImageMaxPixelSize:(CGFloat)size forImageData:(NSData *)imageData
{
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    
    NSDictionary *thumbnailOptions = [NSDictionary dictionaryWithObjectsAndKeys:(id)kCFBooleanTrue,
                                      kCGImageSourceCreateThumbnailWithTransform,
                                      kCFBooleanTrue, kCGImageSourceCreateThumbnailFromImageAlways,
                                      [NSNumber numberWithFloat:size], kCGImageSourceThumbnailMaxPixelSize,
                                      nil];
    CGImageRef theImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, (__bridge CFDictionaryRef)thumbnailOptions);
    CFRelease(imageSource);
    
    if (theImage != NULL) {
        UIImage *uiImage = [[UIImage alloc]initWithCGImage:theImage];
        CFRelease(theImage);
        return uiImage;
    }
    return nil;
}

+ (void)fullDisplayImage:(UIImageView *)imageView
{
    imageView.userInteractionEnabled = YES;
    imageView.tag = 2000;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showImage:)];
    [imageView addGestureRecognizer:tapGesture];
  
}

+ (void)showImage:(UITapGestureRecognizer *)tap
{
    if (tap.view.tag == 2000) {
        UIImageView *originImageView = (UIImageView *)tap.view;
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
        bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
        UIImageView *imageView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,MainScreenWidth , MainScreenHeight)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = originImageView.image;
        [bgView addSubview:imageView];
        bgView.tag = 1000;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
        bgView.userInteractionEnabled = YES;
        [bgView addGestureRecognizer:tap];
        [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    }
    
}

+ (void)hideImage:(UITapGestureRecognizer *)tap
{
    if (tap.view.tag == 1000) {
        UIView *view = (UIView *)tap.view;
        [view removeFromSuperview];
    }
}
@end
