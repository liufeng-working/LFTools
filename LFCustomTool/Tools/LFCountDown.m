//
//  LFCountDown.m
//  KTUAV
//
//  Created by 刘丰 on 2017/8/22.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFCountDown.h"

@interface LFCountDown ()

@property(nonatomic,strong) NSTimer *timer;

@property(nonatomic,assign) NSTimeInterval time;

@end

@implementation LFCountDown

- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (void)setMaxTime:(NSTimeInterval)maxTime
{
    _maxTime = maxTime;
    
    _time = maxTime;

    [self start];
}

- (void)start
{
    [self stop];
    [self.timer fire];
}

- (void)stop
{
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)countdown
{
    if (self.countdownCallback) {
        self.countdownCallback(self.time);
    }
    
    if (self.autoStop && self.time == 0) {
        [self stop];
    }
    
    if (self.time > 0) {
        self.time --;
    }else {
        self.time = 0;
    }
    
}

@end
