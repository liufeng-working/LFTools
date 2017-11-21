//
//  NSString+LFCategory.m
//  test1
//
//  Created by NJWC on 16/8/31.
//  Copyright © 2016年 kaituo. All rights reserved.
//

#import "NSString+LFCategory.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (LFCategory)

/**
 *  判断字符串是否为空(去除首尾空格和换行)
 */
- (BOOL)isEmpty
{
    return self.trimWhitespaceAndNewline.length;
}

/**
 是否为空格／换行
 */
- (BOOL)isWhitespace
{
    return ![self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length;
}

- (BOOL)isNewline
{
    return ![self stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]].length;
}

/**
 *  根据字体和指定宽度，获取size
 *
 *  @param font 字体
 *  @param maxW 指定宽度
 *
 *  @return size
 */
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW
{
    return [self boundingRectWithSize:CGSizeMake(maxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;
}

/**
 *  根据字体和指定高度，获取size
 */
- (CGSize)sizeWithFont:(UIFont *)font maxH:(CGFloat)maxH
{
    return [self boundingRectWithSize:CGSizeMake(MAXFLOAT, maxH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;
}

/**
 *  根据字体得到size
 */
- (CGSize)sizeWithFont:(UIFont *)font
{
    return [self sizeWithFont:font maxW:MAXFLOAT];
}

/**
 *  字节转成人类阅读习惯的 字符串
 */
+ (NSString *)stringWithBytes:(long long)bytes
{
    NSString *byte;
    NSString *unit;
    
    if(bytes >= [@"1099512000000" integerValue]){//直接写1024*1024*1024*1024(1.099512e12)，会警告整形溢出
        
        byte = [NSString stringWithFormat:@"%.2f", bytes * 1.0 / 1024 / 1024 / 1024 / 1024];
        unit = @"TB";
    }else if(bytes >= 1024 * 1024 * 1024){
        
        byte = [NSString stringWithFormat:@"%.2f", bytes * 1.0 / 1024 / 1024 / 1024];
        unit = @"GB";
    }else if(bytes >= 1024 * 1024){
        
        byte = [NSString stringWithFormat:@"%.2f", bytes * 1.0 / 1024 / 1024];
        unit = @"MB";
    }else if(bytes >= 1024){
        
        byte = [NSString stringWithFormat:@"%.2f", bytes * 1.0 / 1024];
        unit = @"KB";
    }else{
        
        byte = [NSString stringWithFormat:@"%d", (int)bytes];
        unit = @"B";
    }
    
    return [NSString stringWithFormat:@"%@%@", [byte removeLastZero], unit];
}

/**
 *  去除小数点末尾的0
 */
- (NSString *)removeLastZero
{
    if ([self isEmpty]) {
        return self;
    }
    
    if(![self containsString:@"."]){
        return self;
    }
    
    NSString *str = self;
    
    while ([[str lastChar] isEqualToString:@"0"] || [[str lastChar] isEqualToString:@"."]) {
        
        if ([[str lastChar] isEqualToString:@"."]) {
            str = [str removeLastChar];
            break;
        }
        
        str = [str removeLastChar];
        
    }
    
    return str;
}

/**
 *  获取字符串的首字符
 */
- (NSString *)firstChar
{
    return [self stringAtIndex:0];
}

/**
 *  获取字符串的末尾字符
 */
- (NSString *)lastChar
{
    return [self stringAtIndex:self.LENGTH - 1];
}

/**
 *  移除首字符
 */
- (NSString *)removeFirstChar
{
    return [self stringAtRange:NSMakeRange(1, self.LENGTH - 1)];
}

/**
 *  移除末尾字符
 */
- (NSString *)removeLastChar
{
    return [self stringAtRange:NSMakeRange(0, self.LENGTH - 1)];
}

/**
 *  得到字符串的长度（主观看到的长度）
 */
- (NSInteger)LENGTH
{
    if (self.length == 0) {
        return 0;
    }
    
    __block NSInteger length = 0;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        length++;
    }];
    
    return length;
}

/**                    012 345 678
 *  获取指定位置的字符串（😀34😂03😀21 -> 😂<位置3>）
 */
- (NSString *)stringAtIndex:(NSInteger)index
{
    if ([self isEmpty]) {
        return @"";
    }
    
    if (index >= self.LENGTH) {
        return @"";
    }
    
    NSInteger indexStr = 0;
    NSRange range = NSMakeRange(0, 0);
    
    for (NSInteger i = -1; i < index; i ++)
    {
        range = [self rangeOfComposedCharacterSequenceAtIndex:indexStr];
        indexStr += range.length;
    }
    
    return [self substringWithRange:range];
}

/**
 *  获取指定位置的字符串（<index = 3> 😀34😂03😀21 -> 😀34）
 */
- (NSString *)stringToIndex:(NSInteger)index
{
    return [self stringAtRange:NSMakeRange(0, index)];
}

/**
 *  获取指定位置的字符串（<index = 3> 😀34😂03😀21 -> 😂03😀21）
 */
- (NSString *)stringFromIndex:(NSInteger)index
{
    return [self stringAtRange:NSMakeRange(index, self.LENGTH - index)];
}

/**
 *  获取指定范围内的字符串
 */
- (NSString *)stringAtRange:(NSRange)range
{
    NSMutableString *string = [NSMutableString string];
    for (NSInteger i = range.location; i < range.location + range.length; i ++)
    {
        [string appendString:[self stringAtIndex:i]];
    }
    
    return string;
}

/**
 *  获取指定字符串所在的位置（str = @"3" 3403211992 -> [0,3])
 */
- (NSArray *)indexsWithString:(NSString *)str
{
    NSInteger length = str.LENGTH;
    NSMutableArray *result = [NSMutableArray array];
    for (NSInteger i = 0; i <= self.LENGTH - length; i ++)
    {
        NSString *resultStr = [self stringAtRange:NSMakeRange(i, length)];
        if ([resultStr isEqualToString:str]) {
            [result addObject:@(i)];
        }
    }
    return result;
}

/**
 *  中文转成字符串
 */
- (NSString *)stringWithChinese
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:self];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //返回全拼
    return str;
}

