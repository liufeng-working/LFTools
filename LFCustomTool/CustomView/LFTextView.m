//
//  LFTextView.m
//  LFJXStreet
//
//  Created by 刘丰 on 2017/1/18.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFTextView.h"

@interface LFTextView ()

@property(nonatomic,weak) UILabel *phLabel;

@end

@implementation LFTextView

- (UILabel *)phLabel
{
    if (!_phLabel) {
        UILabel *phLabel = [[UILabel alloc] init];
        phLabel.textColor = [UIColor grayColor];
        phLabel.font = self.font;
        [self addSubview:phLabel];
        _phLabel = phLabel;
    }
    return _phLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    self.phLabel.text = placeholder;

}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    self.phLabel.font = font;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    //有内容，占位符隐藏
    [self textDidChange];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    //有内容，占位符隐藏
    [self textDidChange];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"_UITextContainerView")]) {
            self.phLabel.frame = CGRectMake(5, 0, obj.width - 5, obj.height);
            *stop = YES;
        }
    }];
}

#pragma mark -
#pragma mark - 监测内容改变
- (void)textDidChange
{
    self.phLabel.hidden = self.hasText;
}

#pragma mark -
#pragma mark - 控制键盘出现消失
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.isFirstResponder) {
        [self resignFirstResponder];
    }else {
        [self becomeFirstResponder];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
