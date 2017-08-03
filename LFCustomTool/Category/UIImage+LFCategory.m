//
//  UIImage+LFCategory.m
//  test1
//
//  Created by NJWC on 16/8/31.
//  Copyright © 2016年 kaituo. All rights reserved.
//

#import "UIImage+LFCategory.h"
#import <Accelerate/Accelerate.h>
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>
#import "LFFit.h"

@implementation UIImage (LFCategory)

- (CGFloat)width
{
    return self.size.width;
}

- (CGFloat)height
{
    return self.size.height;
}

/**
 *  获取图片格式
 */
+ (UIImageType)imageTypeWithData:(NSData *)data
{
    const char* bytes = data.bytes;
    
    if (data.length > 10 && bytes[6] == 0x4a && bytes[7] == 0x46 && bytes[8] == 0x49 && bytes[9] == 0x46) {
        
        return UIImageType_JPG;
        
    }else if (data.length > 4 && (UInt8)bytes[0] == 0xff  && (UInt8)bytes[1] == 0xd8  && (UInt8)bytes[2] == 0xff  && ((UInt8)bytes[3] == 0xe2 || (UInt8)bytes[3] == 0xe1 || (UInt8)bytes[3] == 0xe0 || (UInt8)bytes[3] == 0xdb)) {
        
        return UIImageType_JPEG;
        
    }else if (data.length > 4 && (UInt8)bytes[0] == 0x89 && (UInt8)bytes[1] == 0x50 && (UInt8)bytes[2] == 0x4e && (UInt8)bytes[3] == 0x47) {
        
        return UIImageType_PNG;
        
    }else if (data.length > 6 && bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46 && bytes[3] == 0x38 && (bytes[4] == 0x39 || bytes[4] == 0x37) && bytes[5] == 0x61) {
        
        return UIImageType_GIF;
        
    } else if (data.length > 2 && bytes[0] == 0x42 && bytes[1] == 0x4d) {
        
        return UIImageType_BMP;
        
    }else if(data.length > 12 && bytes[0] == 0x52 && bytes[1] == 0x49 && bytes[2] == 0x46 && bytes[3] == 0x46 && bytes[8] == 0x57 && bytes[9] == 0x45 && bytes[10] == 0x42 && bytes[11] == 0x50) {
        
        return UIImageType_WEBP;
        
    }else if (bytes[0] == 0x4D || bytes[0] == 0x49) {
        
        return UIImageType_TIFF;
        
    }else {
        
        return UIImageType_Unknow;
        
    }
}

+ (NSString *)imageTypeFromData:(NSData *)data
{
    UIImageType type = [self imageTypeWithData:data];
    switch (type) {
        case UIImageType_JPG:  return kUIImageType_JPG;
        case UIImageType_JPEG: return kUIImageType_JPEG;
        case UIImageType_WEBP: return kUIImageType_WEBP;
        case UIImageType_GIF:  return kUIImageType_GIF;
        case UIImageType_PNG:  return kUIImageType_PNG;
        case UIImageType_TIFF: return kUIImageType_TIFF;
        case UIImageType_BMP:  return kUIImageType_BMP;
        default:               return kUIImageType_Unknow;
    }
}

/**
 *  获取图片指定位置的截图
 */
- (UIImage *)imageWithCGRect:(CGRect)rect
{
    CGFloat X = rect.origin.x;
    CGFloat Y = rect.origin.y;
    CGFloat W = rect.size.width;
    CGFloat H = rect.size.height;
    
    if (W <= 0 || H <= 0) return nil;
    
    if (X < 0)                    X = 0;
    if (Y < 0)                    Y = 0;
    if (X + W > self.size.width)  W = self.size.width - X;
    if (Y + H > self.size.height) H = self.size.height - Y;
    
    CGRect newRect = CGRectMake(X*self.scale, Y*self.scale, W*self.scale, H*self.scale);
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, newRect);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

/**
 缩放图片在指定范围内
 
 @param maxSize 最大范围
 */
- (UIImage *)scaleLimitSize:(CGSize)maxSize
{
    CGSize size = [LFFit fitSize:self.size maxSize:maxSize];
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 *  水平翻转图片
 */
- (UIImage *)imageFromHorizontal
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, self.size.width, 0);
    CGContextScaleCTM(context, -1.0, 1.0);
    [self drawAtPoint:CGPointZero];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 *  垂直翻转图片
 */
- (UIImage *)imageFromVertical
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    [self drawAtPoint:CGPointZero];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 *  等比例缩放
 */