/**
 *  驼峰转下划线
 */
- (NSString *)underlineFromCamel
{
    if ([self isEmpty]) return self;
    NSMutableString *string = [NSMutableString string];
    for (NSUInteger i = 0; i<self.length; i++) {
        
        NSString *cString = [self stringAtIndex:i];
        NSString *cStringLower = [cString lowercaseString];
        if ([cString isEqualToString:cStringLower]) {
            [string appendString:cStringLower];
        }else{
            [string appendString:@"_"];
            [string appendString:cStringLower];
        }
    }
    return string;
}

/**
 *  下划线转驼峰
 */
- (NSString *)camelFromUnderline
{
    if ([self isEmpty]) return self;
    NSMutableString *string = [NSMutableString string];
    NSArray *cmps = [self componentsSeparatedByString:@"_"];
    for (NSUInteger i = 0; i<cmps.count; i++) {
        NSString *cmp = cmps[i];
        if (i && cmp.length){
            [string appendString:[cmp firstCharUpper]];
        }else{
            [string appendString:cmp];
        }
    }
    return string;
}

/**
 * 首字母变小写
 */
- (NSString *)firstCharLower
{
    if ([self isEmpty]) return self;
    NSMutableString *string = [NSMutableString string];
    [string appendString:[self stringAtIndex:0].lowercaseString];
    if (self.length >= 2) [string appendString:[self removeFirstChar]];
    return string;
}

/**
 * 首字母变大写
 */
- (NSString *)firstCharUpper
{
    if (self.isEmpty) return self;
    NSMutableString *string = [NSMutableString string];
    [string appendString:[self stringAtIndex:0].uppercaseString];
    if (self.length >= 2) [string appendString:[self removeFirstChar]];
    return string;
}

/**
 *  检查字符串中，是否包含表情符号
 */
