//
//  LFTableViewController.m
//  Demo
//
//  Created by NJWC on 2016/12/5.
//  Copyright © 2016年 kaituo. All rights reserved.
//

#import "LFTableViewController.h"
#import "MJRefresh.h"

@interface LFTableViewController ()

@end

@implementation LFTableViewController

#pragma mark -
#pragma mark - 初始化资源数组
- (NSMutableArray *)tableDataArr
{
    if (!_tableDataArr) {
        _tableDataArr = [NSMutableArray array];
    }
    return _tableDataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    //设置表的基本属性
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 44.f;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.sectionHeaderHeight = 15.f;
    tableView.sectionFooterHeight = 15.f;
    //去除多余的分割线
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    _tableView = tableView;
    
    //默认有刷新控件
    self.refreshHeaderEnable = YES;
    self.refreshFooterEnable = YES;
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;

}

#pragma mark -
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableDataArr.count;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld-%ld", (long)indexPath.section, (long)indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (![view isKindOfClass:[UITableViewHeaderFooterView class]]) return;
    
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    headerView.textLabel.font = [UIFont systemFontOfSize:13];
    headerView.textLabel.textColor = [UIColor blackColor];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    if (![view isKindOfClass:[UITableViewHeaderFooterView class]]) return;
    
    UITableViewHeaderFooterView *footerView = (UITableViewHeaderFooterView *)view;
    footerView.textLabel.font = [UIFont systemFontOfSize:12];
    footerView.textLabel.textColor = [UIColor blackColor];
}

//显示完整的分割线
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat {
    [cell setSeparatorInset:UIEdgeInsetsZero];
}

#pragma mark -
#pragma mark - 添加上拉刷新
- (void)setRefreshHeaderEnable:(BOOL)refreshHeaderEnable
{
    _refreshHeaderEnable = refreshHeaderEnable;
    
    if (refreshHeaderEnable) {
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        header.lastUpdatedTimeLabel.hidden = YES;
        [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
        [header setTitle:@"释放立即刷新" forState:MJRefreshStatePulling];
        [header setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
        self.tableView.mj_header = header;
    }else {
        self.tableView.mj_header = nil;
    }
}

#pragma mark -
#pragma mark - 添加下拉加载更多
- (void)setRefreshFooterEnable:(BOOL)refreshFooterEnable
{
    _refreshFooterEnable = refreshFooterEnable;
    
    if (refreshFooterEnable) {
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
        [footer setTitle:@"释放立即加载更多" forState:MJRefreshStatePulling];
        [footer setTitle:@"正在加载更多..." forState:MJRefreshStateRefreshing];
        self.tableView.mj_footer = footer;
    }else {
        self.tableView.mj_footer = nil;
    }
}

#pragma mark -
#pragma mark - 上下拉刷新加载数据
- (void)refreshData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
}

- (void)loadMoreData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_footer endRefreshing];
    });
}

@end
