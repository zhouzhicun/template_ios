//
//  XNLPagingEntity.h
//  
//
//  Created by zzc on 16/9/26.
//  Copyright © 2016年 . All rights reserved.
//

#import "XNLBaseViewModel.h"



typedef NS_ENUM(NSUInteger, XNLListViewType) {
    XNLListViewType_Normal,         //普通
    XNLListViewType_Refresh,        //可下拉刷新
    XNLListViewType_Paged,          //分页，下拉刷新+加载更多
};


@interface XNLBaseListViewModel : XNLBaseViewModel

//列表样式
@property (nonatomic, assign) XNLListViewType listType;

//数据
@property (nonatomic, strong, readonly) NSMutableArray *entityArr;



//停止刷新动画
@property (nonatomic, strong) RACSubject *endRefreshSignal;

//停止加载更多
@property (nonatomic, strong) RACSubject *endLoadMoreSignal;

//隐藏加载更多
@property (nonatomic, strong) RACSubject *hideLoadMoreSignal;




#pragma mark - Public

/**
 *  子类重写，返回三元组
 *  RACTuplePack(NSString(apiName), NSDictionary(params), Class(modelClass))
 *
 *  eg.
 *  - (RACTuple *)getRequestTuple {
 *      NSString *api = @"/creditorRight/list";
 *      NSDictionary *dict = @{@"orderId" : @(123456)};
 *      Class modelClass = AMBaseModel.class;
 *
 *      return RACTuplePack(api, dict, modelClass);
 *  }
 */
- (RACTuple *)fetchDataRequestTuple;

- (NSDictionary *)finalParamsDicForOriginParamsDic:(NSDictionary *)originParamsDic;

- (void)parsePageInfo:(NSDictionary *)dataDic;

- (void)parseData:(NSDictionary *)dataDic WithRefresh:(BOOL)isRefresh EntityCls:(Class)cls;


//请求数据
- (void)fetchDataWithRefresh:(BOOL)isRefresh;







@end
