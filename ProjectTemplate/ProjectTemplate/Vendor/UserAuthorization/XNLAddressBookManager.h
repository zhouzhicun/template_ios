//
//  XNLAddressBookManager.h
//  
//
//  Created by zzc on 2017/11/8.
//  Copyright © 2017年 zzc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const XNLAddressBookContactName;
extern NSString * const XNLAddressBookContactPhone;

typedef void(^XNLAddressBookContactListCompleteBlock)(NSArray* contactList);
typedef void(^XNLAddressBookSelectContactCompleteBlock)(NSDictionary<NSString *, NSString *> *contact);

@interface XNLAddressBookManager : NSObject

AS_SINGLETON(XNLAddressBookManager)

- (void)getContactListWithViewController:(UIViewController *)viewController
                           completeBlock:(XNLAddressBookContactListCompleteBlock)completeBlock;

- (void)selectContactWithViewController:(UIViewController *)viewController
                          completeBlock:(XNLAddressBookSelectContactCompleteBlock)completeBlock;

- (BOOL)authorizedAddressBook;


@end
