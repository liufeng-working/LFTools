//
//  NSArray+LFCategory.h
//  KT_Anhui
//
//  Created by NJWC on 16/10/8.
//  Copyright © 2016年 kaituo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (LFCategory)

/**
 *  获取数组中最大的数
 */
- (CGFloat)maximum;

/**
 *  获取数组中最小的数
 */
- (CGFloat)minimum;

/**
 *  获取数组中平均值
 */
- (CGFloat)average;

/**
 *  数组中字符串对应的尺寸
 */
- (NSArray *)stringSizeArrWithFont:(UIFont *)font;
- (NSArray *)stringSizeArrWithFont:(UIFont *)font maxH:(CGFloat)maxH;
- (NSArray *)stringSizeArrWithFont:(UIFont *)font maxW:(CGFloat)maxW;
- (NSArray *)stringHeightArrWithFont:(UIFont *)font;
- (NSArray *)stringWidthArrWithFont:(UIFont *)font;
- (NSArray *)stringHeightArrWithFont:(UIFont *)font maxW:(CGFloat)maxW;
- (NSArray *)stringWidthArrWithFont:(UIFont *)font maxH:(CGFloat)maxH;


@end
