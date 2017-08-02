//
//  ViewController.m
//  Sign
//
//  Created by YB on 2017/8/1.
//  Copyright © 2017年 X. All rights reserved.
//

#import "ViewController.h"
#import "RSADataSigner.h"
#import "YBEncryptUtil.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // RSA私钥
    NSString *privKeyPath = [[NSBundle mainBundle] pathForResource:@"priv_key" ofType:@"txt"];
    NSString *privKey = [NSString stringWithContentsOfFile:privKeyPath encoding:NSUTF8StringEncoding error:nil];
    
    // RSA公钥
    NSString *pubKeyPath = [[NSBundle mainBundle] pathForResource:@"pub_key" ofType:@"txt"];
    NSString *pubKey = [NSString stringWithContentsOfFile:pubKeyPath encoding:NSUTF8StringEncoding error:nil];
    
    // AES 密钥
    NSString *aesKey = @"xxxxxxxxxxxxxxxx";
    
    // 待加密内容
    NSString *contentPath = [[NSBundle mainBundle] pathForResource:@"content" ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:contentPath encoding:NSUTF8StringEncoding error:nil];
    
    /**
     
     为了密钥不被泄漏，在实际开发中请不要将RSA私钥和AES密钥存放在手机客户端中。
     
     */
    YBEncryptUtil *util = [[YBEncryptUtil alloc] initWithAESKey:aesKey rsaPrivateKey:privKey rsaPublicKey:pubKey];
    
//    [util setAESKey:aesKey];
//    [util setRSAPublicKey:pubKey];
//    [util setRSAPrivateKey:privKey];

    // 加密加签
    NSString *result = [util encryptAndSign:content];
    // 验签
    [util verify:result completionHandler:^(BOOL success, NSString *decryptedString) {
        
        if (success) {
            NSLog(@"【YB】：验签成功");
            NSLog(@"【YB】：验签解密得到的明文\n%@",decryptedString);
        }
        else{
            NSLog(@"【YB】：验签失败");
        }
    }];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
