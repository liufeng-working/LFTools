//
//  LFStaticInline.h
//
//  Created by 刘丰 on 2017/6/6.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#ifndef LFStaticInline_h
#define LFStaticInline_h

#pragma mark -
#pragma mark - 判断一个id类型是否为空
/** 判断一个id类型是否为空 */
UIKIT_STATIC_INLINE BOOL lf_NSObjectIsEmpty(id obj) {
    if (obj == nil ||
        obj == NULL ||
        [obj isEqual:[NSNull null]] ||
        [obj isEqualToString:@"(null)"] ||
        [obj isEqualToString:@"<null>"] ||
        [obj isEqualToString:@"null"] ||
        [obj isEqualToString:@"NULL"] ||
        ([obj respondsToSelector:@selector(length)]
         && [obj length] == 0) ||
        ([obj respondsToSelector:@selector(count)]
         && [obj count] == 0)) {
            return YES;
        }else {
            return NO;
        }
}

#pragma mark -
#pragma mark - 点偏移
/** 点偏移 */
UIKIT_STATIC_INLINE CGPoint lf_CGPointOffset(CGPoint point, CGFloat dx, CGFloat dy) {
    return CGPointMake(point.x + dx, point.y + dy);
}

#pragma mark -
#pragma mark - id类型转成字符串
/** id类型转成字符串 */
UIKIT_STATIC_INLINE NSString *lf_NSStringFromObject(id object) {
    if (object == nil || [object isEqual:[NSNull null]]) {
        return @"";
    } else if ([object isKindOfClass:[NSString class]]) {
        return object;
    } else if ([object respondsToSelector:@selector(stringValue)]){
        return [object stringValue];
    } else {
        return [object description];
    }
}

#pragma mark -
#pragma mark - NSInteger转成字符串
/** NSInteger转成字符串 */
UIKIT_STATIC_INLINE NSString *lf_NSStringFromNSInteger(NSInteger number) {
    
#if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64
    return [NSString stringWithFormat:@"%ld", (long)number];
#else
    return [NSString stringWithFormat:@"%d", number];
#endif
}

#pragma mark -
#pragma mark - CGRect转成字符串{x, y, width, height}
/** CGRect转成字符串 */
UIKIT_STATIC_INLINE NSString *lf_NSStringFromCGRect(CGRect rect) {
    
    return [NSString stringWithFormat:@"{%.2f, %.2f, %.2f, %.2f}", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height];
}

#pragma mark -
#pragma mark - CGPoint转成字符串{x, y}
/** CGPoint转成字符串 */
UIKIT_STATIC_INLINE NSString *lf_NSStringFromCGPoint(CGPoint point) {
    
    return [NSString stringWithFormat:@"{%.2f, %.2f}", point.x, point.y];
}

#pragma mark -
#pragma mark - CGSize转成字符串{width, height}
/** CGSize转成字符串 */
UIKIT_STATIC_INLINE NSString *lf_NSStringFromCGSize(CGSize size) {
    
    return [NSString stringWithFormat:@"{%.2f, %.2f}", size.width, size.height];
}

#pragma mark -
#pragma mark - 根据字典自动生成属性
/** 根据字典自动生成属性 */
UIKIT_STATIC_INLINE void lf_PropertyCode(NSDictionary *dic) {
    //属性代码
    NSMutableString *code = [NSMutableString stringWithString:@"\n"];
    //备注
    NSString *sep = @"/**\n  <#Description#>\n*/";
    //属性策略
    __block NSString *polity;
    //属性类型
    __block NSString *type;
    //属性名
    //key
    
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        [code appendString:sep];
        
        if ([obj isKindOfClass:NSClassFromString(@"NSTaggedPointerString")] ||
            [obj isKindOfClass:NSClassFromString(@"__NSCFString")]) {//NSString
            polity = @"copy";
            type = @"NSString *";
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFDictionary")]) {//NSDictionary
            printf("\n//---------------%s---------------", key.UTF8String);
            lf_PropertyCode(obj);
            printf("//---------------%s---------------\n", key.UTF8String);
            
            polity = @"strong";
            type = @"NSDictionary *";
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFNumber")]) {//NSNumber
            polity = @"strong";
            type = @"NSNumber *";
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFArray")]) {//NSArray
            if ([obj[0] isKindOfClass:NSClassFromString(@"__NSCFDictionary")]) {
                printf("\n//---------------%s---------------", key.UTF8String);
                lf_PropertyCode(obj[0]);
                printf("//---------------%s---------------\n", key.UTF8String);
            }
            
            polity = @"strong";
            type = @"NSArray<NSString *> *";
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFBoolean")]) {//BOOL
            polity = @"assign";
            type = @"BOOL ";
        }else {//未知
            polity = @"<#name#> *";
            type = @"<#name#>";
        }
        
        [code appendFormat:@"\n@property(nonatomic,%@) %@%@;\n", polity, type, key];
        [code appendString:@"\n"];
    }];
    
    printf("%s", code.UTF8String);
}

#endif /* LFStaticInline_h */
