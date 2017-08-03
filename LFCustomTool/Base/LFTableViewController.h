//
//  LFTableViewController.h
//  Demo
//
//  Created by NJWC on 2016/12/5.
//  Copyright © 2016年 kaituo. All rights reserved.
//

/***************************/
/** 所有tableView控制器的基类 */
/***************************/

#import "LFBaseViewController.h"

@interface LFTableViewController : LFBaseViewController<UITableViewDelegate, UITableViewDataSource>

/**
 *  表
 */
@property (nonatomic, strong, readonly)UITableView *tableView;

/**
 *  数据源
 */
@property (nonatomic, strong)NSMutableArray *tableDataArr;

/**
 是否需要头部刷新控件
 */
@property(nonatomic,assign) BOOL refreshHeaderEnable;

/**
 是否需要尾部刷新控件
 */
@property(nonatomic,assign) BOOL refreshFooterEnable;

/**
 上下拉刷新
 */
- (void)refreshData;
- (void)loadMoreData;

@end
