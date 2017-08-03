//
//  CALayer+LFCategory.m
//  KTUAV
//
//  Created by 刘丰 on 2017/5/4.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "CALayer+LFCategory.h"

@implementation CALayer (color)

- (void)setBorderColorFromUIColor:(UIColor *)borderColorFromUIColor
{
    self.borderColor = borderColorFromUIColor.CGColor;
}

- (UIColor *)borderColorFromUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
