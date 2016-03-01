//
//  QRViewController.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/22.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "QRViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ZXingObjC.h"
#import "InputCardViewController.h"

@interface QRViewController ()<ZXCaptureDelegate>
@property (nonatomic, strong) ZXCapture *capture;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, assign) BOOL isLightOn;
@property (nonatomic, strong) UIButton *rightBtn;
@end

@implementation QRViewController

- (void)dealloc
{
    [self.capture.layer removeFromSuperlayer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫码识别卡片";
    _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 28)];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_rightBtn setTitle:@"打开照明" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(openFlashBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    CGFloat offsetY = (MainScreenHeight - NavAndStatusBarHeight - 160.0f) / 2;
    CGFloat offsetX = (MainScreenWidth -160.0f) / 2;
    self.capture = [[ZXCapture alloc] init];
    self.capture.camera = self.capture.back;
    self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    self.capture.rotation = 90.0f;
    self.capture.layer.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
    [self.view.layer addSublayer:self.capture.layer];
    UIView *bgTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, offsetY)];
    UIView *bgBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, offsetY + 160.0f, MainScreenWidth, offsetY)];
    UIView *bgLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, offsetY, offsetX, 160.0f)];
    UIView *bgRightView = [[UIView alloc] initWithFrame:CGRectMake(offsetX + 160.0f, offsetY, offsetX, 160.0f)];
    bgTopView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4f];
    bgBottomView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4f];
    bgLeftView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4f];
    bgRightView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4f];
    [self.view addSubview:bgTopView];
    [self.view addSubview:bgBottomView];
    [self.view addSubview:bgLeftView];
    [self.view addSubview:bgRightView];
    self.capture.delegate = self;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view bringSubviewToFront:_topLabel];
    [self.view bringSubviewToFront:_changeInputWayBtn];
    _isLightOn = NO;
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.capture start];
}

- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result
{
    if (!result) return;
    [self.capture stop];
    InputCardViewController *vc = [[InputCardViewController alloc]init];
    vc.cardNum = result.text;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)openFlashBtnAction
{
    if (_isLightOn) {
        _isLightOn = NO;
        [self turnOffLed];
    }else{
        _isLightOn = YES;
        [self turnOnLed];
    }
}

/**
 *  打开手电筒
 */
-(void) turnOnLed
{
    [_device lockForConfiguration:nil];
    [_device setTorchMode:AVCaptureTorchModeOn];
    [_device unlockForConfiguration];
}

/**
 *  关闭手电筒
 */
-(void) turnOffLed
{
    [_device lockForConfiguration:nil];
    [_device setTorchMode: AVCaptureTorchModeOff];
    [_device unlockForConfiguration];
}

- (IBAction)changeInputWayAction:(id)sender {
    InputCardViewController *vc = [[InputCardViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
