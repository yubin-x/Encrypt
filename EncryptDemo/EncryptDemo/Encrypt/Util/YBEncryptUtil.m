//
//  YBEncryptUtil.m
//  Sign
//
//  Created by YB on 2017/8/1.
//  Copyright © 2017年 X. All rights reserved.
//

#import "YBEncryptUtil.h"
#import "RSADataSigner.h"
#import "RSADataVerifier.h"
#import "NSString+AES256.h"

@interface YBEncryptUtil ()

@property (nonatomic, copy) NSString *AESKey;
@property (nonatomic, copy) NSString *RSAPrivateKey;
@property (nonatomic, copy) NSString *RSAPublicKey;

@end

@implementation YBEncryptUtil

- (instancetype)initWithAESKey:(NSString *)aesKey rsaPrivateKey:(NSString *)priKey rsaPublicKey:(NSString *)pubKey
{
    if (self = [super init]) {
        _AESKey = aesKey;
        _RSAPrivateKey = priKey;
        _RSAPublicKey = pubKey;
    }
    return self;
}

- (void)setAESKey:(NSString *)aesKey
{
    _AESKey = aesKey;
}
- (void)setRSAPrivateKey:(NSString *)priKey
{
    _RSAPrivateKey = priKey;
}

- (void)setRSAPublicKey:(NSString *)pubKey
{
    _RSAPublicKey = pubKey;
}

- (NSString *)encryptAndSign:(NSString *)content
{
    if (!content || content.length == 0) {
        NSLog(@"【YB】：要加密和签名的字符串不能为空");
        return nil;
    }
    NSString *encryptedStr = [content aes256_encryptWithKey:_AESKey];
    
    RSADataSigner *signer = [[RSADataSigner alloc] initWithPrivateKey:_RSAPrivateKey];
    NSString *signedStr = [signer signString:encryptedStr];
    
    return [NSString stringWithFormat:@"%@,%@",encryptedStr,signedStr];
}
- (void)verify:(NSString *)content completionHandler:(verifierCallBack)callBack
{
    if (!content || content.length == 0) {
        NSLog(@"【YB】：要解密和验签的字符串不能为空");
        callBack ? callBack(NO,nil) : nil ;
        return;
    }
    
    NSArray *arr = [content componentsSeparatedByString:@","];
    
    if (arr.count != 2) {
        NSLog(@"【YB】：验签失败");
        callBack ? callBack(NO,nil) : nil ;
    }
    
    RSADataVerifier *verifier = [[RSADataVerifier alloc] initWithPublicKey:_RSAPublicKey];
    BOOL ret = [verifier verifyString:arr[0] withSign:arr[1]];
    
    if (ret) {
        NSString *encryptStr = arr[0];
        NSString *originStr = [encryptStr aes256_decryptWithKey:_AESKey];
        callBack ? callBack(YES,originStr) : nil;
    }
    else
    {
        NSLog(@"【YB】：验签失败");
        callBack ? callBack(NO,nil) : nil ;
    }
}


@end
