//
//  UIBarButtonItem+LFCategory.h
//  BuDeJie
//
//  Created by 刘丰 on 2017/8/6.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (custom)

/**
 快速构建一个自定义item

 @param target 响应方法的目标
 @param action 方法
 @param image 默认图片
 @param highlightedImage 高亮图片
 @return item
 */
+ (UIBarButtonItem *)barButtonItemWithTarget:(nullable id)target action:(nullable SEL)action image:(UIImage *)image highlightedImage:(nullable UIImage *)highlightedImage;

/**
 快速构建一个自定义item
 
 @param target 响应方法的目标
 @param action 方法
 @param image 默认图片
 @param selectedImage 选中图片
 @return item
 */
+ (UIBarButtonItem *)barButtonItemWithTarget:(nullable id)target action:(nullable SEL)action image:(UIImage *)image selectedImage:(nullable UIImage *)selectedImage;

/**
 快速构建一个返回item

 @param target 响应方法的目标
 @param action 方法
 @param image 默认图片
 @param highlightedImage 高亮图片
 @param color 默认文字颜色
 @param highlightedColor 高亮文字颜色
 @param title 返回标题
 @return item
 */
+ (UIBarButtonItem *)backBarButtonItemWithTarget:(nullable id)target action:(nullable SEL)action image:(UIImage *)image highlightedImage:(nullable UIImage *)highlightedImage color:(UIColor *)color highlightedColor:(UIColor *)highlightedColor title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
