//
//  UIColor+LFCategory.h
//  test1
//
//  Created by NJWC on 16/8/31.
//  Copyright © 2016年 kaituo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (LFCategory)

/**
 *  取颜色的rgba值
 */
@property (nonatomic, readonly) CGFloat red;
@property (nonatomic, readonly) CGFloat green;
@property (nonatomic, readonly) CGFloat blue;
@property (nonatomic, readonly) CGFloat alpha;

/**
 *  用6位数 获取颜色（字符串 @"#000000" 或者 @"000000"）
 */

+ (UIColor *)colorWithHexString:(NSString*)hex;

/**
 *  用8位数 获取颜色（整数 OX00000000)
 */
+ (UIColor *)colorWithHexValue:(NSInteger)hex;

/**
 *  根据颜色，还原
 */
- (uint32_t)rgbValue;
- (uint32_t)rgbaValue;
- (nullable NSString *)hexString;
- (nullable NSString *)hexStringWithAlpha;

@end

NS_ASSUME_NONNULL_END