- (BOOL)containEmoji
{
    __block BOOL isEomji = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length)
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              const unichar hs = [substring characterAtIndex:0];
                              if (0xd800 <= hs && hs <= 0xdbff) {
                                  if (substring.length > 1) {
                                      const unichar ls = [substring characterAtIndex:1];
                                      const int uc = ((hs - 0xd800)*0x400) + (ls - 0xdc00) + 0x10000;
                                      if (0x1d000 <= uc && uc <= 0x1f77f) {
                                          isEomji = YES;
                                      }
                                  }
                              } else if (substring.length > 1) {
                                  const unichar ls = [substring characterAtIndex:1];
                                  if (ls == 0x20e3 || ls == 0xfe0f || ls == 0xd83c) {
                                      isEomji = YES;
                                  }
                              } else {
                                  if (0x2100 <= hs && hs <= 0x27ff) {
                                      if (0x278b <= hs && 0x2792 >= hs) {
                                          isEomji = NO;
                                      }else {
                                          isEomji = YES;
                                      }
                                  } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                      isEomji = YES;
                                  } else if (0x2934 <= hs && hs <= 0x2935) {
                                      isEomji = YES;
                                  } else if (0x3297 <= hs && hs <= 0x3299) {
                                      isEomji = YES;
                                  } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50 || hs == 0x231a || hs == 0xd83e) {
                                      isEomji = YES;
                                  }
                              }
                          }];
    return isEomji;
}

//- (BOOL)containEmoji
//{
//    NSUInteger len = [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
//    if (len < 3) {// 大于2个字符需要验证Emoji(有些Emoji仅三个字符)
//        return NO;
//    }
//    
//    //仅考虑字节长度为3的字符,大于此范围的全部做Emoji处理
//    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
//    
//    Byte *bts = (Byte *)[data bytes];
//    Byte bt;
//    short v;
//    for (NSUInteger i = 0; i < len; i++) {
//        bt = bts[i];
//        
//        if ((bt | 0x7F) == 0x7F) {  //0xxxxxxx  ASIIC编码
//            continue;
//        }
//        if ((bt | 0x1F) == 0xDF) {  //110xxxxx  两个字节的字符
//            i += 1;
//            continue;
//        }
//        if ((bt | 0x0F) == 0xEF) {  //1110xxxx  三个字节的字符(重点过滤项目)
//            //计算Unicode下标
//            v = bt & 0x0F;
//            v = v << 6;
//            v |= bts[i + 1] & 0x3F;
//            v = v << 6;
//            v |= bts[i + 2] & 0x3F;
//            
//            //NSLog(@"%02X%02X", (Byte)(v >> 8), (Byte)(v & 0xFF));
//            
//            if ([self emojiInSoftBankUnicode:v] || [self emojiInUnicode:v]) {
//                return YES;
//            }
//            
//            i += 2;
//            continue;
//        }
//        if ((bt | 0x3F) == 0xBF) {  //10xxxxxx  10开头,为数据字节,直接过滤
//            continue;
//        }
//        
//        return YES;                 //不是以上情况的字符全部超过三个字节,做Emoji处理
//    }
//    
//    return NO;
//}

/**
 *  判断一个字符是不是int
 */
