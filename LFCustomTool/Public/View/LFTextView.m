//
//  LFTextView.m
//  LFJXStreet
//
//  Created by 刘丰 on 2017/1/18.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFTextView.h"

NSString *const LFTextViewPlaceholderHiddenNotification = @"LFTextViewPlaceholderHiddenNotification";
@interface LFTextView ()

@property(nonatomic,weak) UILabel *phLabel;

@property(nonatomic,assign) CGFloat lastHeight;

@end

@implementation LFTextView

- (UILabel *)phLabel
{
    if (!_phLabel) {
        UILabel *phLabel = [[UILabel alloc] init];
        phLabel.textColor = [UIColor grayColor];
        phLabel.textAlignment = self.textAlignment;
        phLabel.font = self.font;
        [self addSubview:phLabel];
        _phLabel = phLabel;
    }
    return _phLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefault];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupDefault];
    }
    return self;
}

- (void)setupDefault
{
    _lastHeight = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    self.phLabel.text = placeholder;
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder
{
    _attributedPlaceholder = attributedPlaceholder;
    
    self.phLabel.attributedText = attributedPlaceholder;
}

- (CGFloat)fitHeight
{
    [self.superview layoutIfNeeded];
    self.scrollEnabled = NO;
    return [self sizeThatFits:CGSizeMake(CGRectGetWidth(self.frame), CGFLOAT_MAX)].height;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    
    self.phLabel.textAlignment = textAlignment;
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    
    self.phLabel.font = font;
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    self.font = self.phLabel.font;
    
    //有内容，占位符隐藏
    [self textDidChange];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"_UITextContainerView")]) {
            self.phLabel.frame = CGRectMake(self.textContainerInset.left + 5, self.textContainerInset.top, obj.width - self.textContainerInset.left - self.textContainerInset.right - 10, self.font.lineHeight);
            *stop = YES;
        }
    }];
}

#pragma mark -
#pragma mark - 监测内容改变
- (void)textDidChange
{
    BOOL isHidden = self.hasText || self.attributedText.length != 0;
    self.phLabel.hidden = isHidden;
    [[NSNotificationCenter defaultCenter] postNotificationName:LFTextViewPlaceholderHiddenNotification object:@(isHidden)];
    
    if (self.lfTextViewFitHeight) {
        self.scrollEnabled = NO;
        if (self.fitHeight != self.lastHeight) {
            self.lfTextViewFitHeight(self.fitHeight);
            self.lastHeight = self.fitHeight;
        }
    }
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
