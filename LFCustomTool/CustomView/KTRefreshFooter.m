//
//  KTRefreshFooter.m
//  KTUAV_manager
//
//  Created by 刘丰 on 2017/6/13.
//  Copyright © 2017年 kaituo. All rights reserved.
//

#import "KTRefreshFooter.h"

@implementation KTRefreshFooter

- (void)prepare
{
    [super prepare];
    
    self.stateLabel.textColor = kRefreshColor;
    [self setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [self setTitle:@"释放立即加载" forState:MJRefreshStatePulling];
    [self setTitle:@"正在加载更多" forState:MJRefreshStateRefreshing];
}

@end
