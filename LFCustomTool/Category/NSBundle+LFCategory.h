//
//  NSBundle+LFCategory.h
//  LFJXStreet
//
//  Created by 刘丰 on 2017/2/22.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (LFCategory)

/**
 展示在手机屏幕上的名字
 */
@property(nonatomic,copy,readonly) NSString *displayName;

/**
 BundleIdentifier
 */
@property(nonatomic,copy,readonly) NSString *bundleIdentifier;

/**
 外部版本号
 */
@property(nonatomic,copy,readonly) NSString *version;

/**
 内部版本号
 */
@property(nonatomic,copy,readonly) NSString *build;

@end
