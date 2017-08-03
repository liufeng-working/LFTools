//
//  LFPreviewViewController.m
//  test
//
//  Created by 刘丰 on 2017/2/7.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFPreviewViewController.h"
#import "LFPreviewItem.h"
#import "LFImagePickerTool.h"
#import "LFToolBarView.h"
#import "LFImageView.h"
#import "LFAssetModel.h"
#import "LFImageManager.h"

@interface LFPreviewViewController ()<LFPreviewItemDelegate, LFPhotoPickerButtonDelegate>

@property(nonatomic,weak) LFPhotoPickerButton *pickerBtn;

@property(nonatomic,weak) LFPreviewItem *currentItem;

@property(nonatomic,weak) UILabel *numLabel;

@end

static NSString * const cellIdentifier = @"LFPreviewItem";
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
    [self.collectionView registerClass:[LFPreviewItem class] forCellWithReuseIdentifier:cellIdentifier];
    
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
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
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

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.type == LFPreviewVCTypePrevate) {
        
    }else if (self.type == LFPreviewVCTypePublic) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
}

#pragma mark -
#pragma mark - 隐藏导航条。。。
- (void)hiddenUI:(BOOL)hidden
{
    [self.navigationController setNavigationBarHidden:hidden animated:YES];
    [self.navigationController setToolbarHidden:hidden animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:UIStatusBarAnimationFade];
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
    LFPreviewItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    item.delegate = self;
    item.assetModel = assetModel;
    return item;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    LFAssetModel *assetM = self.assets[indexPath.row];
    self.pickerBtn.selected = assetM.isSelect;
    self.currentIndex = indexPath.row;
    if (self.type == LFPreviewVCTypePrevate) {
        
    }else if (self.type == LFPreviewVCTypePublic) {
        self.numLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)self.currentIndex + 1, (long)self.assets.count];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *currentIndexPath = collectionView.indexPathsForVisibleItems.firstObject;
    LFAssetModel *assetM = self.assets[currentIndexPath.row];
    self.pickerBtn.selected = assetM.isSelect;
    self.currentIndex = currentIndexPath.row;
    
    if (self.type == LFPreviewVCTypePrevate) {
        
    }else if (self.type == LFPreviewVCTypePublic) {
        self.numLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)self.currentIndex + 1, (long)self.assets.count];
    }
}

#pragma mark -
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    LFPreviewItem *item = (LFPreviewItem *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
    [item playEnd];//开始拖拽，停止播放
    
    if (self.type == LFPreviewVCTypePrevate) {
//        [self hiddenUI:YES];//滑动时隐藏
    }else if (self.type == LFPreviewVCTypePublic) {
        
    }
}

#pragma mark -
#pragma mark - LFPreviewItemDelegate
- (void)previewItemDidClick:(LFPreviewItem *)item
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
    LFPreviewItem *item = (LFPreviewItem *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
    item.assetModel.select = sender.isSelected;
    
    if (sender.isSelected) {//选中，需要缩略图
        [[LFImageManager manager] thumbnail:item.assetModel completion:^(UIImage *thumbnail, BOOL isThumbnail, LFAssetModel *model) {
            if (isThumbnail &&
                [self.delegate respondsToSelector:@selector(previewViewController:didClickWithAssetModel:select:thumbnail:)]) {
                [self.delegate previewViewController:self didClickWithAssetModel:model select:YES thumbnail:thumbnail];
            }
        }];
        //提前获取原图数据
//        [[LFImageManager manager] imageData:item.assetModel completion:nil];
    }else {//取消选中，不需要缩略图
        if ([self.delegate respondsToSelector:@selector(previewViewController:didClickWithAssetModel:select:thumbnail:)]) {
            [self.delegate previewViewController:self didClickWithAssetModel:item.assetModel select:NO thumbnail:nil];
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
