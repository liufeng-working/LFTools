//
//  LFThumbnailViewController.m
//  test
//
//  Created by 刘丰 on 2017/1/23.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFThumbnailViewController.h"
#import "LFToolBarView.h"
#import "LFPreviewViewController.h"
#import "LFThumbnailItem.h"
#import "LFImagePickerController.h"

#define lfImagePickerController ((LFImagePickerController *)self.navigationController)

static NSString *identifier = @"LFThumbnailItem";
@interface LFThumbnailViewController ()<UICollectionViewDelegateFlowLayout, LFToolBarViewDelegate, LFThumbnailItemDelegate, LFPreviewViewControllerDelegate>

@property(nonatomic,weak) LFToolBarView *toolBarView;

@end

@implementation LFThumbnailViewController

#pragma mark -
#pragma mark - 懒加载
- (LFToolBarView *)toolBarView
{
    if (!_toolBarView) {
        LFToolBarView *toolView = [[LFToolBarView alloc] init];
        toolView.delegate = self;
        [self.navigationController.toolbar addSubview:toolView];
        _toolBarView = toolView;
    }
    return _toolBarView;
}

- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;//行间距
    layout.minimumInteritemSpacing = 5;//列间距
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //需要刷新表，改变选中状态
    [self.collectionView reloadData];
    //显示底部工具条
    self.navigationController.toolbarHidden = NO;
    //设置选中图片数量
    self.toolBarView.selectCount = lfImagePickerController.assets.count;
    //显示工具栏预览按钮
    [self.toolBarView hiddenPreviewButton:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.title = self.albumM.title;
    
    [self.collectionView registerClass:[LFThumbnailItem class] forCellWithReuseIdentifier:identifier];
    
    //右按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
}

#pragma mark -
#pragma mark - 重新布局子视图
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.collectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    self.toolBarView.frame = self.navigationController.toolbar.bounds;
}

#pragma mark -
#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
        return self.albumM.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LFAssetModel *assetM = self.albumM.assetMs[indexPath.row];
    LFThumbnailItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    item.assetM = assetM;
    item.delegate = self;
    return item;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = CGRectGetWidth(self.collectionView.bounds);
    CGFloat left = self.collectionView.contentInset.left;
    CGFloat right = self.collectionView.contentInset.right;
    CGFloat interitemSpacing = ((UICollectionViewFlowLayout *)self.collectionViewLayout).minimumInteritemSpacing;//列间距
    NSInteger col = 4;//列数
    CGFloat itemW = (width - left - right - (col - 1)*interitemSpacing) / col;
    return CGSizeMake(itemW, itemW);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 10, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LFPreviewViewController *previewVC = [[LFPreviewViewController alloc] init];
    previewVC.assets = self.albumM.assetMs;
    previewVC.currentIndex = indexPath.row;
    previewVC.delegate = self;
    [self.navigationController pushViewController:previewVC animated:YES];
}

#pragma mark -
#pragma mark - 点击图片控制器的取消按钮
- (void)cancelClick
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(thumbnailViewControllerDidCancel:)]) {
            [self.delegate thumbnailViewControllerDidCancel:self];
        }
    }];
}

#pragma mark -
#pragma mark - LFToolBarViewDelegate
- (void)toolBarViewDidClickPreview:(LFToolBarView *)toolBarView
{
    LFPreviewViewController *previewVC = [[LFPreviewViewController alloc] init];
    previewVC.assets = lfImagePickerController.assets;
    previewVC.delegate = self;
    [self.navigationController pushViewController:previewVC animated:YES];
}

- (void)toolBarViewDidClickFinish:(LFToolBarView *)toolBarView
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(thumbnailViewControllerDidFinishPicking:)]) {
            [self.delegate thumbnailViewControllerDidFinishPicking:self];
        }
    }];
}

#pragma mark -
#pragma mark - LFThumbnailItemDelegate
- (void)thumbnailItem:(LFThumbnailItem *)item didPickerClick:(BOOL)isSelect thumbnail:(UIImage *)thumbnail
{
    [self addDataAssetModel:item.assetM select:isSelect thumbnail:thumbnail];
}

#pragma mark -
#pragma mark - LFPreviewViewControllerDelegate
- (void)previewViewController:(LFPreviewViewController *)previewVC didClickWithAssetModel:(LFAssetModel *)assetModel select:(BOOL)isSelect thumbnail:(UIImage *)thumbnail
{
    [self addDataAssetModel:assetModel select:isSelect thumbnail:thumbnail];
}

- (void)addDataAssetModel:(LFAssetModel *)assetM select:(BOOL)isSelect thumbnail:(UIImage *)thumbnail
{
    if (isSelect) {
        LFImagePickerType type = [lfImagePickerController selectTypeFromMediaType:assetM.type];
        if (type == LFImagePickerTypeVideo &&
            assetM.duration > 60) {
            [self showAlertWithTitle:@"温馨提示" message:@"视频时间不能大于60秒" cancelTitle:nil sureTitle:@"知道了" complete:^{
                assetM.select = NO;
                [self.collectionView reloadData];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
            }];
            return;
        }
        
        switch (lfImagePickerController.type) {
            case LFImagePickerTypeUnknown: break;
            case LFImagePickerTypePhoto: {
                if (type != LFImagePickerTypePhoto) {
                    [self showAlertWithTitle:@"温馨提示" message:@"不能同时选择图片和视频" cancelTitle:nil sureTitle:@"知道了" complete:^{
                        assetM.select = NO;
                        [self.collectionView reloadData];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
                    }];
                    return;
                }
            }
                break;
            case LFImagePickerTypeVideo: {
                if (type == LFImagePickerTypePhoto) {
                    [self showAlertWithTitle:@"温馨提示" message:@"不能同时选择图片和视频" cancelTitle:nil sureTitle:@"知道了" complete:^{
                        assetM.select = NO;
                        [self.collectionView reloadData];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
                    }];
                }else {
                    [self showAlertWithTitle:@"温馨提示" message:@"只能选择一个视频" cancelTitle:nil sureTitle:@"知道了" complete:^{
                        assetM.select = NO;
                        [self.collectionView reloadData];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
                    }];
                }
            }
                return;
        }
    }
    
    NSMutableArray *temAssets = lfImagePickerController.assets.mutableCopy;
    NSMutableArray *temPublics = lfImagePickerController.publics.mutableCopy;
    if (isSelect) {//选中，装进数组
        [temAssets addObject:assetM];
        
        LFPublicModel *pub = [LFPublicModel publicModelWithImage:thumbnail type:assetM.type];
        [temPublics addObject:pub];
    }else {//取消选中，移出数组
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"localIdentifier == %@", assetM.localIdentifier];
        LFAssetModel *asset = [temAssets filteredArrayUsingPredicate:pre].firstObject;
        [temPublics removeObjectAtIndex:[temAssets indexOfObject:asset]];
        [temAssets removeObject:asset];
    }
    
    lfImagePickerController.assets = temAssets;
    lfImagePickerController.publics = temPublics;
    self.toolBarView.selectCount = temAssets.count;
}

- (void)dealloc
{
    /*
     由于导航控制器工具条的强引用，
     导致自定义工具条不能正常释放，
     造成每次进入这个页面都会添加一个自定义工具条，
     因此手动释放
     注：这里不能用self，因为控制器self已经销毁了
     */
    [_toolBarView removeFromSuperview];
}

@end