- (UIImage *)imageWithScale:(CGFloat)scale
{
    if (scale <= 0) {
        return self;
    }
    
    CGSize size = CGSizeMake(self.size.width * scale, self.size.height * scale);
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 *  图片增加圆角
 */
- (UIImage *)imageByCornerRadii:(CGSize)size
{
    return [self imageByCornerRadii:size withCorners:UIRectCornerAllCorners];
}

/**
 *  图片增加圆角(指定哪几个角是圆角)
 */
- (UIImage *)imageByCornerRadii:(CGSize)size
                    withCorners:(UIRectCorner)corners
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:size];
    [path addClip];
    [self drawAtPoint:CGPointZero];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 *  图片增加边框
 */
- (UIImage *)imageByBorderWidth:(CGFloat)borderWidth
                    borderColor:(UIColor *)borderColor
{
    if(2 * borderWidth > self.size.width  ||
       2 * borderWidth > self.size.height ||
       borderWidth <= 0){
        return self;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGRect rect1 = CGRectMake(0, 0, self.size.width, self.size.height);
    CGRect rect2 = CGRectInset(rect1, borderWidth, borderWidth);
    CGRect rect3 = CGRectInset(rect1, borderWidth / 2.0, borderWidth / 2.0);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect3];
    path.lineWidth = borderWidth;
    path.lineJoinStyle = kCGLineJoinMiter;
    [borderColor set];
    [path stroke];
    [[self imageWithCGRect:rect2] drawInRect:rect2];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 *  由颜色生成图片
 */
+ (UIImage *)imageWithColor:(UIColor*)color
{
    return [UIImage imageWithColor:color size:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
}

+ (UIImage *)imageWithColor:(UIColor*)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 *  获取网络视频中，指定秒的 缩略图
 */
+ (UIImage *)imageWithUrl:(NSURL *)url onSecond:(CGFloat)second
{
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    NSError *error = nil;
    CMTime time = CMTimeMakeWithSeconds(second, 10);//CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要活的某一秒的第几帧可以使用CMTimeMake方法)
    CMTime actualTime;
    CGImageRef cgImage = [generator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    if (error) {
        return nil;
    }
    CMTimeShow(actualTime);
    return [UIImage imageWithCGImage:cgImage];
}

/**
 *  取得对应点的颜色
 */
-(UIColor *)colorAtPoint:(CGPoint)point
{
    UInt8 *bitmapData = [self getBitmapData];
    if (!bitmapData) return nil;
    return [self colorAtPoint:point bitmapData:bitmapData];
}

/**
 *  获取对应点的颜色
 *
 *  @param point      位置
 *  @param bitmapData 位图数据
 *
 *  @return 颜色
 */
- (UIColor *)colorAtPoint:(CGPoint)point bitmapData:(UInt8 *)bitmapData
{
    if (!bitmapData) return nil;
    
    //图片的宽高
    NSInteger width = self.size.width;
    int offset = 4*((width*round(point.y))+round(point.x));
    CGFloat a = bitmapData[offset]/255.0;
    CGFloat r = bitmapData[offset+1]/255.0;
    CGFloat g = bitmapData[offset+2]/255.0;
    CGFloat b = bitmapData[offset+3]/255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:a];;
}

/**
 *  获取图片的主色调
 */
- (UIColor *)color
{
    //取每个点的像素值
    UInt8 *bitmapData = [self getBitmapData];
    if (!bitmapData) return nil;
    
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    NSCountedSet *cls=[NSCountedSet setWithCapacity:width*height];
    
    for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
            
            UIColor *color = [self colorAtPoint:CGPointMake(x, y) bitmapData:bitmapData];
            [cls addObject:color];
        }
    }
    
    //第三步 找到出现次数最多的那个颜色
    NSEnumerator *enumerator = [cls objectEnumerator];
    UIColor *curColor = nil;
    UIColor *maxColor=nil;
    NSUInteger maxCount=0;
    
    while ( (curColor = [enumerator nextObject]) != nil )
    {
        NSUInteger tmpCount = [cls countForObject:curColor];
        
        if ( tmpCount < maxCount ) continue;
        
        maxCount=tmpCount;
        maxColor=curColor;
        
    }
    
    if (!maxColor) maxColor = curColor;
    return maxColor;
}

/**
 *  获取位图数据
 */
- (UInt8 *)getBitmapData
{
    CGContextRef context = [self getBitmapContext];
    
    //图片的宽高
    NSInteger width = self.size.width;
    NSInteger height = self.size.height;
    CGRect rect = CGRectMake(0, 0, width, height);
    CGContextDrawImage(context, rect, self.CGImage);
    UInt8 *bitmapData = CGBitmapContextGetData(context);
    CGContextRelease(context);
    return bitmapData;
}

