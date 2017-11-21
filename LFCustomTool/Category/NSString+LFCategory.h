//
//  NSString+LFCategory.h
//  test1
//
//  Created by NJWC on 16/8/31.
//  Copyright © 2016年 kaituo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (LFCategory)

/**
 *  判断字符串是否为空(去除头尾空格和换行)
 */
- (BOOL)isEmpty;

/**
 是否为空格／换行
 */
- (BOOL)isWhitespace;
- (BOOL)isNewline;

/**
 *  根据字体和指定宽度，获取size
 */
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;

/**
 *  根据字体和指定高度，获取size
 */
- (CGSize)sizeWithFont:(UIFont *)font maxH:(CGFloat)maxH;

/**
 *  根据字体得到size
 */
- (CGSize)sizeWithFont:(UIFont *)font;

/**
 *  字节转成人类阅读习惯的字符串(1024 -> 1KB)
 */
+ (NSString *)stringWithBytes:(long long)bytes;

/**
 *  去除末尾的0(340321.1000 -> 340321.1)
 */
- (NSString *)removeLastZero;

/**
 *  获取字符串的首字符(😀340 -> 😀)
 */
- (NSString *)firstChar;

/**
 *  获取字符串的末尾字符(340321 -> 1)
 */
- (NSString *)lastChar;

/**
 *  移除首字符(340321 -> 40321)
 */
- (NSString *)removeFirstChar;

/**
 *  移除末尾字符(340321 -> 34032)
 */
- (NSString *)removeLastChar;

/**
 *  得到字符串的长度（主观看到的长度）
 */
- (NSInteger)LENGTH;

/**
 *  获取指定位置的字符串（index = 3 😀34😂03😀21 -> 😂）
 */
- (NSString *)stringAtIndex:(NSInteger)index;

/**
 *  获取指定位置的字符串（<index = 3> 😀34😂03😀21 -> 😀34）
 */
- (NSString *)stringToIndex:(NSInteger)index;

/**
 *  获取指定位置的字符串（<index = 3> 😀34😂03😀21 -> 😂03😀21）
 */
- (NSString *)stringFromIndex:(NSInteger)index;

/**
 *  获取指定范围内的字符串（3403211992 -> 3211<3,4>)
 */
- (NSString *)stringAtRange:(NSRange)range;

/**
 *  获取指定字符串所在的位置（str = @"3" 3403211992 -> [0,3])
 */
- (NSArray *)indexsWithString:(NSString *)str;

/**
 *  中文转成字符串(刘丰 -> liu feng)
 */
- (NSString *)stringWithChinese;

/**
 *  驼峰转下划线（liuFeng -> liu_feng）
 */
- (NSString *)underlineFromCamel;

/**
 *  下划线转驼峰（liu_feng -> liuFeng）
 */
- (NSString *)camelFromUnderline;

/**
 * 首字母变小写(LiuFeng -> liuFeng)
 */

- (NSString *)firstCharLower;
/**
 * 首字母变大写(liuFeng -> LiuFeng)
 */
- (NSString *)firstCharUpper;

/**
 *  检查字符串中，是否包含表情符号
 */
- (BOOL)containEmoji;

/**
 *  判断一个字符是不是int
 */
- (BOOL)isInt;

/**
 *  检查是否是正确的车牌号（苏A12345<目前最多包含两个字母>）
 */
- (BOOL)isPlate;

/**
 *  从一种格式转化成另一种格式的时间字符串
 */
- (NSString *)stringWithDateFormatter:(NSString *)fromFormat toDateFormatter:(NSString *)toFormat;

/**
 *  清空格式
 */
- (NSString *)clearDateFormatter;

/**
 *  指定位置插入
 */
- (NSString *)insertIndex:(NSInteger)index withString:(NSString *)string;

/**
 *  去除首尾空格
 */
- (NSString *)trim;

/**
 去除首尾空格和换行
 */
- (NSString *)trimWhitespaceAndNewline;

/**
 *  去除首尾特定字符
 */
- (NSString *)trim:(NSString *)trim;

/**
 *  去除左边空格
 */
- (NSString *)trimLeft;

/**
 *  去除左边指定字符
 */
- (NSString *)trimLeft:(NSString *)trim;

/**
 *  去除右边空格
 */
- (NSString *)trimRight;

/**
 *  去除右边特定字符
 */
- (NSString *)trimRight:(NSString *)trim;

/**
 *  获取字符串左边num长度的字符串
 */
- (NSString *)left:(NSUInteger)num;

/**
 *  获取字符串右边num长度的字符串
 */
- (NSString *)right:(NSUInteger)num;

/**
 *  获取字符串左边left长度和右边right长度的字符串
 */
- (NSString *)left:(NSUInteger)left right:(NSUInteger)right;

/**
 *  获取字符串右边right长度和左边left长度的字符串
 */
- (NSString *)right:(NSUInteger)right left:(NSUInteger)left;

/**
 *  32位随机字符串
 */
+ (NSString *)random32BitString;

/**
 *  url编码
 */
- (NSString *)urlEncoded;

/**
 *  url解码
 */
- (NSString *)urlDecoded;

#pragma mark -
#pragma mark - md5加密
- (NSString *)md5Encoded;

/**
 *  数字字符串格式化输出
 *
 *  @param num   跨度
 *  @param count 保留几位小数
 */
- (NSString *)span:(NSInteger)num decimalCount:(NSInteger)count;


#pragma mark -
#pragma mark - 电话号码中间4位以****显示
- (NSString *)secrectPhoneNumString;

/**
 *  判断是不是一个正确的电话号码
 */
- (BOOL)isPhoneNum;

/**
 *  封装成html字符串
 */
- (NSString *)htmlStr;

/**
 把秒数转换成可读的时间 （12秒 0:12，100秒 1:40)
 */
+ (NSString *)timeFromTimeInterval:(NSTimeInterval)timeInterval;

/**
 验证邮箱
 */
- (BOOL)isEmail;

/**
 验证身份证
 */
- (BOOL)isIdentityCard;

@end

@interface NSString (secure)

/**
 身份证暗文显示
 */
- (NSString *)identityCardSecure;

@end

@implementation NSString (trim)

/**
 去除空格
 */
- (NSString *)trimSpace;

@end
