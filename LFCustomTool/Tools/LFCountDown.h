//
//  LFCountDown.h
//  KTUAV
//
//  Created by 刘丰 on 2017/8/22.
//  Copyright © 2017年 liufeng. All rights reserved.
//  倒计时工具

#import <Foundation/Foundation.h>

@interface LFCountDown : NSObject

/**
 总时间，设置时间会自动开始计时
 */
@property(nonatomic,assign) NSTimeInterval maxTime;

/**
 每次倒计时的回掉（参数为剩余秒数）
 */
@property(nonatomic,copy) void(^countdownCallback)(NSTimeInterval surplusTime);

/**
 倒计时为0时，自动停止（默认NO）
 */
@property(nonatomic,assign) BOOL autoStop;

/**
 停止计时
 */
- (void)stop;

@end
