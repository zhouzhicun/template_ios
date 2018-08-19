//
//  XNLAddressBookManager.m
//  
//
//  Created by zzc on 2017/11/8.
//  Copyright © 2017年 zzc. All rights reserved.
//

#import "XNLAddressBookManager.h"

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBook/ABPerson.h>
#import <AddressBookUI/ABPersonViewController.h>

#import "UIViewController+XNLUnauthorized.h"

NSString * const XNLAddressBookContactName  = @"name";
NSString * const XNLAddressBookContactPhone = @"phoneArr";

@interface XNLAddressBookManager () <ABPeoplePickerNavigationControllerDelegate>

@property (nonatomic, copy) XNLAddressBookSelectContactCompleteBlock selectContactCompleteBlock;

@end

@implementation XNLAddressBookManager

DEF_SINGLETON(XNLAddressBookManager)

- (void)getContactListWithViewController:(UIViewController *)viewController
                           completeBlock:(XNLAddressBookContactListCompleteBlock)completeBlock {
    
    @weakify(self)
    [self canUseAddressBookWithGrantedBlock:^{
        @strongify(self)
        
        ABAddressBookRef addressBooks =ABAddressBookCreate();
        CFArrayRef contacts = ABAddressBookCopyArrayOfAllPeople(addressBooks);
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:CFArrayGetCount(contacts)];
        
        for (NSInteger i = 0; i < CFArrayGetCount(contacts); i++) {
            
            ABRecordRef recordRef = CFArrayGetValueAtIndex(contacts, i);
            NSDictionary *dict = [self fetchContactWithRecord:recordRef];
            [array addObject:dict];
            CFRelease(recordRef);
        }
        
        //CFRelease(contacts);
        CFRelease(addressBooks);
        
        if (completeBlock) {
            completeBlock(array);
        };
        
    } unGrantedBlock:^{
        [viewController showUnauthorizedAlertWithCategory:XNLAuthorizationCategoryAddressBook];
    }];
}




- (void)selectContactWithViewController:(UIViewController *)viewController
             completeBlock:(XNLAddressBookSelectContactCompleteBlock)completeBlock {
    
    @weakify(self)
    [self canUseAddressBookWithGrantedBlock:^{
        @strongify(self)
        
        self.selectContactCompleteBlock = completeBlock;
        ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
        picker.peoplePickerDelegate = self;
        picker.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
        NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty], nil];
        picker.displayedProperties = displayedItems;
        [viewController presentViewController:picker animated:YES completion:nil];
      
    } unGrantedBlock:^{
        [viewController showUnauthorizedAlertWithCategory:XNLAuthorizationCategoryAddressBook];
    }];
}



- (void)canUseAddressBookWithGrantedBlock:(void(^)(void))grantedBlock unGrantedBlock:(void(^)(void))unGrantedBlock {
   
    switch (ABAddressBookGetAuthorizationStatus()) {
        case kABAuthorizationStatusNotDetermined:
        case kABAuthorizationStatusRestricted: {
            ABAddressBookRef addressBooks =ABAddressBookCreate();
            ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error) {
                if (granted) {
                    if (grantedBlock) grantedBlock();
                } else {
                    if (unGrantedBlock) unGrantedBlock();
                }
            });
            break;
        }
        case kABAuthorizationStatusDenied: {
            if (unGrantedBlock) unGrantedBlock();
            break;
        }
        case  kABAuthorizationStatusAuthorized: {
            if (grantedBlock) grantedBlock();
            break;
        }
            
    }
}


- (BOOL)authorizedAddressBook {
    return ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized;
}


#pragma mark - <ABPeoplePickerNavigationControllerDelegate>

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person {
    
    ABPersonViewController *personViewController = [[ABPersonViewController alloc] init];
    personViewController.displayedPerson = person;
    [peoplePicker pushViewController:personViewController animated:YES];
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    [self didSelectWithPeoplePickerNavigationController:peoplePicker person:person property:property identifier:identifier];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    [self didSelectWithPeoplePickerNavigationController:peoplePicker person:person property:property identifier:identifier];
    return NO;
}


- (void)didSelectWithPeoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker person:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    NSString *name = [self fetchNameWithRecord:person];
    
    ABMultiValueRef phoneRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    long index = ABMultiValueGetIndexForIdentifier(phoneRef, identifier);
    NSString *phone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneRef, index);
    phone = [self formatPhone:phone];
    
    NSDictionary *contactDic = @{XNLAddressBookContactName : name, XNLAddressBookContactPhone : phone};
    if (self.selectContactCompleteBlock) {
        self.selectContactCompleteBlock(contactDic);
    }
    
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Private

- (NSString *)formatPhone:(NSString *)phone {

    if ([phone hasPrefix:@"+"] && phone.length > 3) {
        phone = [phone substringFromIndex:3];
    }
    if ([phone containsString:@"-"]) {
        phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    if ([phone containsString:@"("]) {
        phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
    }
    if ([phone containsString:@")"]) {
        phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
    }
    if ([phone containsString:@" "]) {
        phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return phone;
}

- (NSString *)fetchNameWithRecord:(ABRecordRef)recordRef {
    
    NSString *firstName = (__bridge NSString*)ABRecordCopyValue(recordRef, kABPersonLastNameProperty) ?: @"";
    NSString *lastName  = (__bridge NSString*)ABRecordCopyValue(recordRef, kABPersonFirstNameProperty) ?: @"";
    return [firstName stringByAppendingString:lastName];
}

- (NSDictionary *)fetchContactWithRecord:(ABRecordRef)recordRef {
    
    NSString *name = [self fetchNameWithRecord:recordRef];
    
    NSString *phone = @"";
    NSMutableArray *phoneArr = [NSMutableArray arrayWithCapacity:0];
    ABMultiValueRef phoneRef = ABRecordCopyValue(recordRef, kABPersonPhoneProperty);
    long total = ABMultiValueGetCount(phoneRef);
    for (int i = 0; i < total; ++i) {
        phone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phoneRef, i);
        phone = [self formatPhone:phone];
        [phoneArr addObject:phone];
    }
    
    CFRelease(phoneRef);
    return @{XNLAddressBookContactName : name, XNLAddressBookContactPhone : phoneArr};
}


@end
