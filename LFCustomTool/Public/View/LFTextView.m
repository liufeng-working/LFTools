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
    _placeholderHidden = NO;
    self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
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

- (void)setLfTextViewPlaceholderHidden:(void (^)(BOOL))lfTextViewPlaceholderHidden {
    _lfTextViewPlaceholderHidden = lfTextViewPlaceholderHidden;
    
    if (lfTextViewPlaceholderHidden) {
        lfTextViewPlaceholderHidden(self.isPlaceholderHidden);
    }
}

- (void)setLfTextViewFitHeight:(void (^)(CGFloat))lfTextViewFitHeight
{
    _lfTextViewFitHeight = lfTextViewFitHeight;
    
    if (lfTextViewFitHeight) {
        lfTextViewFitHeight(self.fitHeight);
        self.lastHeight = self.fitHeight;
    }
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
    
    self.phLabel.frame = CGRectMake(self.textContainerInset.left + self.textContainer.lineFragmentPadding, self.textContainerInset.top, self.textContainer.size.width - self.textContainer.lineFragmentPadding*2, self.font.lineHeight);
}

#pragma mark -
#pragma mark - 监测内容改变
- (void)textDidChange
{
    BOOL isHidden = self.hasText || self.attributedText.length != 0;
    self.phLabel.hidden = isHidden;
    
    if (self.lfTextViewPlaceholderHidden && self.isPlaceholderHidden != isHidden) {
        self.lfTextViewPlaceholderHidden(isHidden);
        _placeholderHidden = isHidden;
    }
    
    if (self.lfTextViewFitHeight) {
        self.scrollEnabled = NO;
        if (self.fitHeight != self.lastHeight) {
            self.lfTextViewFitHeight(self.fitHeight);
            self.lastHeight = self.fitHeight;
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
