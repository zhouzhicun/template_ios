//
//  XNQRCodeScanViewController.m
//  
//
//  Created by zzc on 2018/7/3.
//  Copyright © 2018年 zzc. All rights reserved.
//

#import "XNQRCodeScanViewController.h"
#import <SGQRCode.h>

#import "XNLWebConstants.h"

@interface XNQRCodeScanViewController () <SGQRCodeScanManagerDelegate, SGQRCodeAlbumManagerDelegate>
@property (nonatomic, strong) SGQRCodeScanManager *manager;
@property (nonatomic, strong) SGQRCodeScanningView *scanningView;
@property (nonatomic, strong) UILabel *promptLabel;

@end

@implementation XNQRCodeScanViewController


- (void)dealloc {
    [self removeScanningView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"二维码扫描";
    
    self.view.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.scanningView];
    [self.view addSubview:self.promptLabel];
   // [self configNavigationBarRightButton];
    
    
    [self setupQRCodeScanManager];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanningView addTimer];
    [_manager startRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanningView removeTimer];
}


#pragma mark - Private

- (void)configNavigationBarRightButton
{

    CGFloat offset = 14;
    
    @weakify(self);
    [self ss_addBarButtonWithTitle:@"相册"
                              font:scaleFontSize(16)
                       normalColor:[UIColor blueColor]
                    highLightColor:[UIColor blueColor]
                 barButtonItemType:SSBarButtonItemTypeRight
                            offset:offset
                      pressedBlock:^(UIButton *button) {
                          @strongify(self);
                          [self scanFromPhoto];
                      }];
}


- (void)removeScanningView {
    [self.scanningView removeTimer];
    [self.scanningView removeFromSuperview];
    self.scanningView = nil;
}

- (void)scanFromPhoto {
    
    SGQRCodeAlbumManager *manager = [SGQRCodeAlbumManager sharedManager];
    [manager readQRCodeFromAlbumWithCurrentController:self];
    manager.delegate = self;

    if (manager.isPHAuthorization == YES) {
        [self.scanningView removeTimer];
    }
}

- (void)setupQRCodeScanManager {
    
    self.manager = [SGQRCodeScanManager sharedManager];
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    // AVCaptureSessionPreset1920x1080 推荐使用，对于小型的二维码读取率较高
    [_manager setupSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:arr currentController:self];
    [_manager cancelSampleBufferDelegate];
    _manager.delegate = self;
}


- (void)notifyQRCodeScanResultWithContent:(NSString *)content {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic ss_setObject:content forKey:@"content"];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kXNNotifyName_QRCodeScanResult object:nil userInfo:dic];
}


#pragma mark - - - SGQRCodeAlbumManagerDelegate

- (void)QRCodeAlbumManagerDidCancelWithImagePickerController:(SGQRCodeAlbumManager *)albumManager {
    [self.view addSubview:self.scanningView];
}
- (void)QRCodeAlbumManager:(SGQRCodeAlbumManager *)albumManager didFinishPickingMediaWithResult:(NSString *)result {
    //识别成功
    NSLog(@"成功, content = %@", result);
    [self notifyQRCodeScanResultWithContent:result];
    
}
- (void)QRCodeAlbumManagerDidReadQRCodeFailure:(SGQRCodeAlbumManager *)albumManager {
    //识别失败
    [self showToastWithText:@"暂未识别出扫描的二维码"];
}



#pragma mark - - - SGQRCodeScanManagerDelegate

- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects {
    
    NSLog(@"metadataObjects - - %@", metadataObjects);
    if (metadataObjects != nil && metadataObjects.count > 0) {
        [scanManager playSoundName:@"SGQRCode.bundle/sound.caf"];
        [scanManager stopRunning];

        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        NSString *content = [obj stringValue];
        
        NSLog(@"成功, content = %@", content);
        [self backButtonPressed:nil];
        [self notifyQRCodeScanResultWithContent:content]; 
    } else {
        //识别失败
        [self showToastWithText:@"暂未识别出扫描的二维码"];
    }
}


#pragma mark - Property

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        CGFloat promptLabelX = 0;
        CGFloat promptLabelY = 0.73 * self.view.frame.size.height;
        CGFloat promptLabelW = self.view.frame.size.width;
        CGFloat promptLabelH = 25;
        _promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _promptLabel.text = @"将二维码/条码放入框内, 即可自动扫描";
    }
    return _promptLabel;
}


- (SGQRCodeScanningView *)scanningView {
    if (!_scanningView) {
        _scanningView = [[SGQRCodeScanningView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _scanningView.scanningImageName = @"SGQRCode.bundle/QRCodeScanningLineGrid";
        _scanningView.scanningAnimationStyle = ScanningAnimationStyleGrid;
        _scanningView.cornerColor = [UIColor orangeColor];
    }
    return _scanningView;
}


@end
