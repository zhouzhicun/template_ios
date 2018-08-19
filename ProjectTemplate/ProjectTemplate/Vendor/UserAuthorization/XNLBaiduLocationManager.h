//
//  XNLLocationManager+BaiduSDK.h
//  
//
//  Created by zzc on 2018/7/3.
//  Copyright © 2018年 zzc. All rights reserved.
//

#import "XNLLocationManager.h"
#import <BMKLocationkit/BMKLocationComponent.h>

@interface XNLBaiduLocationManager : NSObject
<BMKLocationAuthDelegate, BMKLocationManagerDelegate>

@property (nonatomic, strong, readonly) BMKLocation *curLocation;   //当前位置信息

AS_SINGLETON(XNLBaiduLocationManager)


- (void)checkPermision;

- (void)location;

@end
