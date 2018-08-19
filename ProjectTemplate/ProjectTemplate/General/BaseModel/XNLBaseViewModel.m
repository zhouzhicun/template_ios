//
//  XNLBaseViewModel.m
//  
//
//  Created by Jiandong on 6/28/16.
//  Copyright © 2016 . All rights reserved.
//

#import "XNLBaseViewModel.h"


@interface XNLBaseViewModel ()

@property (nonatomic, strong) RACSubject *toastSubject;

@property (nonatomic, strong) RACSubject *loadingSubject;

@property (nonatomic, strong) RACSubject *successSubject;

@property (nonatomic, strong) RACSubject *errorSubject;

@end

@implementation XNLBaseViewModel


#pragma mark - Public Methods

- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}


- (void)commonInit {
    
    //初始化各个subject
    self.toastSubject   = [RACSubject subject];
    self.loadingSubject = [RACSubject subject];
    self.successSubject = [RACSubject subject];
    self.errorSubject   = [RACSubject subject];
}


- (BOOL)validForm
{
    return NO;
}



@end
