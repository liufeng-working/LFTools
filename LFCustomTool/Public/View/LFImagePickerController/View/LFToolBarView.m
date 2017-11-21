//
//  LFToolBarView.m
//  test
//
//  Created by 刘丰 on 2017/1/22.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFToolBarView.h"
#import "LFImagePickerTool.h"

#define lfPreViewFont [UIFont systemFontOfSize:16]
#define lfNumFont [UIFont systemFontOfSize:15]
#define lfFinishFont [UIFont systemFontOfSize:16]
#define lfPreviewTitle @"预览"
#define lfFinishTitle  @"完成"
@interface LFToolBarView ()

@property(nonatomic,weak) UIButton *previewBtn;

@property(nonatomic,weak) UILabel *numLabel;

@property(nonatomic,weak) UIButton *finishBtn;

@end

@implementation LFToolBarView

#pragma mark -
#pragma mark - 懒加载控件
- (UIButton *)previewBtn
{
    if (!_previewBtn) {
        UIButton *preview = [UIButton buttonWithType:UIButtonTypeCustom];
        preview.enabled = NO;
        preview.titleLabel.font = lfPreViewFont;
        [preview addTarget:self action:@selector(previewBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [preview setTitle:lfPreviewTitle forState:UIControlStateNormal];
        [preview setTitle:lfPreviewTitle forState:UIControlStateDisabled];
        [preview setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [preview setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [self addSubview:preview];
        _previewBtn = preview;
    }
    return _previewBtn;
}

- (UILabel *)numLabel
{
    if (!_numLabel) {
        UILabel *num = [[UILabel alloc] init];
        num.backgroundColor = [LFImagePickerTool colorWithHexString:@"#ff9c27"];
        num.layer.masksToBounds = YES;
        num.font = lfNumFont;
        num.textColor = [UIColor whiteColor];
        num.textAlignment = NSTextAlignmentCenter;
        num.hidden = YES;
        [self addSubview:num];
        _numLabel = num;
    }
    return _numLabel;
}

- (UIButton *)finishBtn
{
    if (!_finishBtn) {
        UIButton *finish = [UIButton buttonWithType:UIButtonTypeCustom];
        finish.enabled = NO;
        finish.titleLabel.font = lfFinishFont;
        [finish addTarget:self action:@selector(finishBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [finish setTitle:lfFinishTitle forState:UIControlStateNormal];
        [finish setTitle:lfFinishTitle forState:UIControlStateDisabled];
        [finish setTitleColor:[LFImagePickerTool colorWithHexString:@"#ff9c27"] forState:UIControlStateNormal];
        [finish setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [self addSubview:finish];
        _finishBtn = finish;
    }
    return _finishBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat midY = CGRectGetMidY(self.bounds);
    CGFloat midX = CGRectGetMidX(self.bounds);
    
    CGSize previewS = [LFImagePickerTool size:lfPreviewTitle font:lfPreViewFont];
    CGFloat previewW = previewS.width;
    CGFloat previewH = previewS.height;
    CGFloat previewX = 10;
    CGFloat previewY = midY - previewH*0.5;
    self.previewBtn.frame = CGRectMake(previewX, previewY, previewW, previewH);
    
    CGFloat numH = lfNumFont.lineHeight + 10;
    CGFloat numW = numH;
    CGFloat numX = midX - numW*0.5;
    CGFloat numY = midY - numH*0.5;
    self.numLabel.frame = CGRectMake(numX, numY, numW, numH);
    self.numLabel.layer.cornerRadius = numH*0.5;
    
    CGSize finishS = [LFImagePickerTool size:lfFinishTitle font:lfFinishFont];
    CGFloat finishW = finishS.width;
    CGFloat finishH = finishS.height;
    CGFloat finishX = width - finishW - 10;
    CGFloat finishY = midY - finishH*0.5;
    self.finishBtn.frame = CGRectMake(finishX, finishY, finishW, finishH);
}

#pragma mark -
#pragma mark - 设置选中数量
- (void)setSelectCount:(NSInteger)selectCount
{
    _selectCount = selectCount;
    
    BOOL isEnable = selectCount > 0;
    self.numLabel.hidden = !isEnable;
    self.numLabel.text = [NSString stringWithFormat:@"%zd", selectCount];
    self.previewBtn.enabled = isEnable;
    self.finishBtn.enabled = isEnable;
}

#pragma mark -
#pragma mark - 预览按钮点击事件
- (void)previewBtnClick
{
    if ([self.delegate respondsToSelector:@selector(toolBarViewDidClickPreview:)]) {
        [self.delegate toolBarViewDidClickPreview:self];
    }
}

#pragma mark -
#pragma mark - 完成按钮点击事件
- (void)finishBtnClick
{
    if ([self.delegate respondsToSelector:@selector(toolBarViewDidClickFinish:)]) {
        [self.delegate toolBarViewDidClickFinish:self];
    }
}

#pragma mark -
#pragma mark - 隐藏预览按钮
- (void)hiddenPreviewButton:(BOOL)hidden
{
    self.previewBtn.hidden = hidden;
}

@end
