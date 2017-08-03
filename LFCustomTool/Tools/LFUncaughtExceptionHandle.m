//
//  LFUncaughtExceptionHandle.m
//  test
//
//  Created by NJWC on 16/8/4.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "LFUncaughtExceptionHandle.h"

@implementation LFUncaughtExceptionHandle

//Documents文件路径
NSString *applicationDocumentsDirectory()
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

/**
 *  设置异常回调处理函数
 */
+ (void)setDefaultHandler
{
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
}

/**
 *  获取异常回调对象
 */
+ (NSUncaughtExceptionHandler*)getHandler
{
    return NSGetUncaughtExceptionHandler();
}

//异常处理方法
void UncaughtExceptionHandler(NSException *exception)
{
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    
    NSString *url = [NSString stringWithFormat:@"=============异常崩溃报告=============\time:\n%@ nname:\n%@\nreason:\n%@\ncallStackSymbols:\n%@",
                     [[NSDate date] description], name,reason,[arr componentsJoinedByString:@"\n"]];
    
    NSLog(@"url------>%@",url);
    NSString *path = [applicationDocumentsDirectory() stringByAppendingPathComponent:@"Exception.txt"];
    [url writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}
@end
