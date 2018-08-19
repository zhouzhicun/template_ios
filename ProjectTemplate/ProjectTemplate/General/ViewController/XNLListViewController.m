//
//  XNLViewController.m
//  
//
//  Copyright © 2015年 . All rights reserved.
//

#import "XNLListViewController.h"


@interface XNLListViewController ()

@end


@implementation XNLListViewController


#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //默认隐藏下拉刷新和加载更多
    self.hideHeaderRefresh  = YES;
    self.hideFooterLoadMore = YES;
}


- (void)setupSubView {
    
    [super setupSubView];
    
    //配置下拉刷新，加载更多
    [self setupMJRefresh];
    
}

- (void)setupBinding {
    [super setupBinding];
    
    XNLBaseListViewModel *viewModel = (XNLBaseListViewModel *)self.viewModel;
    
    @weakify(self);
    [[viewModel.endRefreshSignal deliverOnMainThread] subscribeNext:^(id x) {
        
        //停止下拉刷新动画
        @strongify(self);
        [self endRefreshing];
    }];
    
    [[viewModel.endLoadMoreSignal deliverOnMainThread] subscribeNext:^(id x) {

        //停止加载更多动画
        @strongify(self);
        [self endLoadMore];

    }];
    
    [[viewModel.hideLoadMoreSignal deliverOnMainThread] subscribeNext:^(NSNumber *hidden) {
        
        //是否隐藏LoadMore
        @strongify(self);
        self.hideFooterLoadMore = hidden.boolValue;
    }];
    
    [[viewModel.successSubject deliverOnMainThread] subscribeNext:^(id x) {
        
        //请求成功
        @strongify(self);
        [self.tableView reloadData];
    }];

}


- (void)setupMJRefresh {
    
    @weakify(self);
    
    //header
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        //下拉刷新
        @strongify(self);
        if (self.beginRefreshBlock) {
            self.beginRefreshBlock();
        }
        [self requestHandlerWithRefresh:YES];
    }];
    
    header.stateLabel.hidden = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.arrowView.image = [UIImage imageNamed:@"global_Refresh_down"];
    header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    header.automaticallyChangeAlpha = YES;
    
    UIActivityIndicatorView *activity = [header valueForKey:@"loadingView"];
    activity.color = HEXCOLOR(0x506FEE);
    
    //footer
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        //加载更多
        @strongify(self);
        if (self.loadMoreBlock) {
            self.loadMoreBlock();
        }
        [self requestHandlerWithRefresh:NO];
    }];
    
//    self.tableView.mj_header.updatedTimeHidden = YES;
//    [self.tableView.header setTitle:kTableViewRefreshTextHeaderIdle forState:MJRefreshHeaderStateIdle];
//    [self.tableView.header setTitle:kTableViewRefreshTextHeaderPulling forState:MJRefreshHeaderStatePulling];
//    [self.tableView.header setTitle:kTableViewRefreshTextHeaderRefreshing forState:MJRefreshHeaderStateRefreshing];
//    [self.tableView.header setTextColor:kTitleTextColor];
//    [self.tableView.header setFont:[UIFont systemFontOfSize:13.0f]];
//    [self.tableView.footer setTitle:kTableViewRefreshTextFooterRefreshing forState:MJRefreshFooterStateRefreshing];
//    [self.tableView.footer setTextColor:kTitleTextColor];
//    [self.tableView.footer setFont:[UIFont systemFontOfSize:13.0f]];
    
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
    
    self.tableView.mj_header.hidden = NO;
    self.tableView.mj_footer.hidden = YES;
}





#pragma mark - Public Methods

#pragma mark -- 请求
- (void)requestHandlerWithRefresh:(BOOL)isRefresh {
    
    XNLBaseListViewModel *viewModel = (XNLBaseListViewModel *)self.viewModel;
    [viewModel fetchDataWithRefresh:isRefresh];
}

- (void)reloadData {
    
    [self.tableView setContentOffset:CGPointZero];
    [self beginRefreshing];

    //重新加载数据
    [self requestHandlerWithRefresh:YES];
}


#pragma mark -- 下拉刷新动画

- (void)beginRefreshing {
    [self.tableView.mj_header beginRefreshing];
}

- (void)endRefreshing {
    [self.tableView.mj_header endRefreshing];
}

- (void)endLoadMore {
    [self.tableView.mj_footer endRefreshing];
}



#pragma mark - Accessor

/* 隐藏下拉刷新 */
- (void)setHideHeaderRefresh:(BOOL)hideHeaderRefresh {
    
    _hideHeaderRefresh = hideHeaderRefresh;
    self.tableView.mj_header.hidden = hideHeaderRefresh;
}

/* 隐藏加载更多 */
- (void)setHideFooterLoadMore:(BOOL)hideFooterLoadMore {
    
    _hideFooterLoadMore = hideFooterLoadMore;
    self.tableView.mj_footer.hidden = hideFooterLoadMore;
}


@end


