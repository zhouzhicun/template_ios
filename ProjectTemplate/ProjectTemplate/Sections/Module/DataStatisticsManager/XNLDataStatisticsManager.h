//
//  XNODataStatisticsManager.h
//  
//
//  Copyright © 2016年 . All rights reserved.
//

#import "XNLDataStatisticsUMengTypeString.h"


@interface XNLDataStatisticsManager : NSObject


AS_SINGLETON(XNLDataStatisticsManager)

/*
 友盟统计 操作类型为 点击
 @param eventID 统计事件ID
 */
- (void)reportWithEventID:(NSString *)eventID;


@end
