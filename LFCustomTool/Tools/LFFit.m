//
//  LFFit.m
//  LFJXStreet
//
//  Created by 刘丰 on 2017/1/11.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFFit.h"

@implementation LFFit


/**
 等比例压缩尺寸 至 指定范围
 */
//默认范围{200, 200}
+ (CGSize)fitSize:(CGSize)originalSize
{
    return [self fitSize:originalSize maxSize:CGSizeMake(200, 200)];
}

//如果小于原大小小于指定范围，则返回原大小
+ (CGSize)fitSize:(CGSize)originalSize maxSize:(CGSize)maxSize
{
    return [self fitSize:originalSize maxSize:maxSize isMax:NO];
}

//如果小于原大小小于指定范围，则返回小于指定范围的最大大小
+ (CGSize)maxFitSize:(CGSize)originalSize maxSize:(CGSize)maxSize
{
    return [self fitSize:originalSize maxSize:maxSize isMax:YES];
}

//isMax,是否返回小于指定范围的最大大小
+ (CGSize)fitSize:(CGSize)originalSize maxSize:(CGSize)maxSize isMax:(BOOL)isMax
{
    CGFloat maxW = maxSize.width;
    CGFloat maxH = maxSize.height;
    CGFloat maxScale = maxW*1.0/maxH;
    CGFloat originalW = originalSize.width;
    CGFloat originalH = originalSize.height;
    CGFloat scale = originalW*1.0/originalH;
    
    if (scale > maxScale && originalW > maxW) {
        return CGSizeMake(maxW, maxW / scale);
    }else if (scale < maxScale && originalH > maxH) {
        return CGSizeMake(scale * maxH, maxH);
    }else if (scale == maxScale && originalH > maxH) {
        return CGSizeMake(maxW, maxH);
    }else {
        if (isMax) {
            if (originalW/maxW < originalH/maxH) {
                return CGSizeMake(scale * maxH, maxH);
            }else{
                return CGSizeMake(maxW, maxW / scale);
            }
        }else {
            return originalSize;
        }
    }
}

/**
 调节位置（x／y坐标）
 
 @param original 原始大小
 @param max 最大大小
 @return 合适的坐标值
 */
+ (CGFloat)fitOrigin:(CGFloat)original max:(CGFloat)max
{
    return original > max ? 0 : (max - original)*0.5;
}

@end
