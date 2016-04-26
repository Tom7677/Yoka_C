//
//  ClipImageViewController.m
//  MembershipCard
//
//  Created by tom.sun on 16/4/11.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "ClipImageViewController.h"
#import "UIImage+Resize.h"

@interface ClipImageViewController ()

@end

@implementation ClipImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"裁剪图片";
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.overView];
    [self addGestureRecognizerToView:self.view];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 28)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn setTitleColor:UIColorFromRGB(0xE33572) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [_imageView setCenter:self.view.center];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_imageView setUserInteractionEnabled:YES];
        [_imageView setMultipleTouchEnabled:YES];
        [_imageView setImage:_image];
    }
    return _imageView;
}

- (UIView *)overView
{
    if (!_overView) {
        _overView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [_overView setBackgroundColor:[UIColor blackColor]];
        _overView.alpha = 0.5;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, MainScreenWidth, 20)];
        label.text = @"移动和调整尺寸";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
        [_overView addSubview:label];
        UIBezierPath *path = [UIBezierPath bezierPath];
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        [path appendPath:[UIBezierPath bezierPathWithRect:_overView.frame]];
        CGPoint center = self.view.center;
        _circularFrame = CGRectMake(center.x - _width / 2, center.y - _height / 2 - 20, _width, _height);
        [path appendPath:[UIBezierPath bezierPathWithRoundedRect:_circularFrame cornerRadius:6].bezierPathByReversingPath];
        [linePath appendPath:[UIBezierPath bezierPathWithRoundedRect:_circularFrame cornerRadius:6]];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = path.CGPath;
        _overView.layer.mask = maskLayer;
        CAShapeLayer *lineLayer = [ CAShapeLayer layer];
        lineLayer.path = linePath.CGPath ;
        lineLayer.fillColor = [ UIColor clearColor ].CGColor ;
        lineLayer.lineWidth = 3.0;
        lineLayer.strokeColor = [ UIColor whiteColor].CGColor ;
        [_overView.layer addSublayer :lineLayer];
    }
    return _overView;
}

- (void) addGestureRecognizerToView:(UIView *)view
{
    // 旋转手势
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:)];
    [view addGestureRecognizer:rotationGestureRecognizer];
    
    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [view addGestureRecognizer:pinchGestureRecognizer];
    
    // 移动手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [view addGestureRecognizer:panGestureRecognizer];
}

/*!
 *  @brief  处理旋转手势
 *
 *  @param rotationGestureRecognizer rotationGestureRecognizer description
 */
- (void)rotateView:(UIRotationGestureRecognizer *)rotationGestureRecognizer
{
    UIView *view = self.imageView;
    if (rotationGestureRecognizer.state == UIGestureRecognizerStateBegan || rotationGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformRotate(view.transform, rotationGestureRecognizer.rotation);
        [rotationGestureRecognizer setRotation:0];
    }
}

/*!
 *  @brief  处理缩放手势
 *
 *  @param pinchGestureRecognizer pinchGestureRecognizer description
 */
- (void)pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = self.imageView;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}

/*!
 *  @brief  处理拖拉手势
 *
 *  @param panGestureRecognizer panGestureRecognizer description
 */
- (void)panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = self.imageView;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}

- (void)save
{
    UIImage *image = [self imageFromSelfView];
    NSData *fdata;
    NSData *bdata;
    if (_isFront) {
        fdata = UIImageJPEGRepresentation([image croppedImage:_circularFrame],0.5);
        bdata = nil;
    }
    else {
        bdata = UIImageJPEGRepresentation([image croppedImage:_circularFrame],0.5);
        fdata = nil;
    }
    [self showHub];
    [[NetworkAPI shared]saveCardInfoByCardId:_cardId remark:nil f_image:fdata b_image:bdata WithFinish:^(BOOL isSuccess, NSString *msg) {
        [self hideHub];
        if (isSuccess) {
            [_delegate ClipImageViewController:self finishClipImage:[image croppedImage:_circularFrame] isFront:_isFront];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [self showAlertViewController:msg];
        }
    } withErrorBlock:^(NSError *error) {
        [self hideHub];
    }];
}

/**
 *  1.获取屏幕图片
 */
- (UIImage *)imageFromSelfView
{
    return [self imageFromViewWithFrame:self.view.frame];
}

- (UIImage *)imageFromViewWithFrame:(CGRect)frame
{
    UIGraphicsBeginImageContext(self.view.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(frame);
    [self.view.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  theImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
