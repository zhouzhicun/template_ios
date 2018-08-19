//
//  XNLBaseResponse.h
//  
//
//  Created by zzc on 2018/6/28.
//  Copyright © 2018年 zzc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSError+XNNetwork.h"


@interface XNLBaseResponse : NSObject

//来源于请求
@property (nonatomic, strong) Class entityClass;
@property (nonatomic, assign) XNLRequestActionType actionType;          //请求行为类型

//response和error
@property (nonatomic, strong, readonly) id response;
@property (nonatomic, strong, readonly) NSError *error;


- (void)setReponse:(NSDictionary *)response error:(NSError *)error;


#pragma mark - 子类重写

//解析Response数据
- (RACTuple *)convertResponse:(NSDictionary *)response;

- (NSError *)convertError:(NSError *)error;

@end
