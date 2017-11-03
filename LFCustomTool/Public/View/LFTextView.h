//
//  LFTextView.h
//  LFJXStreet
//
//  Created by 刘丰 on 2017/1/18.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// object中存放BOOL值
UIKIT_EXTERN NSString *const LFTextViewPlaceholderHiddenNotification;
@interface LFTextView : UITextView

/**
 占位字符
 */
@property(nonatomic,copy) IBInspectable NSString *placeholder;

/**
 富文本占位字符
 */
@property(nonatomic,strong) NSAttributedString *attributedPlaceholder;

/**
 适合文本的高度，有改变就会回调，如果实现了这个block，则scrollEnabled会设置为NO，即默认认为你会改变LFTextView的高度
 */
@property(nonatomic,copy) void(^lfTextViewFitHeight)(CGFloat height);

/**
 适合文本的高度，如果获取了这个值，则scrollEnabled会设置为NO，即默认认为你会改变LFTextView的高度
 */
@property(nonatomic,assign,readonly) CGFloat fitHeight;

@end

NS_ASSUME_NONNULL_END
