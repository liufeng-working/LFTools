//
//  LFImagePickerTool.m
//  test
//
//  Created by 刘丰 on 2017/1/22.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFImagePickerTool.h"
#import <ImageIO/ImageIO.h>

@implementation LFImagePickerTool

/**
 获取图片
 
 @param name 图片名称
 @return 图片
 */
+ (UIImage *)imageNamed:(NSString *)name
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"LFImagePickerController.bundle" ofType:nil];
    NSBundle *imgBundle = [NSBundle bundleWithPath:path];
    return [UIImage imageNamed:name inBundle:imgBundle compatibleWithTraitCollection:nil];
}

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

/**
 *  根据字体和指定宽度，获取size
 *
 *  @param font 字体
 *  @param maxW 指定宽度
 *
 *  @return size
 */
+ (CGSize)size:(NSString *)string font:(UIFont *)font maxW:(CGFloat)maxW
{
    return [string boundingRectWithSize:CGSizeMake(maxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;
}

/**
 *  根据字体和指定高度，获取size
 */
+ (CGSize)size:(NSString *)string font:(UIFont *)font maxH:(CGFloat)maxH
{
    return [string boundingRectWithSize:CGSizeMake(MAXFLOAT, maxH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;
}

/**
 *  根据字体得到size
 */
+ (CGSize)size:(NSString *)string font:(UIFont *)font
{
    return [self size:string font:font maxW:MAXFLOAT];
}

/**
 把秒数转换成可读的时间 （12秒 0:12，100秒 1:40)
 */
+ (NSString *)timeFromTimeInterval:(NSTimeInterval)timeInterval
{
    if (timeInterval <= 0) return @"0:00";

    NSInteger second = round(timeInterval);//四舍五入
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second < 60*10) {//10分钟以内
        formatter.dateFormat = @"m:ss";
    }else if (second < 60*60) {//1小时以内
        formatter.dateFormat = @"mm:ss";
    }else if (second < 60*60*10) {//10小时以内
        formatter.dateFormat = @"H:mm:ss";
    }else if (second < 60*60*24) {//24小时以内
        formatter.dateFormat = @"HH:mm:ss";
    }else {//大于一天
        return @"23:59:59";
    }
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:second - 8*60*60];
    return [formatter stringFromDate:date];
}

/**
 *  字节转成人类阅读习惯的 字符串
 */
+ (NSString *)stringWithBytes:(long long)bytes
{
    NSString *byte;
    NSString *unit;
    
    if(bytes >= [@"1099512000000" integerValue]){//直接写1024*1024*1024*1024(1.099512e12)，会警告整形溢出
        
        byte = [NSString stringWithFormat:@"%.2f",bytes * 1.0 / 1024 / 1024 / 1024 / 1024];
        unit = @"TB";
    }else if(bytes >= 1024 * 1024 * 1024){
        
        byte = [NSString stringWithFormat:@"%.2f",bytes * 1.0 / 1024 / 1024 / 1024];
        unit = @"GB";
    }else if(bytes >= 1024 * 1024){
        
        byte = [NSString stringWithFormat:@"%.2f",bytes * 1.0 / 1024 / 1024];
        unit = @"MB";
    }else if(bytes >= 1024){
        
        byte = [NSString stringWithFormat:@"%.2f",bytes * 1.0 / 1024];
        unit = @"KB";
    }else{
        
        byte = [NSString stringWithFormat:@"%d",(int)bytes];
        unit = @"B";
    }
    
    return [NSString stringWithFormat:@"%@%@", byte, unit];
}

/**
 得到gif图
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
 *  用6位数 获取颜色（字符串 @"#000000" 或者 @"000000"）
 */
+ (UIColor *)colorWithHexString:(NSString*)hex
{
    if (hex.length <6) {
        return [UIColor clearColor];
    }
    
    unsigned int redInt_, greenInt_, blueInt_;
    NSRange rangeNSRange_;
    rangeNSRange_.length = 2;  // 范围长度为2
    
    // 取红色的值
    rangeNSRange_.location = hex.length -6;
    [[NSScanner scannerWithString:[hex substringWithRange:rangeNSRange_]]
     scanHexInt:&redInt_];
    
    // 取绿色的值
    rangeNSRange_.location = hex.length -4;
    [[NSScanner scannerWithString:[hex substringWithRange:rangeNSRange_]]
     scanHexInt:&greenInt_];
    
    // 取蓝色的值
    rangeNSRange_.location = hex.length -2;
    [[NSScanner scannerWithString:[hex substringWithRange:rangeNSRange_]]
     scanHexInt:&blueInt_];
    
    return [UIColor colorWithRed:(float)(redInt_/255.0f)
                           green:(float)(greenInt_/255.0f)
                            blue:(float)(blueInt_/255.0f)
                           alpha:1.0f];
}

/**
 跳转到手机设置页面
 
 @param failure 失败回调
 */
+ (void)jumpToiPhoneSetting:(void(^)(void))failure
{
    UIApplication *app = [UIApplication sharedApplication];
    NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([app canOpenURL:settingUrl]) {
        if ([app respondsToSelector:@selector(openURL:)]) {                            [app openURL:settingUrl];
        }else {
            if (@available(iOS 10.0, *)) {
                [app openURL:settingUrl options:@{} completionHandler:^(BOOL success) {
                    if (!success && failure) {
                        failure();
                    }
                }];
            } else {
                // Fallback on earlier versions
            }
        }
    }else {
        if (failure) {
            failure();
        }
    }
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
