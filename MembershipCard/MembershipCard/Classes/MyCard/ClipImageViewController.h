//
//  ClipImageViewController.h
//  MembershipCard
//
//  Created by tom.sun on 16/4/11.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "BaseViewController.h"

@protocol ClipImageDelegate;
@interface ClipImageViewController : BaseViewController
@property (nonatomic, strong) id<ClipImageDelegate>delegate;
@property (nonatomic, assign) CGFloat width; //矩形裁剪框的宽
@property (nonatomic, assign) CGFloat height; //矩形裁剪框的高
@property (nonatomic, assign) CGRect circularFrame;//裁剪框的frame
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *overView;
@property (nonatomic, assign) BOOL isFront;
@property (nonatomic, copy) NSString *cardId;
@end

@protocol ClipImageDelegate <NSObject>
-(void)ClipImageViewController:(ClipImageViewController *)clipImageViewController finishClipImage:(UIImage *)editImage isFront:(BOOL)isFront;
@end