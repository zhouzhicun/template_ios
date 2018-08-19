//
//  XNLGuideViewController.h
//  
//
//  Copyright (c) 2015年 . All rights reserved.
//

#import "XNLBaseViewController.h"

/**
 *  @brief App 向导页界面
 */
@interface XNLGuideViewController : XNLBaseViewController

@end

@interface XNLGuideImageViewController : XNLBaseViewController

- (instancetype)initWithPageNumber:(NSInteger)pageNumber
                        imageArray:(NSArray *)imageArray;

@end

