//
//  BarCodeVC.m
//  KissHealth
//
//  Created by Macx on 16/2/17.
//  Copyright © 2016年 LWHTteam. All rights reserved.
//

#import "BarCodeVC.h"
#import <AVFoundation/AVFoundation.h>

@interface BarCodeVC ()<AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) AVCaptureDevice *device;
@property (strong, nonatomic) AVCaptureDeviceInput *input;
@property (strong, nonatomic) AVCaptureMetadataOutput *output;
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;

@end

@implementation BarCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //是否有摄像机
    BOOL haveCamer = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (!haveCamer)
    {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提醒" message:@"摄像头无法使用" preferredStyle:UIAlertControllerStyleAlert];
        __weak typeof(self) weakSelf = self;
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }];
        [alertVC addAction:cancelAction];
        [self presentViewController:alertVC animated:YES completion:NULL];
        
        return;
    }
    
    
    //相机权限
    NSString *mediaType = AVMediaTypeVideo;
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提醒" message:@"没有摄像头权限" preferredStyle:UIAlertControllerStyleAlert];
        __weak typeof(self) weakSelf = self;
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }];
        [alertVC addAction:cancelAction];
        [self presentViewController:alertVC animated:YES completion:NULL];
        
        return;
        
    }
    
    
    [self configImg];
    [self configCamer];
  
    //开始捕获
    [_session startRunning];
    
    
}


- (void)configImg
{
    //扫描区域图片
    UIImageView *ne = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SKGuideBarBlue_NE"]];
    UIImageView *nw = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SKGuideBarBlue_NW"]];
    UIImageView *se = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SKGuideBarBlue_SE"]];
    UIImageView *sw = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SKGuideBarBlue_SW"]];
    
    CGFloat imgSize = ne.image.size.width/2;
    CGFloat size = kScreenWidth / 6 * 4;
//    ne.frame = CGRectMake(, , imgSize, imgSize);
    nw.center = CGPointMake(kScreenWidth/6+imgSize, kScreenHeight/4);
    ne.center = CGPointMake(kScreenWidth/6*5-imgSize, kScreenHeight/4);
    
    sw.center = CGPointMake(kScreenWidth/6+imgSize, kScreenHeight/4+size-imgSize);
    se.center = CGPointMake(kScreenWidth/6*5-imgSize, kScreenHeight/4+size-imgSize);
    
    [self.view addSubview:ne];
    [self.view addSubview:nw];
    [self.view addSubview:se];
    [self.view addSubview:sw];
    
}

- (void)configCamer
{
    //获取摄像设备
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //session
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    
    
    CGFloat size = kScreenWidth / 6 * 4;
    
//    [_output setRectOfInterest:CGRectMake(1.0/4,1.0/6,2.0/3,kScreenWidth/3*2/kScreenHeight)];
    //原点在屏幕右上角，   高,宽
    
    [_output setRectOfInterest:CGRectMake((64+kScreenHeight/4)/kScreenHeight,1.0/4,size/kScreenHeight,size/kScreenWidth)];
    NSLog(@"%@",NSStringFromCGRect(_output.rectOfInterest));
    
    
}


- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        NSString *result = metadataObj.stringValue;
        NSLog(@"%@",result);
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"扫描结果" message:result preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [_session startRunning];
        }];
        NSURL *url = [NSURL URLWithString:result];
        //扫描结果如果是网址
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            
            UIAlertAction *goAction = [UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:url];
            }];
            [alertVC addAction:goAction];
        }
        
        [alertVC addAction:cancelAction];
        [self presentViewController:alertVC animated:YES completion:NULL];
        [_session stopRunning];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
