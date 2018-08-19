//
//  XNLVideoRecord.m
//  
//
//  Created by zzc on 2017/11/8.
//  Copyright © 2017年 zzc. All rights reserved.
//

#import "XNLVideoRecordManager.h"

#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/UTCoreTypes.h>

#import "UIViewController+XNLUnauthorized.h"

@interface XNLVideoRecordManager () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, copy) XNLVideoRecordCompleteBlock takeCompleteBlock;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@end

@implementation XNLVideoRecordManager

DEF_SINGLETON(XNLVideoRecordManager)

- (void)takeVideoWithViewController:(UIViewController *)viewController
                      completeBlock:(XNLVideoRecordCompleteBlock)completeBlock {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [viewController showCameraUnavailableAlert];
    }
    
    [self canUseCameraWithGrantedBlock:^{
        [self canUseAudioWithGrantedBlock:^{
            
            //录制视频
            self.takeCompleteBlock = completeBlock;
            self.imagePickerController = [self createImagePickerController];
            [viewController presentViewController:self.imagePickerController animated:YES completion:nil];
            
        } unGrantedBlock:^{
            //麦克风未授权
            [viewController showUnauthorizedAlertWithCategory:XNLAuthorizationCategoryMicro];
        }];
        
    } unGrantedBlock:^{
        //相机未授权
        [viewController showUnauthorizedAlertWithCategory:XNLAuthorizationCategoryCamera];
    }];
}


- (void)canUseCameraWithGrantedBlock:(void(^)(void))grantedBlock unGrantedBlock:(void(^)(void))unGrantedBlock {
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (granted) {
                        if (grantedBlock) grantedBlock();
                    } else {
                        if (unGrantedBlock) unGrantedBlock();
                    }
                });
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized: {
            if (grantedBlock) grantedBlock();
            break;
        }
            
    }
}

- (void)canUseAudioWithGrantedBlock:(void(^)(void))grantedBlock unGrantedBlock:(void(^)(void))unGrantedBlock {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (granted) {
                        if (grantedBlock) grantedBlock();
                    } else {
                        if (unGrantedBlock) unGrantedBlock();
                    }
                });
            }];
            break;
        }  
        case AVAuthorizationStatusAuthorized: {
            if (grantedBlock) grantedBlock();
            break;
        }
            
    }
}



#pragma mark - <UIImagePickerControllerDelegate>

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];//视频路径
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    float size = [data length] / 1024.f / 1024.f;
    
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:url];
    CMTime time = [avUrl duration];
    float seconds = (float)time.value / time.timescale;
    
    NSLog(@"%f", size);
    if (self.takeCompleteBlock) {
        self.takeCompleteBlock(data, seconds, size, url.lastPathComponent);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self reset];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self reset];
}



#pragma mark - Private

- (void)reset {
    self.takeCompleteBlock = nil;
    self.imagePickerController = nil;
}

- (UIImagePickerController *)createImagePickerController {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    NSString *requiredMediaType = ( NSString *)kUTTypeMovie;
    picker.mediaTypes = @[requiredMediaType];
    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    picker.videoQuality = UIImagePickerControllerQualityType640x480;
    picker.videoMaximumDuration = 10.0f;
    
    return picker;
}


@end
