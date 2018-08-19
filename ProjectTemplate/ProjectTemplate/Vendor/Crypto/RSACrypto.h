//
//  RSA.h
//  
//
//  Created by chenzhong on 15/3/30.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSACrypto : NSObject
{
    SecKeyRef publicKey; 
    SecCertificateRef certificate;
    SecPolicyRef policy;
    SecTrustRef trust;
    size_t maxPlainLen;
}


- (id)initWithPubKeyFileName:(NSString *)fileName;


/**
 *  Rsa加密 NSData
 *
 *  @param content 加密数据
 *
 */
- (NSData *)encryptWithData:(NSData *)content;

/**
 *  Rsa 加密字符串
 *
 *  @param content 加密内容
 *
 *  @return 返回加密数据
 */
- (NSData *)encryptWithString:(NSString *)content;

@end
