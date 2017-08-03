//
//  NSObject+LFCategory.h
//  test1
//
//  Created by NJWC on 16/8/31.
//  Copyright © 2016年 kaituo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  遍历所有类的block（父类）
 */
typedef void (^MJClassesEnumeration)(Class c, BOOL *stop);

@interface NSObject (LFCategory)

/**
 *  获取某个模型类的所有属性
 */
+ (NSArray<NSString *> * _Nullable)allPropertys;

/**
 *  交换两个对象方法
 */
+ (void)swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel;

/**
 *  交换两个类方法
 */
+ (void)swizzleClassMethod:(SEL)originalSel with:(SEL)newSel;

/**
 *  增加一个动态属性
 */
- (void)setAssociateValue:(nullable id)value withKey:(void *)key;

/**
 *  增加一个弱引用的动态属性
 */
- (void)setAssociateWeakValue:(nullable id)value withKey:(void *)key;

/**
 *  根据key得到一个动态属性
 */
- (nullable id)getAssociatedValueForKey:(void *)key;

/**
 *  移除所有动态属性
 */
- (void)removeAssociatedValues;

/**
 *  类名
 */
+ (NSString *)className;
- (NSString *)className;

/**
 *  打印所有属性
 */
- (void)printAll;

@end

NS_ASSUME_NONNULL_END
