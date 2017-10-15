//
//  LFAlbumModel.m
//  test
//
//  Created by 刘丰 on 2017/1/19.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFAlbumModel.h"

@implementation LFAlbumModel

#pragma mark -
#pragma mark - 构建实例对象
- (instancetype)initWithFetchResult:(PHFetchResult<PHAsset *> *)fetchResult title:(NSString *)title
{
    self = [super init];
    if (self) {
        
        _title = [self transformAblumTitle:title];
        _count = fetchResult.count;
        _assetMs = [self assetModels:fetchResult];
        _selectAssetMs = [NSArray array];
    }
    return self;
}

+ (instancetype)albumModel:(PHFetchResult<PHAsset *> *)fetchResult title:(NSString *)title
{
    return [[self alloc] initWithFetchResult:fetchResult title:title];
}

- (instancetype)init
{
    NSAssert(NO, @"请使用\"+ albumModel:title:\"或\"- initWithFetchResult:title:\"构建对象");
    return nil;
}

+ (instancetype)new
{
    NSAssert(NO, @"请使用\"+ albumModel:title:\"或\"- initWithFetchResult:title:\"构建对象");
    return nil;
}

#pragma mark -
#pragma mark - 转换相册名称为中文
- (NSString *)transformAblumTitle:(NSString *)title
{
    if ([title isEqualToString:@"Recently Deleted"]) {
        return @"最近删除";
    } else if ([title isEqualToString:@"Slo-mo"]) {
        return @"慢动作";
    } else if ([title isEqualToString:@"Panoramas"]) {
        return @"全景图";
    } else if ([title isEqualToString:@"Videos"]) {
        return @"视频";
    } else if ([title isEqualToString:@"Camera Roll"]) {
        return @"相机胶卷";
    } else if ([title isEqualToString:@"Favorites"]) {
        return @"收藏";
    } else if ([title isEqualToString:@"Bursts"]) {
        return @"连拍";
    } else if ([title isEqualToString:@"Hidden"]) {
        return @"所有隐藏";
    } else if ([title isEqualToString:@"Time-lapse"]) {
        return @"延时";
    }else if ([title isEqualToString:@"Recently Added"]) {
        return @"最近添加";
    }else if ([title isEqualToString:@"Selfies"]) {
        return @"自拍";
    }else if ([title isEqualToString:@"Screenshots"]) {
        return @"屏幕快照";
    }else if ([title isEqualToString:@"All Photos"]) {
        return @"所有照片";
    }else {
        return title;
    }
}

#pragma mark -
#pragma mark - 转换得到LFAssetModel数组
- (NSArray<LFAssetModel *> *)assetModels:(PHFetchResult<PHAsset *> *)fetchResult
{
    NSMutableArray *temArr = [NSMutableArray array];
    [fetchResult enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LFAssetModel *asset = [LFAssetModel assetModel:obj];
        [temArr addObject:asset];
    }];
    
    return temArr;
}

#pragma mark -
#pragma mark - 获取已经选中的数量
- (void)setSelectAssetMs:(NSArray<LFAssetModel *> *)selectAssetMs
{
    _selectAssetMs = selectAssetMs;
    
    _selectCount = selectAssetMs.count;
    
    NSMutableArray *localIdentifierArr = [NSMutableArray array];
    [selectAssetMs enumerateObjectsUsingBlock:^(LFAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.select = YES;//设置选中状态
        [localIdentifierArr addObject:obj.localIdentifier];
    }];
    _localIdentifiers = localIdentifierArr;
}

- (void)setUnSelectAssetMs:(NSArray<LFAssetModel *> *)unSelectAssetMs
{
    _unSelectAssetMs = unSelectAssetMs;
    
    NSMutableArray *unLocalIdentifierArr = [NSMutableArray array];
    [unSelectAssetMs enumerateObjectsUsingBlock:^(LFAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.select = NO;//设置选中状态
        [unLocalIdentifierArr addObject:obj.localIdentifier];
    }];
    _unLocalIdentifiers = unLocalIdentifierArr;
}

@end
