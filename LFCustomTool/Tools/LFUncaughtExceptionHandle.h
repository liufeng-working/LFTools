//
//  LFUncaughtExceptionHandle.h
//  test
//
//  Created by NJWC on 16/8/4.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LFUncaughtExceptionHandle : NSObject

/**
 *  设置异常回调处理函数
 */
+ (void)setDefaultHandler;

/**
 *  获取异常回调对象
 */
+ (NSUncaughtExceptionHandler*)getHandler;

@end
