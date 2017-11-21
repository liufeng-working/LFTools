//
//  LFImagePickerController.m
//  test
//
//  Created by 刘丰 on 2017/1/19.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFImagePickerController.h"
#import "LFAlbumViewController.h"
#import "LFPreviewViewController.h"

@interface LFImagePickerController ()<LFAlbumViewControllerDelegate, LFPreviewViewControllerDelegate>

@end

@implementation LFImagePickerController
@dynamic delegate;

- (NSArray<LFPublicModel *> *)publics
{
    if (!_publics) {
        _publics = [NSArray array];
    }
    return _publics;
}

#pragma mark -
#pragma mark - 初始化方法
- (instancetype)init
{
    return [self initWithShowPhotos:YES];
}

- (instancetype)initWithShowPhotos:(BOOL)show
{
    LFAlbumViewController *albumVC = [[LFAlbumViewController alloc] init];
    //由于调用了initWithRootViewController，执行这句时，会先调用viewDidLoad，然后执行剩下的init的方法，也就是不会懒加载view
    self = [super initWithRootViewController:albumVC];
    albumVC.delegate = self;
    if (self) {
        self.navigationBar.translucent = YES;
        
        _maxSelect = 9;
        _showPhotos = show;
        _showVideo = YES;
    }
    return self;
}

+ (instancetype)new
{
    NSAssert(NO, @"请使用\"- init\"来实例化对象");
    return nil;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    NSAssert(NO, @"请使用\"- init\"来实例化对象");
    return nil;
}

#pragma mark -
#pragma mark - 预览图片
- (instancetype)initPreviewWithAssets:(NSArray<LFAssetModel *> *)assetMs
                              publics:(NSArray<LFPublicModel *> *)publicMs
                                index:(NSInteger)index
{
    LFPreviewViewController *previewVC = [[LFPreviewViewController alloc] init];
    previewVC.delegate = self;
    previewVC.assets = assetMs;
    previewVC.currentIndex = index;
    previewVC.type = LFPreviewVCTypePublic;
    self = [super initWithRootViewController:previewVC];
    if (self) {
        _assets = assetMs;
        _publics = publicMs;
    }
    return self;
}

#pragma mark -
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];

}

#pragma mark -
#pragma mark - 获取选中照片的id
- (void)setAssets:(NSArray<LFAssetModel *> *)assets
{
    _assets = assets;
    
    if (assets.count == 0) {
        _type = LFImagePickerTypeUnknown;
    }else {
        _type = [self selectTypeFromMediaType:assets.firstObject.type];
    }
    
    NSMutableArray *localIdentifierArr = [NSMutableArray array];
    [assets enumerateObjectsUsingBlock:^(LFAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [localIdentifierArr addObject:obj.localIdentifier];
    }];
    _localIdentifiers = localIdentifierArr;
}

- (LFImagePickerType)selectTypeFromMediaType:(LFAssetMediaType)type
{
    switch (type) {
        case LFAssetMediaTypePhoto:
        case LFAssetMediaTypeGif:
            return LFImagePickerTypePhoto;
        case LFAssetMediaTypeVideo:
            return LFImagePickerTypeVideo;
        default:
            return LFImagePickerTypeUnknown;
    }
}


#pragma mark -
#pragma mark - LFAlbumViewControllerDelegate
- (void)albumViewControllerDidCancel:(LFAlbumViewController *)albumVC
{
    if ([self.delegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
        [self.delegate imagePickerControllerDidClickCancel:self];
    }
}

- (void)albumViewControllerDidFinishPicking:(LFAlbumViewController *)albumVC
{
    if ([self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingAssets:publics:)]) {
        [self.delegate imagePickerController:self didFinishPickingAssets:self.assets publics:self.publics];
    }
}

#pragma mark -
#pragma mark - LFPreviewViewControllerDelegate
- (void)previewViewController:(LFPreviewViewController *)previewVC didClickWithAssetModel:(LFAssetModel *)assetModel select:(BOOL)isSelect thumbnail:(UIImage *)thumbnail
{
    NSMutableArray *temAssets = self.assets.mutableCopy;
    NSMutableArray *temPublics = self.publics.mutableCopy;
    if (isSelect) {//选中，装进数组
        [temAssets addObject:assetModel];
        
        LFPublicModel *pub = [LFPublicModel publicModelWithImage:thumbnail type:assetModel.type];
        [temPublics addObject:pub];
    }else {//取消选中，移出数组
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"localIdentifier == %@", assetModel.localIdentifier];
        LFAssetModel *assetM = [temAssets filteredArrayUsingPredicate:pre].firstObject;
        [temPublics removeObjectAtIndex:[temAssets indexOfObject:assetM]];
        [temAssets removeObject:assetM];
    }
    
    self.assets = temAssets;
    self.publics = temPublics;
    
    if ([self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingAssets:publics:)]) {
        [self.delegate imagePickerController:self didFinishPickingAssets:self.assets publics:self.publics];
    }
}

- (void)previewViewControllerDidCancel:(LFPreviewViewController *)previewVC
{
    if ([self.delegate respondsToSelector:@selector(imagePickerControllerDidClickCancel:)]) {
        [self.delegate imagePickerControllerDidClickCancel:self];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)dealloc {
    //清空所有缓存数据
    [[LFImageManager manager] clearMemory];
}

@end

@implementation UIViewController (LFImagePickerController)

- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
               cancelTitle:(NSString *)cancelTitle
                 sureTitle:(NSString *)sureTitle
                  complete:(void(^)(void))com
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (cancelTitle) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
    }
    
    UIAlertAction *sure = [UIAlertAction actionWithTitle:sureTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        if (com) {
            com();
        }
    }];
    [alert addAction:sure];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
