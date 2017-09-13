//
//  LFDatePickerViewController.h
//  KTUAV
//
//  Created by 刘丰 on 2017/9/5.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFDatePickerViewController : UIViewController

/**
 时间选择器控件，可以设置其属性
 */
@property(nonatomic,weak,readonly) UIDatePicker *datePicker;

/**
 时间字符串的格式(默认yyyy-MM-dd)
 */
@property(nonatomic,copy) NSString *dateFormat;

/**
 取消按钮
 */
@property(nonatomic,copy) void(^cancel)(); //取消回调
@property(nonatomic,copy) NSString *cancelTitle;
@property(nonatomic,strong) UIColor *cancelTitleColor;

/**
 确定按钮
 */
@property(nonatomic,copy) void(^sure)(NSString *dateStr, NSDate *date); //确定回调
@property(nonatomic,copy) NSString *sureTitle;
@property(nonatomic,strong) UIColor *sureTitleColor;

@end
