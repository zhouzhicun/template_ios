//
//  XNLImageManager.m
//  
//
//  Created by zzc on 2017/11/8.
//  Copyright © 2017年 zzc. All rights reserved.
//

#import "XNLImageManager.h"

#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/UTCoreTypes.h>

#import "UIViewController+XNLUnauthorized.h"

@interface XNLImageManager () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, copy) XNLTakeImageCompleteBlock takeCompleteBlock;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@end

@implementation XNLImageManager

DEF_SINGLETON(XNLImageManager)


#pragma mark - 拍照

- (void)takePhotoWithViewController:(UIViewController *)viewController
                      allowsEditing:(BOOL)allowsEditing
                      completeBlock:(XNLTakeImageCompleteBlock)completeBlock {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [viewController showCameraUnavailableAlert];
    }
    
    [self canUseCameraWithGrantedBlock:^{
        
        //拍照
        self.takeCompleteBlock = completeBlock;
        self.imagePickerController = [self createImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        self.imagePickerController.allowsEditing = allowsEditing;
        [viewController presentViewController:self.imagePickerController animated:YES completion:nil];
        
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


#pragma mark - 从图库中获取图片


- (void)pickerPhotoWithViewController:(UIViewController *)viewController
                      allowsEditing:(BOOL)allowsEditing
                      completeBlock:(XNLTakeImageCompleteBlock)completeBlock {
    
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [viewController showCameraUnavailableAlert];
    }
    
    [self canUsePhotoLibraryWithGrantedBlock:^{
        
        //从图库中获取图片
        self.takeCompleteBlock = completeBlock;
        self.imagePickerController = [self createImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        self.imagePickerController.allowsEditing = allowsEditing;
        [viewController presentViewController:self.imagePickerController animated:YES completion:nil];
        
        
    } unGrantedBlock:^{
        //相机未授权
        [viewController showUnauthorizedAlertWithCategory:XNLAuthorizationCategoryPhoto];
    }];
}

- (void)canUsePhotoLibraryWithGrantedBlock:(void(^)(void))grantedBlock unGrantedBlock:(void(^)(void))unGrantedBlock {
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        
        switch (status) {
            case PHAuthorizationStatusNotDetermined:
            case PHAuthorizationStatusRestricted:
            case PHAuthorizationStatusDenied: {
                
                //未授权
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (unGrantedBlock) unGrantedBlock();
                });
                break;
            }
            case PHAuthorizationStatusAuthorized: {
                
                //已授权
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (grantedBlock) grantedBlock();
                });
                break;
            }
        }
        
        
    }];
}






#pragma mark - <UIImagePickerControllerDelegate>

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image;
    if (picker.allowsEditing) {
        image = info[UIImagePickerControllerEditedImage];
    }
    else {
        image = info[UIImagePickerControllerOriginalImage];
    }
    
    if (self.takeCompleteBlock) {
        self.takeCompleteBlock(image);
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

- (UIImagePickerController *)createImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = sourceType;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    }
    return picker;
}



@end
