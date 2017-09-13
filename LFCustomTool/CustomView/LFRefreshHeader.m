//
//  LFRefreshHeader.m
//
//  Created by 刘丰 on 2017/6/13.
//  Copyright © 2017年 kaituo. All rights reserved.
//

#import "LFRefreshHeader.h"

@implementation LFRefreshHeader

- (void)prepare
{
    [super prepare];
    
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.textColor = kRefreshColor;
    [self setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [self setTitle:@"释放立即刷新" forState:MJRefreshStatePulling];
    [self setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
}

@end
