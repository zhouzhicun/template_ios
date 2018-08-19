//
//  XNLBaseViewModel.h
//  
//
//  Created by Jiandong on 6/28/16.
//  Copyright © 2016 . All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XNLRequest.h"
#import "XNLResponse.h"
#import "XNLConnectManager.h"

@interface XNLBaseViewModel : NSObject

@property (nonatomic, copy) NSString *navBarTitle;

- (void)commonInit;

/**
 * toast
 * NSString: message
 */
@property (nonatomic, strong, readonly) RACSubject *toastSubject;

/**
 * loading
 * NSNumber: YES, NO
 */
@property (nonatomic, strong, readonly) RACSubject *loadingSubject;

/**
 * success
 * RACTuple(eventName, obj), 常用于接口请求，此时eventName使用API即可。
 */
@property (nonatomic, strong, readonly) RACSubject *successSubject;

/**
 * failed
 * RACTuple(eventName, NSError), 常用于接口请求，此时eventName使用API即可。
 */
@property (nonatomic, strong, readonly) RACSubject *errorSubject;


/** 表单校验 */
- (BOOL)validForm;

@end