- (BOOL)isInt
{
    NSScanner *scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

/**
 *  检查是否是正确的车牌号（苏A12345<目前最多包含两个字母>）
 */
- (BOOL)isPlate
{
    if (self.LENGTH != 7) {
        return NO;
    }
    
    //苏A12345
    NSString *allName = @"京津冀晋蒙辽吉黑沪苏浙皖闽赣鲁豫鄂湘粤桂琼渝川黔滇藏陕甘青宁新台港澳";
    NSString *name = [self firstChar];
    NSString *letter = [self stringAtIndex:1];
    NSString *no = [self stringAtRange:NSMakeRange(2, 5)];
    
    //省份简称 是否正确
    BOOL nameBool = [allName containsString:name];
    //首字母 是否正确
    BOOL letterBool = [letter isLetter];
    //5个串 是否正确
    BOOL noBool = [self isValidateWithNo:no];
    return nameBool && letterBool && noBool;
}

/**
 *  从一种格式转化成另一种格式 时间字符串
 */
- (NSString *)stringWithDateFormatter:(NSString *)fromFormat toDateFormatter:(NSString *)toFormat
{
    NSDateFormatter *fromDateFormatter = [[NSDateFormatter alloc] init];
    fromDateFormatter.dateFormat = fromFormat;
    
    NSDateFormatter *toDateFormatter = [[NSDateFormatter alloc] init];
    toDateFormatter.dateFormat = toFormat;
    
    return [toDateFormatter stringFromDate:[fromDateFormatter dateFromString:self]];
}

/**
 *  清空格式
 */
- (NSString *)clearDateFormatter
{
    NSString *str = [self stringByReplacingOccurrencesOfString:@"/" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"," withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"." withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@":" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"年" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"月" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"日" withString:@""];
    return str;
}

/**
 *  指定位置插入
 */
- (NSString *)insertIndex:(NSInteger)index withString:(NSString *)string
{
    NSString *str1 = [self stringToIndex:index];
    NSString *str2 = [self stringFromIndex:index];
    return [[str1 stringByAppendingString:string] stringByAppendingString:str2];
}

/**
 *  去除首尾空格
 */
- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

/**
 去除首尾空格和换行
 */
- (NSString *)trimWhitespaceAndNewline
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

/**
 *  去除首尾特定字符
 */
- (NSString *)trim:(NSString *)trim
{
    NSString *str = self;
    str = [str trimLeft:trim];
    str = [str trimRight:trim];
    return str;
}

/**
 *  去除左边空格
 */
- (NSString *)trimLeft
{
    return [self trimLeft:@" "];
}

/**
 *  去除左边指定字符
 */
- (NSString *)trimLeft:(NSString *)trim
{
    NSString *str = self;
    while ([str hasPrefix:trim]) {
        str = [str stringFromIndex:trim.LENGTH];
    }
    return str;
}

/**
 *  去除右边空格
 */
- (NSString *)trimRight
{
    return [self trimRight:@" "];
}

/**
 *  去除右边特定字符
 */
- (NSString *)trimRight:(NSString *)trim
{
    NSString *str = self;
    while ([str hasSuffix:trim]) {
        str = [str stringToIndex:str.LENGTH - trim.LENGTH];
    }
    return str;
}

/**
 *  获取字符串左边num长度的字符串
 */
- (NSString *)left:(NSUInteger)num
{
    return [self stringToIndex:num];
}

/**
 *  获取字符串右边num长度的字符串
 */
- (NSString *)right:(NSUInteger)num
{
    return [self stringFromIndex:(self.LENGTH - num)];
}

/**
 *  获取字符串左边left长度和右边right长度的字符串
 */
- (NSString *)left:(NSUInteger)left right:(NSUInteger)right
{
    return [[self left:left] stringByAppendingString:[self right:right]];
}

/**
 *  获取字符串右边right长度和左边left长度的字符串
 */
- (NSString *)right:(NSUInteger)right left:(NSUInteger)left
{
    return [[self right:right] stringByAppendingString:[self left:left]];
}

/**
 *  32位随机字符串
 */
+ (NSString *)random32BitString
{
    char data[32];
    for (int x = 0; x < 32; x ++){
        
        data[x] = (char)('A' + (arc4random_uniform(26)));
    }
    return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
}

/**
 *  编码
 */
- (NSString *)urlEncoded
{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"!$&'()*+,-./:;=?@_~%#[]"]];
}

/**
 *  解码
 */
- (NSString *)urlDecoded
{
    return [self stringByRemovingPercentEncoding];
}