/**
 *  给一个图片增加水印
 *
 *  @param image  要添加的图片
 *  @param point 要添加图片的中心点在原图的什么位置
 */
- (UIImage *)watermarkWithImage:(UIImage *)image point:(CGPoint)point
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawAtPoint:CGPointZero];
    [image drawAtPoint:CGPointMake(point.x - image.size.width * 0.5, point.y - image.size.height * 0.5)];
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImg;
}

/**
 *  图片前景色变换
 *
 *  @param tintColor 需要变换的颜色
 *  @param blendMode 填充模式 一般用 kCGBlendModeDestinationIn
 *  @param image     被填充的图片
 *
 *  @return 填充后的图片
 */
+ (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode WithImageObject:(UIImage*)image
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [image drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

/**
 动图
 
 @param data 动图原始数据
 @return 动图
 */
+ (UIImage *)gifImageWithData:(NSData *)data
{
    if (!data) {
        return nil;
    }
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    size_t count = CGImageSourceGetCount(source);
    
    UIImage *animatedImage;
    
    if (count <= 1) {
        animatedImage = [UIImage imageWithData:data];
    }else {
        NSMutableArray *images = [NSMutableArray array];
        
        NSTimeInterval duration = 0.0f;
        
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            if (!image) {
                continue;
            }
            
            duration += [self durationAtIndex:i source:source];
            
            [images addObject:[UIImage imageWithCGImage:image scale:1 orientation:UIImageOrientationUp]];
            
            CGImageRelease(image);
        }
        
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    
    CFRelease(source);
    
    return animatedImage;
}

/**
 修正图片方向
 */
- (UIImage *)fixOrientation
{
    if (self.imageOrientation == UIImageOrientationUp) { return self; }
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height, CGImageGetBitsPerComponent(self.CGImage), 0, CGImageGetColorSpace(self.CGImage), CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.height, self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

/**
 压缩图片（压缩比例0.5）
 
 @return 二进制
 */
- (NSData *)compress
{
    return UIImageJPEGRepresentation(self, 0.5);
}

//创建位图上下文
- (CGContextRef)getBitmapContext
{
    //图片的宽高
    NSInteger pixelsWide = self.size.width;
    NSInteger pixelsHeight = self.size.height;
    //每一行的像素点占用的字节数，每个像素点的ARGB四个通道各占8个bit(0-255)的空间
    size_t bitmapBytePerRow = pixelsWide * 4;
    
    //计算整张图占用的字节数
    size_t bitmapByteCount = bitmapBytePerRow * pixelsHeight;
    
    //创建依赖于设备的RGB通道
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //分配足够容纳图片字节数的内存空间
    //内存空间的指针，该内存空间的大小等于图像使用RGB通道所占用的字节数
    void *bitmapData = malloc(bitmapByteCount);
    
    //创建CoreGraphic的图形上下文
    /*
     CGBitmapContextCreate(
     void * __nullable data,
     size_t width,
     size_t height,
     size_t bitsPerComponent,
     size_t bytesPerRow,
     CGColorSpaceRef __nullable space,
     uint32_t bitmapInfo)
     
     * data 指被渲染的内存区域 ，这个内存区域大小应该为(bytesPerRow * height)个字节，如果对绘制操作被渲染的内存区域并无特别的要求，那么可以传NULL
     * width 指被渲染内存区域的宽度,单位为像素
     * height 指被渲染内存区域的高度,单位为像素
     * bitsPerComponent 指被渲染内存区域中组件在屏幕每个像素点上需要使用的bits位，举例来说，如果使用32-bit像素和RGB格式，那么RGBA颜色格式中每个组件在屏幕每一个像素点需要使用的bits位就是为 32/4 = 8
     * bytesPerRow 指被渲染区域中每行所使用的bytes位数
     * space 指被渲染内存区域上下文使用的颜色空间
     * bitmapInfo 指被渲染内存区域的“视图”是否包含一个alpha（透视）通道以及每一个像素点对应的位置，除此之外还可以指定组件是浮点值还是整数值
     */
    CGContextRef context = CGBitmapContextCreate(bitmapData, pixelsWide, pixelsHeight, 8, bitmapBytePerRow, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    return context;
}

// 每一帧图片的时间
+ (float)durationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source
{
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    }else {
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    
    CFRelease(cfFrameProperties);
    return frameDuration;
}

@end
