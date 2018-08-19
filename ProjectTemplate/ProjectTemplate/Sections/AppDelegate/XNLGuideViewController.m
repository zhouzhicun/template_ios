//
//  XNLGuideViewController.m
//  
//
//  Copyright (c) 2015年 . All rights reserved.
//

#import "XNLGuideViewController.h"

#import "XNLUtils.h"

#import "AppDelegate.h"
#import "TAPageControl.h"

NS_ASSUME_NONNULL_BEGIN

@interface XNLGuideViewController () <UIScrollViewDelegate>

//Views
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) TAPageControl *pageControl;

//Parameters
@property (nonatomic, strong) NSArray <NSString *> *imageNameArray;
@property (nonatomic, strong) NSMutableArray *viewControllerArray;

@end

@implementation XNLGuideViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupLayout];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

#pragma mark - Private Methods
- (void)setupLayout
{
    NSInteger count = self.imageNameArray.count;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.bounces = NO;
    self.scrollView.directionalLockEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    CGSize scrollViewContentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds) * count, CGRectGetHeight(self.scrollView.bounds));
    [self.scrollView setContentSize:scrollViewContentSize];
    [self.view addSubview:self.scrollView];
    
    CGFloat originY = scaleY(505.0f);
    self.pageControl = [[TAPageControl alloc] initWithFrame:CGRectMake(0.0f, originY, CGRectGetWidth(self.view.bounds), 20.0f)];
    self.pageControl.numberOfPages = count;
    
    
    UIColor *dotColor = HEXCOLOR(0xd14a65);
    UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
    dotView.backgroundColor = [UIColor clearColor];
    dotView.layer.cornerRadius = CGRectGetWidth(dotView.bounds) / 2.0f;
    dotView.layer.borderColor = dotColor.CGColor;
    dotView.layer.borderWidth = 0.5f;
    dotView.clipsToBounds = YES;
    
    UIView *currentDotView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
    currentDotView.backgroundColor = dotColor;
    currentDotView.layer.cornerRadius = CGRectGetWidth(currentDotView.bounds) / 2.0f;
    currentDotView.clipsToBounds = YES;
    
    self.pageControl.dotImage = [UIImage ss_captureView:dotView];
    self.pageControl.currentDotImage = [UIImage ss_captureView:currentDotView];
//    [self.view addSubview:self.pageControl];
    
    [self loadScrollViewWithPage:0];
}

#pragma mark - Private Methods
- (void)loadScrollViewWithPage:(NSInteger)page
{
    NSInteger count = self.imageNameArray.count;
    if (page < 0) {
        return;
    }
    if (page >= count) {
        return;
    }
    
    XNLGuideImageViewController *viewController = self.viewControllerArray[page];
    
    if ((NSNull *)viewController == [NSNull null]) {
        viewController = [[XNLGuideImageViewController alloc] initWithPageNumber:page imageArray:self.imageNameArray];
        [self.viewControllerArray replaceObjectAtIndex:page withObject:viewController];
    }
    
    if (!viewController.view.superview) {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * page;
        viewController.view.frame = frame;
        [self.scrollView addSubview:viewController.view];
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    self.pageControl.currentPage = page;
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
}

#pragma mark - Lazy Properties
- (NSArray <NSString *> *)imageNameArray
{
    if (!_imageNameArray) {
        if (iPhoneX()) {
            _imageNameArray = @[@"guide_0_X.png", @"guide_1_X.png", @"guide_2_X.png"];
        }
        else {
            _imageNameArray = @[@"guide_0.png", @"guide_1.png", @"guide_2.png"];
        }
    }
    return _imageNameArray;
}



- (NSMutableArray *)viewControllerArray
{
    if (!_viewControllerArray) {
        _viewControllerArray = [NSMutableArray array];
        NSInteger count = self.imageNameArray.count;
        for (NSInteger i = 0; i < count; i++) {
            [_viewControllerArray addObject:[NSNull null]];
        }
    }
    return _viewControllerArray;
}

@end

@interface XNLGuideImageViewController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, copy) NSArray *imageArray;
@end

@implementation XNLGuideImageViewController

#pragma mark - Life Cycle
#pragma mark -- Initializer Methods
- (instancetype)initWithPageNumber:(NSInteger)pageNumber
                        imageArray:(NSArray *)imageArray
{
    if (self = [super init]) {
        _pageNumber = pageNumber;
        _imageArray = [imageArray copy];
    }
    return self;
}

#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupLayout];
}

#pragma mark - Private Methods
- (void)setupLayout
{

    //背景图
    UIImage *image = [UIImage imageNamed:self.imageArray[self.pageNumber]];
    self.backgroundImageView = createView(UIImageView);
    self.backgroundImageView.image = image;
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.backgroundImageView];
    
    @weakify(self);
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        @strongify(self);
        make.edges.equalTo(self.view);
    }];
    

    //立即体验按钮
    if (self.pageNumber == self.imageArray.count - 1) {
        
        UIImage *enterNormalImage = [UIImage imageNamed:@"guide_enter_button_normal"];
        UIImage *enterHighlightedImage = [UIImage imageNamed:@"guide_enter_button_selected"];
        CGFloat buttonHeight = scaleX(enterNormalImage.size.height);
        CGFloat buttonWidth  = scaleX(enterNormalImage.size.width);
        
        UIButton *enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [enterButton setBackgroundImage:enterNormalImage forState:UIControlStateNormal];
        [enterButton setBackgroundImage:enterHighlightedImage forState:UIControlStateHighlighted];
        [enterButton addTarget:self action:@selector(onStart) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:enterButton];
        
        CGFloat originY = scaleY(80.0f) + getIphoneXInsetBottom();
        
        @weakify(self);
        [enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-originY);
            make.width.equalTo(@(buttonWidth));
            make.height.equalTo(@(buttonHeight));
        }];
    }
}

#pragma mark - Target Actions
- (void)onStart
{
    if ([[XNLUtils sharedInstance] isFirstRun]) {
        [[XNLUtils sharedInstance] cacheCurVersion];    //缓存当前版本信息
    }
    AppDelegate *appDelegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate windowRootWithType:XNLWindowRootTypeMain];
}


@end

NS_ASSUME_NONNULL_END
