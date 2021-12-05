//
//  RNEncryptionModule.m
//  RNEncryptionModule
//
//  Created by Dhairya Sharma on 05/12/21.
//

#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(RNEncryptionModule, NSObject)

RCT_EXTERN_METHOD(decryptText:(NSString *)cipherText
                  withPassword:(NSString *)password
                  iv:(NSString *)iv
                  salt:(NSString *)salt
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(decryptFile:(NSString *)encryptedFilePath
                  decryptedFilePath:(NSString *)decryptedFilePath
                  withPassword:(NSString *)password
                  iv:(NSString *)iv
                  salt:(NSString *)salt
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)


RCT_EXTERN_METHOD(encryptText:(NSString *)plainText
                  withPassword:(NSString *)password
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(encryptFile:(NSString *)inputFilePath
                  encryptedFilePath:(NSString *)encryptedFilePath
                  withPassword:(NSString *)password
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

@end
