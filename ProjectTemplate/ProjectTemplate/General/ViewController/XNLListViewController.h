//
//  XNLViewController.h
//  
//
//  Copyright © 2015年 . All rights reserved.
//

#import "XNLViewController.h"
#import "XNLBaseTableViewCell.h"

#import "XNLBaseListViewModel.h"

typedef void (^XNLListViewBeginRefreshBlock)(void);
typedef void (^XNLListViewLoadMoreBlock)(void);


/**
 *  所有列表页都继承此类，默认有下拉刷新，没有上拉加载更多
 *  
 *  打开下拉刷新 self.hideHeaderRefresh = NO;
 *  打开上拉更多 self.hideFooterLoadMore = NO;
 */
@interface XNLListViewController : XNLViewController

/* 下拉刷新前执行block */
@property (nonatomic, copy) XNLListViewBeginRefreshBlock beginRefreshBlock;

/* 上拉加载更多前执行block */
@property (nonatomic, copy) XNLListViewLoadMoreBlock loadMoreBlock;


/* 是否隐藏下拉刷新 */
@property (nonatomic, assign) BOOL hideHeaderRefresh;

/* 是否隐藏上拉加载更多 */
@property (nonatomic, assign) BOOL hideFooterLoadMore;


/**
 *  恢复列表状态，滚动到顶部，currentPage变回1，自动调用请求
 */
- (void)reloadData;


@end

