//
//  LFExtraView.m
//  LFJXStreet
//
//  Created by 刘丰 on 2017/3/15.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFExtraView.h"

#define kFont [UIFont systemFontOfSize:15]
#define kSpace 10
@interface LFExtraView ()

@property(nonatomic,weak) UILabel *titleL;

@property(nonatomic,weak) UILabel *timeL;

@end

@implementation LFExtraView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        UILabel *title = [[UILabel alloc] init];
        title.font = kFont;
        title.textColor = [UIColor whiteColor];
        [self addSubview:title];
        _titleL = title;
        
        UILabel *time = [[UILabel alloc] init];
        time.font = kFont;
        time.textColor = [UIColor whiteColor];
        [self addSubview:time];
        _timeL = time;
        
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    self.titleL.text = title;
    
    [self setNeedsLayout];
}

- (void)setTime:(NSString *)time
{
    _time = time;
    
    self.timeL.text = time;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat h = CGRectGetHeight(self.bounds);
    CGFloat w = CGRectGetWidth(self.bounds);
    
    if (self.time.length != 0) {
        CGFloat timeW = [self.time boundingRectWithSize:CGSizeMake(MAXFLOAT, h) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: kFont} context:nil].size.width;
        self.timeL.frame = CGRectMake(w - timeW - kSpace, 0, timeW, h);
        self.titleL.frame = CGRectMake(kSpace, 0, w - timeW - 3*kSpace, h);
    }else {
        self.titleL.frame = CGRectMake(kSpace, 0, w - 2*kSpace, h);
    }
}

@end
