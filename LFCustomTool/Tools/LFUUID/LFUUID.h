//
//  LFUUID.h
//  test
//
//  Created by NJWC on 16/8/10.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LFUUID : NSObject

/**
 *  获取UUID（用户刷新系统，获取的会不同）
 */
+ (NSString *)getUUID;

/**
 *  删除钥匙串中保存的UUID
 */
+ (void)deleteUUID;

@end
