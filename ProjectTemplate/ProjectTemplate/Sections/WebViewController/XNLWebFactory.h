//
//  XNLWebFactory.h
//  
//
//  Created by zzc on 2017/11/20.
//  Copyright © 2017年 zzc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XNLBaseViewController.h"

@interface XNLWebFactory : NSObject

//访问URL
+ (void)redirectURL:(NSString *)url
              curVC:(XNLBaseViewController *)curVC;

//访问本地文档
+ (void)redirectFileName:(NSString *)fileName
               extension:(NSString *)extension
                   curVC:(XNLBaseViewController *)curVC;


@end
