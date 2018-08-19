//
//  XNLBaseEntity.m
//  
//
//  Copyright © 2015年 . All rights reserved.
//



#import "XNLBaseEntity.h"

@implementation XNLBaseEntity

//解析单个Entity
+ (nullable instancetype)parserEntityWithDictionary:(nullable NSDictionary *)dictionary {
    
    if(!dictionary || ![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [self yy_modelWithJSON:dictionary];
}


//解析Entity数组
+ (NSMutableArray *)parserEntityArrayWithArray:(NSArray *)arr {
    
    if(!arr || ![arr isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *resultArr = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        XNLBaseEntity *entity = [self parserEntityWithDictionary:dic];
        if (entity){
            [resultArr addObject:entity];
        }
    }
    
    return resultArr;
}


#pragma mark - NSCoder & NSCopy


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self yy_modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self yy_modelCopy];
}

- (NSUInteger)hash
{
    return [self yy_modelHash];
}

- (BOOL)isEqual:(id)object
{
    return [self yy_modelIsEqual:object];
}

@end

