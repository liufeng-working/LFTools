//
//  UIImage+LFCategory.h
//  test1
//
//  Created by NJWC on 16/8/31.
//  Copyright © 2016年 kaituo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kUIImageType_Unknow @"Unknow"
#define kUIImageType_JPG    @"jpg"
#define kUIImageType_JPEG   @"jpeg"
#define kUIImageType_PNG    @"png"
#define kUIImageType_BMP    @"bmp"
#define kUIImageType_GIF    @"gif"
#define kUIImageType_WEBP   @"webp"
#define kUIImageType_TIFF   @"tiff"

typedef NS_ENUM(NSInteger, UIImageType) {
    UIImageType_Unknow,
    
    UIImageType_JPG,
    UIImageType_JPEG,
    UIImageType_PNG,
    UIImageType_BMP,
    UIImageType_GIF,
    UIImageType_WEBP,
    UIImageType_TIFF,
};

@interface UIImage (LFCategory)

@property(nonatomic,assign,readonly) CGFloat width;
@property(nonatomic,assign,readonly) CGFloat height;

/**
 *  获取图片格式
 */
+ (UIImageType)imageTypeWithData:(NSData *)data;
+ (NSString *)imageTypeFromData:(NSData *)data;

/**
 *  获取图片指定位置的截图
 */
- (UIImage *)imageWithCGRect:(CGRect)rect;

/**
 缩放图片在指定范围内
 
 @param maxSize 最大范围
 */
- (UIImage *)scaleLimitSize:(CGSize)maxSize;

/**
 *  水平翻转图片
 */
- (UIImage *)imageFromHorizontal;

/**
 *  垂直翻转图片
 */
- (UIImage *)imageFromVertical;

/**
 *  等比例缩放
 */
- (UIImage *)imageWithScale:(CGFloat)scale;

/**
 *  图片增加圆角
 */
- (UIImage *)imageByCornerRadii:(CGSize)size;

/**
 *  图片增加圆角(指定哪几个角是圆角)
 */
- (UIImage *)imageByCornerRadii:(CGSize)size
                    withCorners:(UIRectCorner)corners;

/**
 *  图片增加边框
 */
- (UIImage *)imageByBorderWidth:(CGFloat)borderWidth
                    borderColor:(UIColor *)borderColor;

/**
 *  由颜色生成图片
 */
+ (UIImage *)imageWithColor:(UIColor*)color;
+ (UIImage *)imageWithColor:(UIColor*)color size:(CGSize)size;

/**
 *  获取网络视频中，指定秒的 缩略图
 */
+ (UIImage *)imageWithUrl:(NSURL *)url onSecond:(CGFloat)second;

/**
 *  取得对应点的颜色(在循环中使用时，建议使用下面的方法)
 */
-(UIColor *)colorAtPoint:(CGPoint)point;

/**
 *  获取对应点的颜色
 *
 *  @param point      位置
 *  @param bitmapData 位图数据（通过getBitmapData方法得到）
 *
 *  @return 颜色
 */
- (UIColor *)colorAtPoint:(CGPoint)point bitmapData:(UInt8 *)bitmapData;

/**
 *  获取图片的主色调
 */
- (UIColor *)color;

/**
 *  获取位图数据（循环时，放在循环外，不然会很卡）
 */
- (UInt8 *)getBitmapData;

/**
 *  给一个图片增加水印
 *
 *  @param image  要添加的图片
 *  @param point 要添加图片的中心点在原图的什么位置
 */
- (UIImage *)watermarkWithImage:(UIImage *)image point:(CGPoint)point;

/**
 *  图片前景色变换
 *
 *  @param tintColor 需要变换的颜色
 *  @param blendMode 填充模式 一般用 kCGBlendModeDestinationIn
 *  @param image     被填充的图片
 *
 *  @return 填充后的图片
 */
+ (UIImage *)imageWithTintColor:(UIColor *)tintColor
                     blendMode:(CGBlendMode)blendMode
               WithImageObject:(UIImage*)image;

/**
 动图

 @param data 动图原始数据
 @return 动图
 */
+ (UIImage *)gifImageWithData:(NSData *)data;

/**
 修正图片方向
 */
- (UIImage *)fixOrientation;

/**
 压缩图片（压缩比例0.5）
 
 @return 二进制
 */
- (NSData *)compress;

@end

@interface UIImage (original)

/**
 根据图片名称获取原始未渲染的图片
 
 @param imageName 图片名称
 @return 原始图片
 */
+ (UIImage *)originalImageNamed:(NSString *)imageName;

@end
