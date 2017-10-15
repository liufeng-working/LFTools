//
//  LFAlbumModel.h
//  test
//
//  Created by 刘丰 on 2017/1/19.
//  Copyright © 2017年 liufeng. All rights reserved.
/************************************************************/
/** 相册模型  */
/************************************************************/

#import <UIKit/UIKit.h>
#import "LFAssetModel.h"

@interface LFAlbumModel : NSObject

/**
 相册名称
 */
@property(nonatomic,copy,readonly) NSString *title;

/**
 相册中照片数量
 */
@property(nonatomic,assign,readonly) NSInteger count;

/**
 所有照片模型
 */
@property(nonatomic,strong,readonly) NSArray<LFAssetModel *> *assetMs;

/**
 当前相册已经选择的照片模型
 */
@property(nonatomic,strong) NSArray<LFAssetModel *> *selectAssetMs;
@property(nonatomic,strong,readonly) NSArray<NSString *> *localIdentifiers;//本相册中选中的皂片id

/**
 当前相册未选择的照片模型
 */
@property(nonatomic,strong) NSArray<LFAssetModel *> *unSelectAssetMs;
@property(nonatomic,strong,readonly) NSArray<NSString *> *unLocalIdentifiers;//本相册中未选中的皂片id

/**
 已经选择的照片数量
 */
@property(nonatomic,assign,readonly) NSInteger selectCount;

/**
 构建实例对象

 @param fetchResult 所有照片实体
 @param title   相册名称
 @return 实例
 */
- (instancetype)initWithFetchResult:(PHFetchResult<PHAsset *> *)fetchResult title:(NSString *)title;
+ (instancetype)albumModel:(PHFetchResult<PHAsset *> *)fetchResult title:(NSString *)title;

@end
