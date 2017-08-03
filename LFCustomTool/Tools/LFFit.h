//
//  LFFit.h
//  LFJXStreet
//
//  Created by 刘丰 on 2017/1/11.
//  Copyright © 2017年 liufeng. All rights reserved.
//

@interface LFFit : NSObject

/**
 等比例压缩尺寸 至 指定范围
 */
//如果原大小小于指定范围，则返回原大小
+ (CGSize)fitSize:(CGSize)originalSize;//默认范围{200, 200}
+ (CGSize)fitSize:(CGSize)originalSize maxSize:(CGSize)maxSize;
//如果原大小小于指定范围，则返回小于指定范围的最大大小
+ (CGSize)maxFitSize:(CGSize)originalSize maxSize:(CGSize)maxSize;
+ (CGSize)fitSize:(CGSize)originalSize maxSize:(CGSize)maxSize isMax:(BOOL)isMax;//isMax,是否返回小于指定范围的最大大小

/**
 调节位置（x／y坐标）
 
 @param original 原始大小
 @param max 最大大小
 @return 合适的坐标值
 */
+ (CGFloat)fitOrigin:(CGFloat)original max:(CGFloat)max;

@end