#pragma mark -
#pragma mark - md5加密
- (NSString *)md5Encoded
{
    if(self == nil || self.length == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return [NSString stringWithString:outputString];
}

- (NSString *)sha1:(NSString *)input
{
    //const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    //NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

/**
 *  数字字符串格式化输出
 *
 *  @param num   几位一个逗号
 *  @param count 保留几位小数
 */
- (NSString *)span:(NSInteger)num decimalCount:(NSInteger)count
{
    NSMutableString *ms = [NSMutableString string];
    
    if (num > 0) {
        [ms appendString:@","];
        for (NSInteger i = 0; i < num - 1; i ++)
        {
            [ms appendString:@"#"];
        }
        
        [ms appendString:@"0"];
    }
    
    if (count != 0) {
        [ms appendString:@"."];
    }
    for (int i = 0; i < count; i++) {
        [ms appendString:@"0"];
    }
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:ms];
    return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[[self numberic] doubleValue]]];
}

/**
 *  电话号码中间4位以****显示
 */
- (NSString *)secrectPhoneNumString
{
    if (self.LENGTH != 11) {
        return self;
    }
    return [self stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
}

/**
 *  判断是不是一个正确的电话号码
 */
- (BOOL)isPhoneNum
{
    NSString *phoneNumber = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (phoneNumber.length != 11) {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    /**
     25     * 大陆地区固话及小灵通
     26     * 区号：010,020,021,022,023,024,025,027,028,029
     27     * 号码：七位或八位
     28     */
    //  NSString * PHS = @"^(0[0-9]{2})\\d{8}$|^(0[0-9]{3}(\\d{7,8}))$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if (([regextestmobile evaluateWithObject:phoneNumber] == YES)
        || ([regextestcm evaluateWithObject:phoneNumber] == YES)
        || ([regextestct evaluateWithObject:phoneNumber] == YES)
        || ([regextestcu evaluateWithObject:phoneNumber] == YES)) {
        return YES;
    }else {
        return NO;
    }
}

/**
 *  封装成html字符串
 */
- (NSString *)htmlStr
{
    return [NSString stringWithFormat:@"<html><body bgcolor=\"#FFFFFF\"><div style='text-indent:2em;font-size:15px'>\r\n<p>%@</p>\r\n</div></body></html>", self];
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
 验证邮箱
 */
- (BOOL)isEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailPre evaluateWithObject:self];
}

/**
 验证身份证
 */
- (BOOL)isIdentityCard
{
    //http://blog.csdn.net/l2i2j2/article/details/51020204
    if (self.length != 18) {
        return NO;
    }
    
    NSString *regex = @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}(\\d|[xX])$";
    NSPredicate *p = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if(![p evaluateWithObject:self]) {
        return NO;
    }
    
    // 系数数组
    NSArray *numArr = @[@7, @9, @10, @5, @8, @4, @2, @1, @6, @3, @7, @9, @10, @5, @8, @4, @2];
    // 余数数组
    NSArray *remainderArr = @[@"1", @"0", @"X", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    __block NSInteger sum = 0;
    [self enumerateSubstringsInRange:NSMakeRange(0, 17) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        NSInteger base = [substring integerValue];
        NSInteger num = [numArr[substringRange.location] integerValue];
        sum += base*num;
    }];
    
    NSString *temp = remainderArr[(sum%11)];
    NSString *last = [self substringFromIndex:17];
    return [last.uppercaseString isEqualToString:temp];
}

//123,456,789 -> 123456789
- (NSString *)numberic; {
    
    return [self stringByReplacingOccurrencesOfString:@"," withString:@""];
}

//判断一个字符是不是大写字母
- (BOOL)isLetter
{
    if (self.isEmpty) {
        return NO;
    }
    NSPredicate *lPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[A-Z]$"];
    return [lPre evaluateWithObject:self];
}

//5个由字母和数字组成的串
- (BOOL)isValidateWithNo:(NSString *)no
{
    NSPredicate *noPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[A-Z0-9]{5}$"];
    BOOL noBool1 = [noPre evaluateWithObject:no];
    BOOL noBool2 = [no letterCount] <= 2;
    return noBool1 && noBool2;
}

//字母个数
- (NSInteger)letterCount
{
    NSInteger letterC = 0;
    for (NSInteger i = 0; i < self.LENGTH; i ++)
    {
        NSString *letter = [self stringAtIndex:i];
        if ([letter isLetter]) {
            letterC ++;
        }
    }
    
    return letterC;
}

