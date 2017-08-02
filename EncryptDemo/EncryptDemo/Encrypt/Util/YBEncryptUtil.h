//
//  YBEncryptUtil.h
//  Sign
//
//  Created by YB on 2017/8/1.
//  Copyright © 2017年 X. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBEncryptUtil : NSObject

/**
 工具初始化方法

 @param aesKey AES加密需要的密钥
 @param priKey RSA加签需要的私钥
 @param pubKey RSA验签需要的公钥
 @return 工具实例
 */
- (instancetype)initWithAESKey:(NSString *)aesKey rsaPrivateKey:(NSString *)priKey rsaPublicKey:(NSString *)pubKey;

/**
 设置AES密钥

 @param aesKey AES密钥
 */
- (void)setAESKey:(NSString *)aesKey;

/**
 设置RSA加签私钥

 @param priKey RSA私钥 | PKCS#8
 */
- (void)setRSAPrivateKey:(NSString *)priKey;

/**
 设置RSA验签公钥

 @param pubKey RSA公钥
 */
- (void)setRSAPublicKey:(NSString *)pubKey;

/**
 对明文内容进行AES加密，然后对密文进行签名，最后用","拼接密文和签名

 @param content 明文
 @return 加密，签名拼接之后的字符串
 */
- (NSString *)encryptAndSign:(NSString *)content;

/**
 验签完成之后的回调

 @param success 是否成功
 @param decryptedString 解密之后的明文
 */
typedef void(^verifierCallBack)(BOOL success,NSString *decryptedString);

/**
 验签

 @param content 从服务端拿到的加密加签的字符串
 @param callBack 验签完成的回调
 */
- (void)verify:(NSString *)content completionHandler:(verifierCallBack)callBack;

@end
