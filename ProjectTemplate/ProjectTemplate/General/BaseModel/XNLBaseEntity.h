//
//  XNLBaseEntity.h
//  
//
//  Copyright © 2015年 . All rights reserved.
//

#import <YYModel/YYModel.h>
#import <Foundation/Foundation.h>

@interface XNLBaseEntity : NSObject<NSCopying, NSCoding>

//字典转换为Model
+ (instancetype)parserEntityWithDictionary:(NSDictionary *)dictionary;

//字典数组转换为Model数组
+ (NSMutableArray *)parserEntityArrayWithArray:(NSArray *)arr;

@end

#import "XNLBaseEntity+cell.h"