- (BOOL)emojiInUnicode:(short)code
{
    if (code == 0x0023
        || code == 0x002A
        || (code >= 0x0030 && code <= 0x0039)
        || code == 0x00A9
        || code == 0x00AE
        || code == 0x203C
        || code == 0x2049
        || code == 0x2122
        || code == 0x2139
        || (code >= 0x2194 && code <= 0x2199)
        || code == 0x21A9 || code == 0x21AA
        || code == 0x231A || code == 0x231B
        || code == 0x2328
        || code == 0x23CF
        || (code >= 0x23E9 && code <= 0x23F3)
        || (code >= 0x23F8 && code <= 0x23FA)
        || code == 0x24C2
        || code == 0x25AA || code == 0x25AB
        || code == 0x25B6
        || code == 0x25C0
        || (code >= 0x25FB && code <= 0x25FE)
        || (code >= 0x2600 && code <= 0x2604)
        || code == 0x260E
        || code == 0x2611
        || code == 0x2614 || code == 0x2615
        || code == 0x2618
        || code == 0x261D
        || code == 0x2620
        || code == 0x2622 || code == 0x2623
        || code == 0x2626
        || code == 0x262A
        || code == 0x262E || code == 0x262F
        || (code >= 0x2638 && code <= 0x263A)
        || (code >= 0x2648 && code <= 0x2653)
        || code == 0x2660
        || code == 0x2663
        || code == 0x2665 || code == 0x2666
        || code == 0x2668
        || code == 0x267B
        || code == 0x267F
        || (code >= 0x2692 && code <= 0x2694)
        || code == 0x2696 || code == 0x2697
        || code == 0x2699
        || code == 0x269B || code == 0x269C
        || code == 0x26A0 || code == 0x26A1
        || code == 0x26AA || code == 0x26AB
        || code == 0x26B0 || code == 0x26B1
        || code == 0x26BD || code == 0x26BE
        || code == 0x26C4 || code == 0x26C5
        || code == 0x26C8
        || code == 0x26CE
        || code == 0x26CF
        || code == 0x26D1
        || code == 0x26D3 || code == 0x26D4
        || code == 0x26E9 || code == 0x26EA
        || (code >= 0x26F0 && code <= 0x26F5)
        || (code >= 0x26F7 && code <= 0x26FA)
        || code == 0x26FD
        || code == 0x2702
        || code == 0x2705
        || (code >= 0x2708 && code <= 0x270D)
        || code == 0x270F
        || code == 0x2712
        || code == 0x2714
        || code == 0x2716
        || code == 0x271D
        || code == 0x2721
        || code == 0x2728
        || code == 0x2733 || code == 0x2734
        || code == 0x2744
        || code == 0x2747
        || code == 0x274C
        || code == 0x274E
        || (code >= 0x2753 && code <= 0x2755)
        || code == 0x2757
        || code == 0x2763 || code == 0x2764
        || (code >= 0x2795 && code <= 0x2797)
        || code == 0x27A1
        || code == 0x27B0
        || code == 0x27BF
        || code == 0x2934 || code == 0x2935
        || (code >= 0x2B05 && code <= 0x2B07)
        || code == 0x2B1B || code == 0x2B1C
        || code == 0x2B50
        || code == 0x2B55
        || code == 0x3030
        || code == 0x303D
        || code == 0x3297
        || code == 0x3299
        // 第二段
        || code == 0x23F0) {
        return YES;
    }
    return NO;
}

/**
 * 一种非官方的, 采用私有Unicode 区域
 * e0 - e5  01 - 59
 */
- (BOOL)emojiInSoftBankUnicode:(short)code
{
    return ((code >> 8) >= 0xE0 && (code >> 8) <= 0xE5 && (Byte)(code & 0xFF) < 0x60);
}

/**
 是否是统一社会信用代码
 */
