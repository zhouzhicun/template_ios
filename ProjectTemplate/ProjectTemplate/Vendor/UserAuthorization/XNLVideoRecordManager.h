//
//  XNLVideoRecord.h
//  
//
//  Created by zzc on 2017/11/8.
//  Copyright © 2017年 zzc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^XNLVideoRecordCompleteBlock)(NSData *video, float duration, float size, NSString *name);

@interface XNLVideoRecordManager : NSObject

AS_SINGLETON(XNLVideoRecordManager);

- (void)takeVideoWithViewController:(UIViewController *)viewController
                      completeBlock:(XNLVideoRecordCompleteBlock)completeBlock;

@end
