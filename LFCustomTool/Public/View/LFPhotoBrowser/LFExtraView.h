//
//  LFExtraView.h
//  LFJXStreet
//
//  Created by 刘丰 on 2017/1/11.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LFExtraViewDelegate;
@interface LFExtraView : UIView

@property(nonatomic,assign) NSInteger totle;
@property(nonatomic,assign) NSInteger currentIndex;

@property(nonatomic,weak) id<LFExtraViewDelegate> delegate;

/**
 保存按钮是否显示（默认NO）
 */
@property(nonatomic,assign) BOOL saveShow;

@end

@protocol LFExtraViewDelegate <NSObject>

@optional
- (void)extraViewDidClickSave:(LFExtraView *)view;

@end
