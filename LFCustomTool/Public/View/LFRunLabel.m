//
//  LFRunLabel.m
//  KT_Anhui
//
//  Created by NJWC on 16/9/29.
//  Copyright © 2016年 kaituo. All rights reserved.
//

#define kDistance 10   //两段文字间的间隔
#define kInterval 0.03 //移动1像素用的时间
#import "LFRunLabel.h"

@interface LFRunLabel ()

@property (nonatomic, strong)NSTimer *timer;

@property (nonatomic, assign)CGFloat moveLength;

@end

@implementation LFRunLabel

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        //默认值
        self.font = [UIFont systemFontOfSize:15];
        self.textColor = [UIColor blackColor];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    if (!text.length) return;
    
    _text = text;
    
    CGFloat textWidth = [self sizeWithString:text font:self.font maxH:self.font.lineHeight].width;
    
    if (textWidth > CGRectGetWidth(self.bounds)) {
        //启动定时器
        [self fire];
        //居左显示
        self.moveLength = 0;
    }else {
        
        //销毁定时器
        [self invalidate];
        //居中显示
        self.moveLength = (CGRectGetWidth(self.bounds) - textWidth) * 0.5;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat Y = (CGRectGetHeight(self.bounds) - self.font.lineHeight) * 0.5;
    NSDictionary *attDic = @{NSFontAttributeName           : self.font,
                             NSForegroundColorAttributeName: self.textColor};
    
    //开始画字
    [self.text drawAtPoint:CGPointMake(self.moveLength, Y) withAttributes:attDic];
    
    CGFloat textWidth = [self sizeWithString:self.text font:self.font maxH:self.font.lineHeight].width;
    if (textWidth > CGRectGetWidth(self.frame)) {
        
        [self.text drawAtPoint:CGPointMake(self.moveLength + textWidth + kDistance, Y) withAttributes:attDic];
    }
}

- (void)textScroll
{
    self.moveLength --;
    
    CGFloat textWidth = [self sizeWithString:self.text font:self.font maxH:self.font.lineHeight].width;
    
    if (fabs(self.moveLength) > textWidth) {
        self.moveLength = kDistance;
    }
    
    [self setNeedsDisplay];
}

#pragma mark -
#pragma mark - 打开定时器
- (void)fire
{
    if (!self.timer) {
        
        _timer = [NSTimer timerWithTimeInterval:kInterval target:self selector:@selector(textScroll) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

#pragma mark -
#pragma mark - 销毁定时器
- (void)invalidate
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font maxH:(CGFloat)maxH
{
    return [string boundingRectWithSize:CGSizeMake(MAXFLOAT, maxH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;
}

-(void)dealloc {
    NSLog(@"%s", __func__);
    [self invalidate];
}

@end
