//
//  XNLCycleScrollView.m
//  
//
//  Created by fdd_zzc on 15/4/28.
//  Copyright (c) 2015年 fdd. All rights reserved.
//

#import "XNLCycleScrollView.h"
#import "NSTimer+SSToolkitAdditions.h"

#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface XNLCycleScrollView () <UIScrollViewDelegate>

@property (nonatomic, copy) NSArray *dataArr;
@property (nonatomic, strong) UIImage *defaultImage;  //默认图

@property (nonatomic, assign) NSInteger totalPageCount;
@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *originContentViews;
@property (nonatomic, strong) NSMutableArray *contentViews;

@property (nonatomic, strong) NSTimer *animationTimer;
@property (nonatomic, assign) NSTimeInterval animationDuration;

@end

@implementation XNLCycleScrollView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createScrollView];
        [self createPageControl];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration
{
    self = [self initWithFrame:frame];
    if (animationDuration > 0.0) {
        //创建定时器，并暂停
        [self createTimerWithAnimationDuration:animationDuration];
        [self.animationTimer ss_pauseTimer];
    }
    return self;
}


#pragma mark - Private

- (void)createScrollView {

    CGRect scrollFrame = self.bounds;
    self.scrollView = [[UIScrollView alloc] initWithFrame:scrollFrame];
    self.scrollView.contentMode = UIViewContentModeCenter;

    //总共三个，并居中。
    self.scrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(scrollFrame), 0);
    self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(scrollFrame), 0);
    
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    
    [self addSubview:self.scrollView];
}

- (void)createPageControl {
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGSize pageSize = CGSizeMake(120, 25);
    CGRect pageFrame = CGRectZero;
    pageFrame.origin = CGPointMake((width - pageSize.width) / 2.0, height - pageSize.height);
    pageFrame.size = pageSize;

    self.pageControl = [[UIPageControl alloc] initWithFrame:pageFrame];
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.backgroundColor = [UIColor clearColor];
    [self addSubview:self.pageControl];
    
    self.pageControl.numberOfPages  = 3;  //默认为3
    self.pageControl.currentPage    = 0;
    self.currentPageIndex = 0;
    
}

- (void)createTimerWithAnimationDuration:(NSTimeInterval)animationDuration {
    
    self.animationDuration = animationDuration;
    self.animationTimer =
    [NSTimer scheduledTimerWithTimeInterval:animationDuration
                                     target:self
                                   selector:@selector(animationTimerDidFired:)
                                   userInfo:nil
                                    repeats:YES];
    
    //[[NSRunLoop currentRunLoop] addTimer:self.animationTimer forMode:NSRunLoopCommonModes];
}






//配置CycleView数据源
- (void)setupCycleViewWithDataArr:(NSArray *)dataArr defaultImage:(UIImage *)defaultImage {
    

    self.dataArr = dataArr;
    NSInteger count = self.dataArr.count;
    
    self.currentPageIndex = 0;
    self.totalPageCount = count;
    self.pageControl.numberOfPages = count;
    
    self.originContentViews = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < count; ++i) {
        NSString *url = self.dataArr[i];
        [self.originContentViews addObject:[self createContentViewWithUrl:url defaultImage:defaultImage]];
    }
    
    if (count == 0) {
        //0张，显示默认图
        [self.originContentViews addObject:[self createContentViewWithUrl:nil defaultImage:defaultImage]];
    } else if (count == 2) {
        
        //两张，则把这两张再重复添加一次，保证可正常获取上一张，下一张。
        for (int i = 0; i < count; ++i) {
            NSString *url = self.dataArr[i];
            [self.originContentViews addObject:[self createContentViewWithUrl:url defaultImage:defaultImage]];
        }
    }
    
    //2 根据count是否显示pageControl以及是否滚动
    if (count <= 1) {
        
        //只有1张，直接添加到self上，并隐藏pageControl和停止计时器
        [self addContentView:self.originContentViews[0] index:0 toSuperView:self];
        [self enableCycleScroll:NO];
    } else {
        //1张以上
        [self configContentViews];
        [self enableCycleScroll:YES];
    }
    

}



#pragma mark - 开始，停止滚动

