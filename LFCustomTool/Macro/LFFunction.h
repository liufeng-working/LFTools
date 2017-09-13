//
//  LFFunction.h
//
//  Created by 刘丰 on 2017/6/6.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#ifndef LFFunction_h
#define LFFunction_h

#pragma mark -
#pragma mark - 快速生成cell
/** 快速生成cell */
//@interface
#define kCell_interface(name) \
+ (instancetype)name##CellWithTableView:(UITableView *)tableView;
//@implementation
#define kCell_implementation(name, className) \
+ (instancetype)name##CellWithTableView:(UITableView *)tableView \
{ \
NSString *idetifier = kClassName(className); \
className *cell = [tableView dequeueReusableCellWithIdentifier:idetifier]; \
if (!cell) { \
cell = [[[NSBundle mainBundle] loadNibNamed:idetifier owner:nil options:nil] firstObject]; \
} \
return cell; \
}

#endif /* LFFunction_h */
