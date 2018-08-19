//
//  XNLTextFieldSideView.m
//  
//
//  Created by zzc on 16/7/14.
//  Copyright © 2016年 . All rights reserved.
//

#import "XNLTextFieldSideView.h"

@interface XNLTextFieldSideView ()

@property (nonatomic, strong) NSValue *fixedSizeValue;

@end


@implementation XNLTextFieldSideView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!CGRectEqualToRect(frame, CGRectZero)) {
           self.fixedSizeValue = [NSValue valueWithCGSize:frame.size];
        }
    }
    return self;
}

- (CGSize)sideViewSize
{
    CGSize resultSize = CGSizeZero;
    if (self.fixedSizeValue) {
        resultSize = [self.fixedSizeValue CGSizeValue];
    } else {
        resultSize = [self ss_calculateCompressedSize];
    }
    return resultSize;
}

@end
