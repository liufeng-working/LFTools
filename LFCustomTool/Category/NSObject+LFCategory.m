//
//  NSObject+LFCategory.m
//  test1
//
//  Created by NJWC on 16/8/31.
//  Copyright © 2016年 kaituo. All rights reserved.
//

#import "NSObject+LFCategory.h"
#import <CoreData/CoreData.h>
#import <objc/runtime.h>
#import <objc/objc.h>

@implementation NSObject (LFCategory)

/**
 *  获取某个模型类的所有属性
 */
+ (NSArray<NSString *> * _Nullable)allPropertys
{
    NSMutableArray *props = [NSMutableArray array];
    
    [self mj_enumerateClasses:^(__unsafe_unretained Class c, BOOL *stop) {
        // 1.获得所有的成员变量
        unsigned int outCount, i;
        objc_property_t *properties = class_copyPropertyList(c, &outCount);
        for (i = 0; i<outCount; i++)
        {
            objc_property_t property = properties[i];
            NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            [props addObject:propertyName];
        }
        free(properties);
    }];
    return props;
}

/**
 *  交换两个对象方法
 */
+ (void)swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel
{
    Class class = object_getClass(self.class);
    Method originalMethod = class_getInstanceMethod(class, originalSel);
    Method newMethod = class_getInstanceMethod(class, newSel);
    BOOL ok = class_addMethod(class, originalSel, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (ok) {
        class_replaceMethod(class, newSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else {
        method_exchangeImplementations(originalMethod, newMethod);
    }
}

/**
 *  交换两个类方法
 */
+ (void)swizzleClassMethod:(SEL)originalSel with:(SEL)newSel
{
    Class class = object_getClass(self.class);
    Method originalMethod = class_getClassMethod(class, originalSel);
    Method newMethod = class_getClassMethod(class, newSel);
    
    BOOL ok = class_addMethod(class, originalSel, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (ok) {
        class_replaceMethod(class, newSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else {
        method_exchangeImplementations(originalMethod, newMethod);
    }
}

/**
 *  增加一个动态属性
 */
- (void)setAssociateValue:(nullable id)value withKey:(void *)key
{
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/**
 *  增加一个弱引用的动态属性
 */
- (void)setAssociateWeakValue:(nullable id)value withKey:(void *)key
{
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

/**
 *  根据key得到一个动态属性
 */
- (nullable id)getAssociatedValueForKey:(void *)key
{
    return objc_getAssociatedObject(self, key);
}

/**
 *  移除所有动态属性
 */
- (void)removeAssociatedValues
{
    objc_removeAssociatedObjects(self);
}

/**
 *  类名
 */
+ (NSString *)className
{
    return NSStringFromClass(self);
}

- (NSString *)className
{
    return [NSString stringWithUTF8String:class_getName([self class])];
}

/**
 *  打印所有属性
 */
- (void)printAll
{
    [[[self class] allPropertys] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       NSLog(@"%@:%@", obj, [self valueForKey:obj]);
    }];
}


/***************************************/
/****************内部工具*****************/
/***************************************/
+ (void)mj_enumerateClasses:(MJClassesEnumeration)enumeration
{
    // 1.没有block就直接返回
    if (enumeration == nil) return;
    
    // 2.停止遍历的标记
    BOOL stop = NO;
    
    // 3.当前正在遍历的类
    Class c = self;
    
    // 4.开始遍历每一个类
    while (c && !stop) {
        // 4.1.执行操作
        enumeration(c, &stop);
        
        // 4.2.获得父类
        c = class_getSuperclass(c);
        
        if ([self isClassFromFoundation:c]) break;
    }
}

+ (BOOL)isClassFromFoundation:(Class)c
{
    if (c == [NSObject class] || c == [NSManagedObject class]) return YES;
    
    __block BOOL result = NO;
    [[self foundationClasses] enumerateObjectsUsingBlock:^(Class foundationClass, BOOL *stop) {
        if ([c isSubclassOfClass:foundationClass]) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}

+ (NSSet *)foundationClasses
{
    // 集合中没有NSObject，因为几乎所有的类都是继承自NSObject，具体是不是NSObject需要特殊判断
    return [NSSet setWithObjects:
            [NSURL class],
            [NSDate class],
            [NSValue class],
            [NSData class],
            [NSError class],
            [NSArray class],
            [NSDictionary class],
            [NSString class],
            [NSAttributedString class], nil];;
}

@end
