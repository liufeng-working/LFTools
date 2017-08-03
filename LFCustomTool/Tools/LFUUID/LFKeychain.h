//
//  LFKeychain.h
//  LFJXStreet
//
//  Created by 刘丰 on 2017/4/12.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LFKeychain : NSObject

/**
 *  保存
 */
+ (void)save:(NSString *)service data:(id)data;

/**
 *  读取
 */
+ (id)select:(NSString *)service;

/**
 *  删除
 */
+ (void)deleted:(NSString *)service;

/**
 *  修改
 */
+ (void)update:(NSString *)service data:(id)data;

@end
