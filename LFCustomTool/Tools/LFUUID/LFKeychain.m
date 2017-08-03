//
//  LFKeychain.m
//  LFJXStreet
//
//  Created by 刘丰 on 2017/4/12.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFKeychain.h"

@implementation LFKeychain

#pragma mark 写入
+ (void)save:(NSString *)service data:(id)data
{
    OSStatus result;
    //获得搜索词典
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //在添加新项目之前删除旧项目
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //添加新的对象到搜索字典（注意：数据格式）
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    //添加项目和词典查询钥匙扣
    result = SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
    NSCAssert( result == noErr, @"不能添加Keychain条目。" );
}

#pragma mark 读取
+ (id)select:(NSString *)service
{
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //配置搜索设置
    //我们期待的只有一个单一的属性将返回（UUID）我们可以设置属性 kSecReturnData:kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"反序列化 %@ 失败: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

#pragma mark 删除
+ (void)deleted:(NSString *)service
{
    OSStatus result;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    result = SecItemDelete((CFDictionaryRef)keychainQuery);
    NSCAssert( result == noErr, @"不能删除Keychain条目。" );
}

#pragma mark 修改
+ (void)update:(NSString *)service data:(id)data
{
    OSStatus result;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    NSMutableDictionary *tempCheck = [self getKeychainQuery:service];
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    result = SecItemUpdate((CFDictionaryRef)keychainQuery, (CFDictionaryRef)tempCheck);
    NSCAssert( result == noErr, @"不能更新Keychain条目。" );
}

/**
 * 1.赋予应用对某个钥匙串条目的访问权限。
 *
 * 2.写入时配置钥匙串条目，对kSecAttrAccessGroup的值进行设置
 **/


/*
 * 钥匙串的操作接口都位于Security.framework框架下，它是一个sqlite数据库，位于/private/var/Keychains/keychain-2.db，其保存的所有数据都是加密过的。
 *
 * 其过程可以总结为：
 *
 * 1.配置查询字典，格式是NSMutableDictionary，功能就相当于写一句SQL一样。
 *
 * 2.进行增(SecItemAdd)、删(SecItemDelete)、改(SecItemUpdate)、查(SecItemCopyMatching)
 **/


/**
 *  获取搜索字典
 */
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    
    /*
     kSecClass  是你存数据是什么格式，这里是通用密码格式
     kSecAttrGeneric  标识符(此属性是可选项，但是为了能获取存取的值更精确，最好还是写上吧)
     kSecAttrService  存的是什么服务，这个是用来到时候取的时候找到对应的服务存的值（这个属性类似于主键，kSecAttrService、kSecAttrAccount必须要赋一个值）
     kSecAttrAccount  账号，在这里作用与服务没差别（且是否必写与kSecAttrService一样）
     当你有服务或者账号则必须有密码
     kSecAttrAccessible  安全性
     */
    NSString *ID = [NSBundle mainBundle].infoDictionary[@"CFBundleIdentifier"];
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            ID,(id)kSecAttrGeneric,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

@end