- (void)startScroll
{
    if ([self.originContentViews count] > 1) {
        [self.animationTimer ss_resumeTimerAfterTimeInterval:self.animationDuration];
    }
}

- (void)stopScroll
{
    if ([self.originContentViews count] > 1) {
        [self.animationTimer ss_pauseTimer];
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * 2, 0) animated:YES];
    }
}

#pragma mark - Private

- (UIImageView *)createContentViewWithUrl:(NSString *)url defaultImage:(UIImage *)defaultImage {
    
    CGSize size = self.bounds.size;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    if (url.length > 0) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:url]
                     placeholderImage:defaultImage
                              options:SDWebImageRetryFailed | SDWebImageRefreshCached];
    } else {
        imageView.image = defaultImage;
    }
    return imageView;
}

//是否可轮播
- (void)enableCycleScroll:(BOOL)enable {
    
    [self.scrollView setScrollEnabled:enable];
    [self.pageControl setHidden:!enable];
    if (enable) {
        [self.animationTimer ss_resumeTimerAfterTimeInterval:self.animationDuration];
    } else {
        [self.animationTimer ss_pauseTimer];
    }
}

//添加contentView到父view
- (void)addContentView:(UIView *)contentView index:(NSInteger)index toSuperView:(UIView *)superView
{
    contentView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContentViewAction:)];
    [contentView addGestureRecognizer:tapGesture];
    
    CGRect rightRect = contentView.frame;
    rightRect.origin = CGPointMake(CGRectGetWidth(self.scrollView.frame) * index, 0);
    
    contentView.frame = rightRect;
    [superView addSubview:contentView];
}

- (void)tapContentViewAction:(UITapGestureRecognizer *)tap {
    
    NSNumber *index = nil;
    if (self.totalPageCount > 0) {
        index = @(self.currentPageIndex % self.totalPageCount);  //total = 2时，重复添加两张，所以这里取余。
    }
    
    if (self.tapActionBlock) {
        self.tapActionBlock(index);
    }
}



#pragma mark -

//设置contentViews
- (void)configContentViews
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setScrollViewContentDataSource];
    
    for (int i = 0; i < [self.contentViews count]; ++i) {
        [self addContentView:self.contentViews[i] index:i toSuperView:self.scrollView];
    }
    [self.scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}


/**
 *  设置scrollView的content数据源，即contentViews
 */
- (void)setScrollViewContentDataSource
{
    self.contentViews = [NSMutableArray arrayWithCapacity:0];
    NSInteger prevPageIndex = [self getValidPageIndexWithPageIndex:self.currentPageIndex - 1];
    NSInteger nextPageIndex = [self getValidPageIndexWithPageIndex:self.currentPageIndex + 1];
    [self.contentViews addObject:self.originContentViews[prevPageIndex]];
    [self.contentViews addObject:self.originContentViews[self.currentPageIndex]];
    [self.contentViews addObject:self.originContentViews[nextPageIndex]];
}

- (NSInteger)getValidPageIndexWithPageIndex:(NSInteger)currentPageIndex
{
    NSInteger count = self.originContentViews.count;
    if(currentPageIndex == -1) {
        return count - 1;
    } else if (currentPageIndex == count) {
        return 0;
    } else {
        return currentPageIndex;
    }
}


#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //开始拖动
    [self.animationTimer ss_pauseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //结束拖动
    [self.animationTimer ss_resumeTimerAfterTimeInterval:self.animationDuration];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int contentOffsetX = scrollView.contentOffset.x;
    if(contentOffsetX >= (2 * CGRectGetWidth(scrollView.frame))) {
        self.currentPageIndex = [self getValidPageIndexWithPageIndex:self.currentPageIndex + 1];
        [self configContentViews];
    } else if(contentOffsetX <= 0) {
        self.currentPageIndex = [self getValidPageIndexWithPageIndex:self.currentPageIndex - 1];
        [self configContentViews];
    }
    
    NSInteger count = self.totalPageCount;
    if (count > 0) {
        self.pageControl.currentPage = self.currentPageIndex % count;
    } else {
        self.pageControl.currentPage = 0;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //滚动结束
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
}

#pragma mark -
#pragma mark - 响应事件

- (void)animationTimerDidFired:(NSTimer *)timer
{
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:newOffset animated:YES];
}

@end
