//
//  XNODataStatisticsManager.m
//  
//
//  Copyright © 2016年 . All rights reserved.
//

#import "XNLDataStatisticsManager.h"
#import <UMAnalytics/MobClick.h>

@interface XNLDataStatisticsManager ()

@end

@implementation XNLDataStatisticsManager

DEF_SINGLETON(XNLDataStatisticsManager);

- (void)reportWithEventID:(NSString *)eventID {
    [MobClick event:eventID];
}

@end
