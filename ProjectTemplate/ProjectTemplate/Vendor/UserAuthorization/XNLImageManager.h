//
//  XNLImageManager.h
//  
//
//  Created by zzc on 2017/11/8.
//  Copyright © 2017年 zzc. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^XNLTakeImageCompleteBlock)(UIImage *image);


@interface XNLImageManager : NSObject

AS_SINGLETON(XNLImageManager)

- (void)takePhotoWithViewController:(UIViewController *)viewController
                      allowsEditing:(BOOL)allowsEditing
                      completeBlock:(XNLTakeImageCompleteBlock)completeBlock;


- (void)pickerPhotoWithViewController:(UIViewController *)viewController
                      allowsEditing:(BOOL)allowsEditing
                      completeBlock:(XNLTakeImageCompleteBlock)completeBlock;

@end
