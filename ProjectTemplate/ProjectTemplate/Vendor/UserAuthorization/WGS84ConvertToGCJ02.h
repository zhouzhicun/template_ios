//
//  WGS84ConvertToGCJ02.h
//  ZZCMShadow
//
//  Created by PasserMontanus on 2017/4/15.
//  Copyright © 2017年 麻雀. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface WGS84ConvertToGCJ02 : NSObject

//判断是否已经超出中国范围
+(BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location;
//转GCJ-02
+(CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc;

@end
