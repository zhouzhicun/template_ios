//
//  XNLRequestParameterConfiguration.h
//  XNLoan
//
//  Created by zzc on 16/7/13.
//  Copyright © 2016年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNLRequestParameter : NSObject

#pragma mark - Public

+ (NSMutableDictionary *)headerParameters;

+ (NSMutableDictionary *)handleParameters:(NSDictionary *)parameters;

@end
