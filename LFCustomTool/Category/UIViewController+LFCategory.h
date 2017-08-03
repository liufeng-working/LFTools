//
//  UIViewController+LFCategory.h
//  test
//
//  Created by 刘丰 on 2017/5/8.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTRefreshHeader.h"
#import "KTRefreshFooter.h"

typedef void(^KTImagePickerCompletion)(UIImage *originalImage, UIImage *editedImage);

@interface UIViewController (exchangeMethod)

//转换系统方法，做一些初始化操作

@end

@interface UIViewController (refresh)

/**
 是否需要头部刷新控件（默认NO）
 */
@property(nonatomic,assign,readwrite) BOOL refreshHeaderEnable;

/**
 是否需要尾部刷新控件（默认NO）
 */
@property(nonatomic,assign,readwrite) BOOL refreshFooterEnable;

/**
 下拉刷新（如果refreshHeaderEnable == YES，需要重写）
 */
- (void)loadData;

/**
 上拉更多（如果refreshFooterEnable == YES，需要重写）
 */
- (void)loadMoreData;

@end

@interface UIViewController (alert)

/**
 *  展示一个alertView(只有一个确定按钮)
 *
 *  @param title       标题
 *  @param message     详细信息
 *  @param sureTitle   确认按钮标题
 *  @param com         回调
 */
- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message sureTitle:(NSString *)sureTitle withComplete:(void(^)())com;

/**
 *  展示一个alertView（有取消和确定按钮）
 *
 *  @param title       标题
 *  @param message     详细信息
 *  @param cancelTitle 取消按钮标题
 *  @param sureTitle   确认按钮标题
 *  @param com         回调
 */
- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle sureTitle:(NSString *)sureTitle withComplete:(void(^)())com;

/**
 *  展示一个alertSheet
 *
 *  @param title   标题
 *  @param nameArr 子标题数组
 *  @param com     回调
 */
- (void)showAlertSheetWithTitle:(NSString *)title nameArray:(NSArray <NSString *>*)nameArr withComplete:(void(^)(NSString *selectItem, NSInteger selectIndex))com;

@end

@interface UIViewController (imagePicker)

/**
 展示图片选择器，相册／相机
 */
- (void)showImagePickerWithCompletion:(KTImagePickerCompletion)com;

@end

