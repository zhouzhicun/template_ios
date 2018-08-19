//
//  XNLDeviceModel.h
//  
//
//  Created by zzc on 2017/11/25.
//  Copyright © 2017年 zzc. All rights reserved.
//

#import "XNLBaseEntity.h"

@interface XNLDeviceModel : XNLBaseEntity

/** 设备名称 */
@property (nonatomic, copy) NSString *name;
/** 设备模型 */
@property (nonatomic, copy) NSString *model;
/** 发布日期 */
@property (nonatomic, copy) NSString *released;
/** 网络连接方式 */
@property (nonatomic, copy) NSString *connector;
/** 固件版本 */
@property (nonatomic, copy) NSString *firmware;
/** 芯片版本 */
@property (nonatomic, copy) NSString *arm;
/** 像素 */
@property (nonatomic, copy) NSString *pixels;
/** 矩阵点 */
@property (nonatomic, copy) NSString *points;
/** 图片比例 */
@property (nonatomic, copy) NSString *scale;
/** 尺寸 */
@property (nonatomic, copy) NSString *inches;


+ (NSArray *)deviceModelArr;

@end