- (BOOL)isUSCC
{
    //http://blog.sina.com.cn/s/blog_540316260102x352.html
    if (self.length != 18) {
        return NO;
    }
    
    NSString *uscc = self.uppercaseString;
    if ([uscc containsString:@"I"] ||
        [uscc containsString:@"O"] ||
        [uscc containsString:@"S"] ||
        [uscc containsString:@"V"] ||
        [uscc containsString:@"Z"]) {
        return NO;
    }
    
    NSDictionary *baseDic = @{@"0": @0,
                              @"1": @1,
                              @"2": @2,
                              @"3": @3,
                              @"4": @4,
                              @"5": @5,
                              @"6": @6,
                              @"7": @7,
                              @"8": @8,
                              @"9": @9,
                              @"A": @10,
                              @"B": @11,
                              @"C": @12,
                              @"D": @13,
                              @"E": @14,
                              @"F": @15,
                              @"G": @16,
                              @"H": @17,
                              @"J": @18,
                              @"K": @19,
                              @"L": @20,
                              @"M": @21,
                              @"N": @22,
                              @"P": @23,
                              @"Q": @24,
                              @"R": @25,
                              @"T": @26,
                              @"U": @27,
                              @"W": @28,
                              @"X": @29,
                              @"Y": @30};
    
    NSArray *numArr = @[@1, @3, @9, @27, @19, @26, @16, @17, @20, @29, @25, @13, @8, @24, @10, @30, @28];
    
    __block NSInteger sum = 0;
    [uscc enumerateSubstringsInRange:NSMakeRange(0, 17) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        NSInteger base = [baseDic[substring] integerValue];
        NSInteger num = [numArr[substringRange.location] integerValue];
        sum += base*num;
    }];
    NSInteger temp = 31 - sum%31;
    NSString *last = [uscc substringFromIndex:17];
    NSInteger lastNum = [baseDic[last] integerValue];
    
    return lastNum == temp;
}

/**
 是否是组织机构代码
 */
- (BOOL)isOIBC
{
    NSString *oibc = self.uppercaseString;
    if ([oibc containsString:@"-"]) {
        oibc = [oibc stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    if (oibc.length != 9) {
        //        return NO;
    }
    
    NSDictionary *baseDic = @{@"0": @0,
                              @"1": @1,
                              @"2": @2,
                              @"3": @3,
                              @"4": @4,
                              @"5": @5,
                              @"6": @6,
                              @"7": @7,
                              @"8": @8,
                              @"9": @9,
                              @"A": @10,
                              @"B": @11,
                              @"C": @12,
                              @"D": @13,
                              @"E": @14,
                              @"F": @15,
                              @"G": @16,
                              @"H": @17,
                              @"I": @18,
                              @"J": @19,
                              @"K": @20,
                              @"L": @21,
                              @"M": @22,
                              @"N": @23,
                              @"O": @24,
                              @"P": @25,
                              @"Q": @26,
                              @"R": @27,
                              @"S": @28,
                              @"T": @29,
                              @"U": @30,
                              @"V": @31,
                              @"W": @32,
                              @"X": @33,
                              @"Y": @34,
                              @"Z": @35};
    
    NSArray *numArr = @[@3, @7, @9, @10, @5, @8, @4, @2];
    
    __block NSInteger sum = 0;
    [oibc enumerateSubstringsInRange:NSMakeRange(0, 8) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        NSInteger base = [baseDic[substring] integerValue];
        NSInteger num = [numArr[substringRange.location] integerValue];
        sum += base*num;
    }];
    NSInteger temp = 11 - sum%11;
    NSString *tempStr;
    if (temp == 10) {
        tempStr = @"X";
    }else if (temp == 11) {
        tempStr = @"0";
    }else {
        tempStr = [NSString stringWithFormat:@"%ld", (long)temp];
    }
    NSString *last = [oibc substringFromIndex:8];
    
    return [last isEqualToString:tempStr];
}

@end

@implementation NSString (secure)

/**
 身份证暗文显示
 */
- (NSString *)identityCardSecure;
{
    return [self stringByReplacingCharactersInRange:NSMakeRange(self.length - 8, 8) withString:@"********"];
}

@end

@implementation NSString (trim)

/**
 去除空格
 */
- (NSString *)trimSpace
{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

@end
