//
//  QRViewController.m
//  MembershipCard
//
//  Created by 孙鹏 on 16/2/22.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "QRViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "InputCardViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface QRViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong) AVCaptureDevice *captureDevice;
@property (nonatomic, assign) BOOL isLightOn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, assign) BOOL isFirstScan;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (strong, nonatomic) CALayer *scanLayer;
@end

@implementation QRViewController

- (void)dealloc
{
    [_videoPreviewLayer removeFromSuperlayer];
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
    
    NSError *error;
    //1.初始化捕捉设备（AVCaptureDevice），类型为AVMediaTypeVideo
    _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //2.用captureDevice创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:_captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return;
    }
    //3.创建媒体数据输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    //4.实例化捕捉会话
    _captureSession = [[AVCaptureSession alloc] init];
    //4.1.将输入流添加到会话
    [_captureSession addInput:input];
    //4.2.将媒体输出流添加到会话中
    [_captureSession addOutput:captureMetadataOutput];
    //5.创建串行队列，并加媒体输出流添加到队列当中
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    //5.1.设置代理
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    //5.2.设置输出媒体数据类型为条形码
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, nil]];
    //6.实例化预览图层
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    //7.设置预览图层填充方式
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    //8.设置图层的frame
    [_videoPreviewLayer setFrame:self.view.layer.bounds];
    //9.将图层添加到预览view的图层上
    [self.view.layer addSublayer:_videoPreviewLayer];
    
    CGFloat offsetY = (MainScreenHeight - NavAndStatusBarHeight - 160.0f) / 2;
    CGFloat offsetX = (MainScreenWidth -160.0f) / 2;
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
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view bringSubviewToFront:_topLabel];
    [self.view bringSubviewToFront:_changeInputWayBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    _isFirstScan = YES;
    [_captureSession startRunning];
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

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (_isFirstScan) {
        if (metadataObjects != nil && [metadataObjects count] > 0) {
            AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
            //判断回传的数据类型
            _isFirstScan = NO;
            [self performSelectorOnMainThread:@selector(reportScanResult:) withObject:[metadataObj stringValue] waitUntilDone:NO];
        }
    }
    //判断是否有数据
}

- (void)reportScanResult:(NSString *)result {
    [self stopReading];
    InputCardViewController *vc = [[InputCardViewController alloc]init];
    vc.cardNum = result;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)stopReading{
    [_captureSession stopRunning];
}

/**
 *  打开手电筒
 */
-(void) turnOnLed
{
    [_captureDevice lockForConfiguration:nil];
    [_captureDevice setTorchMode:AVCaptureTorchModeOn];
    [_captureDevice unlockForConfiguration];
}

/**
 *  关闭手电筒
 */
-(void) turnOffLed
{
    [_captureDevice lockForConfiguration:nil];
    [_captureDevice setTorchMode: AVCaptureTorchModeOff];
    [_captureDevice unlockForConfiguration];
}

- (IBAction)changeInputWayAction:(id)sender {
    InputCardViewController *vc = [[InputCardViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
