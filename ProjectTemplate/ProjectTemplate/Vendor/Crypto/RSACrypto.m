//
//  RSA.m
//  
//
//  Created by chenzhong on 15/3/30.
//  Copyright (c) 2015年 . All rights reserved.
//
#import "RSACrypto.h"
#import <Security/Security.h>


@interface RSACrypto ()

@property (nonatomic, copy) NSString *pubKeyfileName;

@end

@implementation RSACrypto

- (id)initWithPubKeyFileName:(NSString *)pubKeyfileName
{
    self = [super init];
    if (self) {
        self.pubKeyfileName = pubKeyfileName;
        [self getPublicKey];
        
    }
    return self;
}


- (void)getPublicKey {

    NSString *publicKeyPath = [[NSBundle mainBundle] pathForResource:self.pubKeyfileName ofType:nil];
    if (publicKeyPath == nil) {
        NSLog(@"Can not find pub.der");
        return;
    }
    NSData *publicKeyFileContent = [NSData dataWithContentsOfFile:publicKeyPath];
    if (publicKeyFileContent == nil) {
        NSLog(@"Can not read from pub.der");
        return;
    }
    certificate = SecCertificateCreateWithData(kCFAllocatorDefault, ( __bridge CFDataRef)publicKeyFileContent);
    if (certificate == nil) {
        NSLog(@"Can not read certificate from pub.der");
        return;
    }
    policy = SecPolicyCreateBasicX509();
    OSStatus returnCode = SecTrustCreateWithCertificates(certificate, policy, &trust);
    if (returnCode != 0) {
        NSLog(@"SecTrustCreateWithCertificates fail. Error Code: %d", (int)returnCode);
        return;
    }
    SecTrustResultType trustResultType;
    returnCode = SecTrustEvaluate(trust, &trustResultType);
    if (returnCode != 0) {
        NSLog(@"SecTrustEvaluate fail. Error Code: %d", (int)returnCode);
        return;
    }
    publicKey = SecTrustCopyPublicKey(trust);
    if (publicKey == nil) {
        NSLog(@"SecTrustCopyPublicKey fail");
        return;
    }
    maxPlainLen = SecKeyGetBlockSize(publicKey) - 12;
}

- (NSData *)encryptWithData:(NSData *)content{

    size_t plainLen = [content length];
    if (plainLen > maxPlainLen) {
        NSLog(@"content(%ld) is too long, must < %ld", plainLen, maxPlainLen);
        return nil;
    }
    void *plain = malloc(plainLen);
    [content getBytes:plain length:plainLen];
    
    size_t cipherLen = 128; // 当前RSA的密钥长度是128字节

    void *cipher = malloc(cipherLen);
    OSStatus returnCode = SecKeyEncrypt(publicKey, kSecPaddingPKCS1, plain,plainLen, cipher, &cipherLen);
    NSData *result = nil;
    if (returnCode != 0) {
        NSLog(@"SecKeyEncrypt fail. Error Code: %d", (int)returnCode);
    }
    else {
        result = [NSData dataWithBytes:cipher length:cipherLen];
    }
    free(plain);
    free(cipher);
    return result;
}

- (NSData *)encryptWithString:(NSString *)content {

    return [self encryptWithData:[content dataUsingEncoding:NSUTF8StringEncoding]];
}


- (void)dealloc{
    
    CFRelease(publicKey);
    CFRelease(trust);
    CFRelease(policy);
    CFRelease(certificate);
}

@end
