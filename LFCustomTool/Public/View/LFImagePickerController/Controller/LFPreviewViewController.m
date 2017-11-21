//
//  LFPreviewViewController.m
//  test
//
//  Created by 刘丰 on 2017/2/7.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFPreviewViewController.h"
#import "LFPreviewCell.h"
#import "LFImagePickerTool.h"
#import "LFToolBarView.h"
#import "LFPickerImageView.h"
#import "LFAssetModel.h"
#import "LFImageManager.h"

@interface LFPreviewViewController ()<LFPreviewCellDelegate, LFPhotoPickerButtonDelegate>

@property(nonatomic,weak) LFPhotoPickerButton *pickerBtn;

@property(nonatomic,weak) LFPreviewCell *currentCell;

@property(nonatomic,weak) UILabel *numLabel;

@end

static NSString * const cellIdentifier = @"LFPreviewCell";
@implementation LFPreviewViewController

#pragma mark -
#pragma mark - 懒加载数字label
- (UILabel *)numLabel
{
    if (!_numLabel) {
        UILabel *num = [[UILabel alloc] initWithFrame:CGRectMake(0, LFImagePickerScreenHeight - 44, LFImagePickerScreenWidth, 44)];
        num.textColor = [UIColor whiteColor];
        num.textAlignment = NSTextAlignmentCenter;
        num.font = [UIFont systemFontOfSize:15];
        [self.view addSubview:num];
        _numLabel = num;
    }
    return _numLabel;
}

- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(LFImagePickerScreenWidth, LFImagePickerScreenHeight);
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView registerClass:[LFPreviewCell class] forCellWithReuseIdentifier:cellIdentifier];
    
    //移动到点击的图片
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
    LFPhotoPickerButton *pickerBtn = [LFPhotoPickerButton buttonWithType:UIButtonTypeCustom];
    pickerBtn.delegate = self;
    self.pickerBtn = pickerBtn;

    if (self.type == LFPreviewVCTypePrevate) {
        self.navigationController.navigationBarHidden = NO;
        
        pickerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        pickerBtn.frame = CGRectMake(0, 0, 44, 44);
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:pickerBtn];
        self.pickerBtn = pickerBtn;
    }else if (self.type == LFPreviewVCTypePublic) {
        self.navigationController.navigationBarHidden = YES;
        
        pickerBtn.frame = CGRectMake(LFImagePickerScreenWidth - 64, 0, 64, 64);
        [self.view addSubview:pickerBtn];
        
        self.numLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)self.currentIndex + 1, (long)self.assets.count];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"reloadData" object:nil];
}

- (void)reloadData
{
    [self.collectionView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.type == LFPreviewVCTypePrevate) {
        //隐藏工具条上的预览按钮
        [self.navigationController.toolbar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[LFToolBarView class]]) {
                [((LFToolBarView *)obj) hiddenPreviewButton:YES];
                *stop = YES;
            }
        }];
    }else if (self.type == LFPreviewVCTypePublic) {
        
    }
}

#pragma mark -
#pragma mark - 隐藏导航条。。。
- (void)hiddenUI:(BOOL)hidden
{
    [self.navigationController setNavigationBarHidden:hidden animated:YES];
    [self.navigationController setToolbarHidden:hidden animated:YES];
}

#pragma mark -
#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LFAssetModel *assetModel = self.assets[indexPath.row];
    LFPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.assetModel = assetModel;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    LFAssetModel *assetM = self.assets[indexPath.row];
    self.pickerBtn.selected = assetM.isSelect;
    self.currentIndex = indexPath.row;
    self.numLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)self.currentIndex + 1, (long)self.assets.count];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *currentIndexPath = collectionView.indexPathsForVisibleItems.firstObject;
    LFAssetModel *assetM = self.assets[currentIndexPath.row];
    self.pickerBtn.selected = assetM.isSelect;
    self.currentIndex = currentIndexPath.row;
    
    self.numLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)self.currentIndex + 1, (long)self.assets.count];
}

#pragma mark -
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    LFPreviewCell *cell = (LFPreviewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
    [cell playEnd];//开始拖拽，停止播放
}

#pragma mark -
#pragma mark - LFPreviewCellDelegate
- (void)previewCellDidClick:(LFPreviewCell *)cell
{
    if (self.type == LFPreviewVCTypePrevate) {
        BOOL isHidden = !self.navigationController.navigationBar.hidden;
        [self hiddenUI:isHidden];
    }else if (self.type == LFPreviewVCTypePublic) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            if ([self.delegate respondsToSelector:@selector(previewViewControllerDidCancel:)]) {
                [self.delegate previewViewControllerDidCancel:self];
            }
        }];
    }
}

#pragma mark -
#pragma mark - LFPhotoPickerButtonDelegate
- (void)photoPickerButtonClick:(LFPhotoPickerButton *)sender
{
    LFPreviewCell *cell = (LFPreviewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
    cell.assetModel.select = sender.isSelected;
    
    if (sender.isSelected) {//选中，需要缩略图
        [[LFImageManager manager] thumbnail:cell.assetModel completion:^(UIImage *thumbnail, BOOL isThumbnail, LFAssetModel *model) {
            if (isThumbnail &&
                [self.delegate respondsToSelector:@selector(previewViewController:didClickWithAssetModel:select:thumbnail:)]) {
                [self.delegate previewViewController:self didClickWithAssetModel:model select:YES thumbnail:thumbnail];
            }
        }];
        //提前获取原图数据
//        [[LFImageManager manager] imageData:item.assetModel completion:nil];
    }else {//取消选中，不需要缩略图
        if ([self.delegate respondsToSelector:@selector(previewViewController:didClickWithAssetModel:select:thumbnail:)]) {
            [self.delegate previewViewController:self didClickWithAssetModel:cell.assetModel select:NO thumbnail:nil];
        }
    }
}

//- (BOOL)prefersStatusBarHidden {
//    return self.type == LFPreviewVCTypePublic;
//}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
