//
//  UITextField+LFCatefory.m
//  BuDeJie
//
//  Created by 刘丰 on 2017/8/9.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "UITextField+LFCatefory.h"
#import <objc/runtime.h>

const void *lfPlaceholderColor;
@implementation UITextField (placeholder)

+ (void)load {
    Method oldM = class_getInstanceMethod(self, @selector(setPlaceholder:));
    Method newM = class_getInstanceMethod(self, @selector(lf_setPlaceholder:));
    method_exchangeImplementations(oldM, newM);
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    objc_setAssociatedObject(self, &lfPlaceholderColor, placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    //方法1
    UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel"];
    placeholderLabel.textColor = placeholderColor;
    
    //方法2
    /*
     NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: placeholderColor}];
     self.attributedPlaceholder = attStr;
     */
}

- (UIColor *)placeholderColor
{
    return objc_getAssociatedObject(self, &lfPlaceholderColor);
}

- (void)lf_setPlaceholder:(NSString *)placeholder {
    [self lf_setPlaceholder:placeholder];
    
    self.placeholderColor = objc_getAssociatedObject(self, &lfPlaceholderColor);
}

@end
