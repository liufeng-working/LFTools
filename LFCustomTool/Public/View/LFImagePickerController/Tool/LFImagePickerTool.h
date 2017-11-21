//
//  LFImagePickerTool.h
//  test
//
//  Created by 刘丰 on 2017/1/22.
//  Copyright © 2017年 liufeng. All rights reserved.
/************************************************************/
/** 工具类，如果有写好的分类，可以删除相应的方法 */
/************************************************************/

#import <UIKit/UIKit.h>

/** 屏幕宽高 */
#define LFImagePickerScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define LFImagePickerScreenHeight ([UIScreen mainScreen].bounds.size.height)
@interface LFImagePickerTool : NSObject

/**
 获取图片

 @param name 图片名称
 @return 图片
 */
+ (UIImage *)imageNamed:(NSString *)name;

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

/**
 *  根据字体和宽高，获取size
 */
+ (CGSize)size:(NSString *)string font:(UIFont *)font maxW:(CGFloat)maxW;
+ (CGSize)size:(NSString *)string font:(UIFont *)font maxH:(CGFloat)maxH;
+ (CGSize)size:(NSString *)string font:(UIFont *)font;

/**
 把秒数转换成可读的时间 （12秒 0:12，100秒 1:40)
 */
+ (NSString *)timeFromTimeInterval:(NSTimeInterval)timeInterval;

/**
 *  字节转成人类阅读习惯的 字符串
 */
+ (NSString *)stringWithBytes:(long long)bytes;

/**
 得到gif图
 */
+ (UIImage *)gifImageWithData:(NSData *)data;

/**
 *  用6位数 获取颜色（字符串 @"#000000" 或者 @"000000"）
 */
+ (UIColor *)colorWithHexString:(NSString*)hex;

/**
 跳转到手机设置页面
 
 @param failure 失败回调
 */
+ (void)jumpToiPhoneSetting:(void(^)(void))failure;

@end
