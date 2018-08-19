//
//  XNLPagingEntity.m
//  
//
//  Created by zzc on 16/9/26.
//  Copyright © 2016年 . All rights reserved.
//

#import "XNLBaseListViewModel.h"

@interface XNLBaseListViewModel ()

//数据
@property (nonatomic, strong) NSMutableArray *entityArr;




#pragma mark - 分页
@property(nonatomic, assign) NSInteger pageIndex;        //页序号
@property(nonatomic, assign) NSInteger pageSize;         //页大小
@property(nonatomic, assign) NSInteger pageCount;        //页总数
@property(nonatomic, assign) NSInteger totalCount;       //记录总数


//是否还有更多数据
- (BOOL)hasMoreData;

@end

@implementation XNLBaseListViewModel



- (void)commonInit {
    
    [super commonInit];
    
    [self initSubject];
    [self initPageInfo];
}

- (void)initPageInfo
{
    //根据业务需求
    self.pageIndex  = 1;
    self.pageSize   = 20;
    self.pageCount  = 0; 
    self.totalCount = 0;
}

- (void)initSubject {
    self.endRefreshSignal = [RACSubject subject];
    self.endLoadMoreSignal = [RACSubject subject];
    self.hideLoadMoreSignal = [RACSubject subject];
}


#pragma mark - Public

- (RACTuple *)fetchDataRequestTuple {

    return nil;
}


- (NSDictionary *)finalParamsDicForOriginParamsDic:(NSDictionary *)originParamsDic {
    
    //默认实现
    NSMutableDictionary *finalParamDic = [NSMutableDictionary dictionary];
    if (originParamsDic && originParamsDic.count > 0) {
        [finalParamDic addEntriesFromDictionary:originParamsDic];
    }

    //添加分页参数
    if (self.listType == XNLListViewType_Paged) {
        finalParamDic[@"pageIndex"] = @(self.pageIndex);
        finalParamDic[@"pageSize"] = @(self.pageSize);
    }
    return finalParamDic;
}


- (void)parsePageInfo:(NSDictionary *)dataDic {
    
    //默认实现
    self.pageIndex  = [dataDic[@"pageIndex"] integerValue];
    self.pageSize   = [dataDic[@"pageSize"] integerValue];
    self.pageCount  = [dataDic[@"pageCount"] integerValue];
    self.totalCount = [dataDic[@"totalCount"] integerValue];
    
}

- (void)parseData:(NSDictionary *)dataDic WithRefresh:(BOOL)isRefresh EntityCls:(Class)cls {
    
    //刷新，清空数组
    if (isRefresh) {
        [self.entityArr removeAllObjects];
    }
    
    //默认实现
    //解析datas为entity对象数组
    NSArray *arr = nil;
    SEL methodSEL = NSSelectorFromString(@"parserEntityWithDictionary:");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([cls respondsToSelector:methodSEL]) {
        arr = [cls performSelector:methodSEL withObject:dataDic[@"datas"]];
    }
#pragma clang diagnostic pop

    if (arr.count > 0) {
        [self.entityArr addObjectsFromArray:arr];
    }
}




- (void)fetchDataWithRefresh:(BOOL)isRefresh {
    
    [self resetPageInfoWithRefresh:isRefresh];
    
    RACTuple *tuple = [self fetchDataRequestTuple];
    NSString *api           = tuple.first;
    NSDictionary *paramDic  = tuple.second;
    Class entityCls         = tuple.third;
    
    @weakify(self);
    XNLRequest *request =
    [XNLRequest requestWithApi:api requestParams:[self finalParamsDicForOriginParamsDic:paramDic]];
    [[XNLConnectManager sharedInstance] sendRequest:request completeBlock:^(XNLBaseResponse *response) {
        
        @strongify(self);
        
        //停止动画
        [self endAnimationWithRefresh:isRefresh];
        
        if (response.error) {
            //失败
            [self.errorSubject sendNext:(RACTuplePack(api, response.error))];
        } else {
            
            //请求成功
            NSDictionary *resp = (NSDictionary *)response.response;
            
            //1. 解析分页信息
            [self parsePageInfo:resp];
            
            //2. 解析数据
            [self parseData:resp WithRefresh:isRefresh EntityCls:entityCls];
            
            //3. 发送信号
            if ([self hasMoreData]) {
                [self.hideLoadMoreSignal sendNext:@(NO)];
            } else {
                [self.hideLoadMoreSignal sendNext:@(YES)];
            }
            [self.successSubject sendNext:(RACTuplePack(api, nil))];
        }
    }];
}


#pragma mark - Private

- (BOOL)hasMoreData
{
    return self.pageCount > self.pageIndex;
}

//重置分页状态数据
- (void)resetPageInfoWithRefresh:(BOOL)isRefresh {
    
    if (self.listType == XNLListViewType_Paged) {
        //分页
        if (isRefresh) {
            [self initPageInfo];
        } else {
            self.pageIndex++;
        }
    }
}

//停止动画
- (void)endAnimationWithRefresh:(BOOL)isRefresh {
    if (isRefresh) {
        //下拉刷新
        if (self.listType == XNLListViewType_Refresh ||
            self.listType == XNLListViewType_Paged) {
            [self.endRefreshSignal sendNext:@(1)];
        }
    } else {
        //加载更多
        if (self.listType == XNLListViewType_Paged) {
            [self.endLoadMoreSignal sendNext:@(1)];
        }
    }
}




#pragma mark - Property

- (NSMutableArray *)entityArr {
    if (!_entityArr) {
        _entityArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _entityArr;
}


@end
