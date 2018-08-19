//
//  XNLLocationManager.h
//  
//
//  Created by zzc on 2017/11/8.
//  Copyright © 2017年 zzc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, XNLLocationAuthorizationType) {
    XNLLocationAuthorizationTypeWhenUse = 0,
    XNLLocationAuthorizationTypeAlways
};

typedef void(^XNLLocationCompleteBlock)(CLLocation *location, NSError *error);

@interface XNLLocationManager : NSObject

@property (nonatomic, assign, readonly) CLLocationCoordinate2D lastCoordinate;

@property (nonatomic, copy, readonly) NSString *state;
@property (nonatomic, copy, readonly) NSString *city;
@property (nonatomic, copy, readonly) NSString *subLocality;
@property (nonatomic, copy, readonly) NSString *street;

AS_SINGLETON(XNLLocationManager)


- (void)location;

- (BOOL)canUseLocationWithAuthType:(XNLLocationAuthorizationType)authType;


//单次定位
- (void)startSingleLocationCompleteBlock:(XNLLocationCompleteBlock)completeBlock;

//使用时定位
- (void)startLocationWhenUse:(XNLLocationCompleteBlock)completeBlock;

//一直定位
- (void)startLocationAlways:(XNLLocationCompleteBlock)completeBlock;

@end
