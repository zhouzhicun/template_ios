//
//  XNLDeviceModel.m
//  
//
//  Created by zzc on 2017/11/25.
//  Copyright © 2017年 zzc. All rights reserved.
//

#import "XNLDeviceModel.h"

/*
 * ref: https://www.innerfence.com/howto/apple-ios-devices-dates-versions-instruction-sets
 */

@implementation XNLDeviceModel

+ (NSArray *)deviceModelArr {
    NSData *jsonData =
    [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"device" ofType:@"json"]];
    
    NSArray *deviceArr =
    [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    
    return [XNLDeviceModel parserEntityArrayWithArray:deviceArr];
}


@end
