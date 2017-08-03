//
//  UIColor+LFCategory.m
//  test1
//
//  Created by NJWC on 16/8/31.
//  Copyright © 2016年 kaituo. All rights reserved.
//

#import "UIColor+LFCategory.h"

@implementation UIColor (LFCategory)

/**
 *  取颜色的rgba值
 */
- (CGFloat)red
{
    CGFloat r = 0, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return r;
}

- (CGFloat)green
{
    CGFloat r, g = 0, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return g;
}

- (CGFloat)blue
{
    CGFloat r, g, b = 0, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return b;
}

- (CGFloat)alpha
{
    return CGColorGetAlpha(self.CGColor);
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
 *  用8位数 获取颜色（16进制 0x00000000）
 */
+ (UIColor *)colorWithHexValue:(NSInteger)hex
{
    float r = (float)(((hex&0xFF000000)>>24)/255.f);
    float g = (float)(((hex&0xFF0000)>>16)/255.f);
    float b = (float)(((hex&0xFF00)>>8)/255.f);
    float a = (float)((hex&0xFF)/255.f);
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

/**
 *  根据颜色，还原
 */
- (uint32_t)rgbValue
{
    CGFloat r = 0, g = 0, b = 0, a = 0;
    [self getRed:&r green:&g blue:&b alpha:&a];
    int8_t red = r * 255;
    uint8_t green = g * 255;
    uint8_t blue = b * 255;
    return (red << 16) + (green << 8) + blue;
}

- (uint32_t)rgbaValue
{
    CGFloat r = 0, g = 0, b = 0, a = 0;
    [self getRed:&r green:&g blue:&b alpha:&a];
    int8_t red = r * 255;
    uint8_t green = g * 255;
    uint8_t blue = b * 255;
    uint8_t alpha = a * 255;
    return (red << 24) + (green << 16) + (blue << 8) + alpha;
}

- (nullable NSString *)hexString
{
    return [self hexStringWithAlpha:NO];
}

- (nullable NSString *)hexStringWithAlpha
{
    return [self hexStringWithAlpha:YES];
}

- (NSString *)hexStringWithAlpha:(BOOL)withAlpha {
    CGColorRef color = self.CGColor;
    size_t count = CGColorGetNumberOfComponents(color);
    const CGFloat *components = CGColorGetComponents(color);
    static NSString *stringFormat = @"%02x%02x%02x";
    NSString *hex = nil;
    if (count == 2) {
        NSUInteger white = (NSUInteger)(components[0] * 255.0f);
        hex = [NSString stringWithFormat:stringFormat, white, white, white];
    } else if (count == 4) {
        hex = [NSString stringWithFormat:stringFormat,
               (NSUInteger)(components[0] * 255.0f),
               (NSUInteger)(components[1] * 255.0f),
               (NSUInteger)(components[2] * 255.0f)];
    }
    
    if (hex && withAlpha) {
        hex = [hex stringByAppendingFormat:@"%02lx",
               (unsigned long)(self.alpha * 255.0 + 0.5)];
    }
    return hex;
}

@end
