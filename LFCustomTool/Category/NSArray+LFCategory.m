//
//  NSArray+LFCategory.m
//  KT_Anhui
//
//  Created by NJWC on 16/10/8.
//  Copyright © 2016年 kaituo. All rights reserved.
//

#import "NSArray+LFCategory.h"

@implementation NSArray (LFCategory)

/**
 *  获取数组中最大的数
 */
- (CGFloat)maximum
{
    return [[self.numStringArr valueForKeyPath:@"@max.floatValue"] floatValue];
}

/**
 *  获取数组中最小的数
 */
- (CGFloat)minimum
{
    return [[self.numStringArr valueForKeyPath:@"@min.floatValue"] floatValue];
}

/**
 *  获取数组中平均值
 */
- (CGFloat)average
{
    return [[self.numStringArr valueForKeyPath:@"@avg.floatValue"] floatValue];
}

/**
 *  数组中字符串对应的尺寸
 */
- (NSArray *)stringSizeArrWithFont:(UIFont *)font
{
    return [self stringSizeArrWithFont:font maxH:MAXFLOAT];
}

- (NSArray *)stringSizeArrWithFont:(UIFont *)font maxH:(CGFloat)maxH
{
    NSMutableArray *temArr = [NSMutableArray array];
    for (NSString *obj in self.numStringArr) {
        
        CGSize size = [obj sizeWithFont:font maxH:maxH];
        [temArr addObject:[NSValue valueWithCGSize:size]];
    }
    return temArr;
}

- (NSArray *)stringSizeArrWithFont:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableArray *temArr = [NSMutableArray array];
    for (NSString *obj in self.numStringArr) {
        
        CGSize size = [obj sizeWithFont:font maxW:maxW];
        [temArr addObject:[NSValue valueWithCGSize:size]];
    }
    return temArr;
}

- (NSArray *)stringHeightArrWithFont:(UIFont *)font
{
    return [self stringHeightArrWithFont:font maxW:MAXFLOAT];
}

- (NSArray *)stringWidthArrWithFont:(UIFont *)font
{
    return [self stringWidthArrWithFont:font maxH:MAXFLOAT];
}

- (NSArray *)stringHeightArrWithFont:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableArray *temArr = [NSMutableArray array];
    for (NSString *obj in self.numStringArr) {
        
        CGSize size = [obj sizeWithFont:font maxW:maxW];
        [temArr addObject:@(size.height)];
    }
    return temArr;
}

- (NSArray *)stringWidthArrWithFont:(UIFont *)font maxH:(CGFloat)maxH
{
    NSMutableArray *temArr = [NSMutableArray array];
    for (NSString *obj in self.numStringArr) {
        
        CGSize size = [obj sizeWithFont:font maxH:maxH];
        [temArr addObject:@(size.width)];
    }
    return temArr;
}

- (instancetype)numStringArr
{
    NSMutableArray *temArr = [NSMutableArray array];
    for (id obj in self) {
        
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *objArr = (NSArray *)obj;
            for (id sonObj in objArr) {
                [temArr addObject:[NSString stringWithFormat:@"%@", sonObj]];
            }
        }else {
            [temArr addObject:[NSString stringWithFormat:@"%@", obj]];
        }
    }
    return temArr;
}

@end
