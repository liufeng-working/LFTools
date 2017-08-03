//
//  LFToolBarView.h
//  test
//
//  Created by 刘丰 on 2017/1/22.
//  Copyright © 2017年 liufeng. All rights reserved.
/************************************************************/
/** 底部工具条 */
/************************************************************/

#import <UIKit/UIKit.h>

@protocol LFToolBarViewDelegate;
@interface LFToolBarView : UIView

/**
 选中图片的数量
 */
@property(nonatomic,assign) NSInteger selectCount;
@property(nonatomic,weak) id<LFToolBarViewDelegate> delegate;

/**
 隐藏预览按钮
 */
- (void)hiddenPreviewButton:(BOOL)hidden;

@end

@protocol LFToolBarViewDelegate <NSObject>

@optional

/**
 点击预览
 */
- (void)toolBarViewDidClickPreview:(LFToolBarView *)toolBarView;

/**
 点击完成
 */
- (void)toolBarViewDidClickFinish:(LFToolBarView *)toolBarView;

@end
