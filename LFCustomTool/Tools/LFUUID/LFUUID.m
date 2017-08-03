//
//  LFUUID.m
//  test
//
//  Created by NJWC on 16/8/10.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "LFUUID.h"
#import "LFKeyChain.h"

#define KEY_UUID @"com.kaituo.AAA.UUID"
@implementation LFUUID

/**
 *  获取UUID（用户刷新系统，获取的会不同）
 */
+ (NSString *)getUUID
{
    NSString * strUUID = (NSString *)[LFKeyChain select:KEY_UUID];
    
    //首次执行该方法时，uuid为空
    if (strUUID.length == 0 || !strUUID)
    {
        //生成一个uuid的方法
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        
        //另一种获取方法
        //strUUID = [[UIDevice currentDevice].identifierForVendor UUIDString]
        
        //将该uuid保存到keychain
        [LFKeyChain save:KEY_UUID data:strUUID];
    }
    return strUUID;
}

/**
 *  删除钥匙串中保存的UUID
 */
+ (void)deleteUUID
{
    [LFKeyChain deleted:KEY_UUID];
}

@end
