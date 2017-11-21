//
//  LFAlbumCell.h
//  test
//
//  Created by 刘丰 on 2017/1/22.
//  Copyright © 2017年 liufeng. All rights reserved.
/************************************************************/
/** 相册封面cell */
/************************************************************/

#import <UIKit/UIKit.h>

@class LFAlbumModel;
@interface LFAlbumCell : UITableViewCell

/**
 初始化cell
 */
+ (instancetype)albumCellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong) LFAlbumModel *albumM;

@end
