//
//  XNLBaseResponse.m
//  
//
//  Created by zzc on 2018/6/28.
//  Copyright © 2018年 zzc. All rights reserved.
//

#import "XNLBaseResponse.h"

@interface XNLBaseResponse ()

//response和error
@property (nonatomic, strong) id response;
@property (nonatomic, strong) NSError *error;



@end

@implementation XNLBaseResponse


- (void)setReponse:(NSDictionary *)response error:(NSError *)error {
    
    if (error) {
        self.response = nil;
        self.error = [self convertError:error];
    } else {
        RACTuple *tuple = [self convertResponse:response];
        self.response = tuple.first;
        self.error = tuple.second;
    }
}

//解析Response数据
- (RACTuple *)convertResponse:(NSDictionary *)response {
    return RACTuplePack(response, nil);
}

- (NSError *)convertError:(NSError *)error {
    return [NSError ss_convertError:error];
}

@end
