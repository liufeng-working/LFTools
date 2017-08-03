//
//  LFAlbumViewController.m
//  test
//
//  Created by 刘丰 on 2017/1/20.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFAlbumViewController.h"
#import "LFImagePickerController.h"
#import "LFThumbnailViewController.h"
#import "LFAlbumCell.h"

#define lfImagePickerController ((LFImagePickerController *)self.navigationController)
@interface LFAlbumViewController ()<LFThumbnailViewControllerDelegate>

@property(nonatomic,weak) NSTimer *timer;

@end

@implementation LFAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.title = @"相簿";
    
    //请求相册数据
    [self loadAlbumData];
    
    //去除分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //右按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
    
    //照片库不可用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [self showAlertWithTitle:@"温馨提示" message:@"照片库不可用，请检查后重试！" cancelTitle:nil sureTitle:@"知道了" complete:^{
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }];
        return;
    }
    
    //相册不可用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        [self showAlertWithTitle:@"温馨提示" message:@"相册不可用，请检查后重试！" cancelTitle:nil sureTitle:@"知道了" complete:^{
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }];
        return;
    }

    //根据授权状态，进行操作
    if (self.status == PHAuthorizationStatusNotDetermined) {//用户正在授权
        if (!self.timer) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(observeAuthrizationStatus) userInfo:nil repeats:YES];
        }
    }else if (self.status == PHAuthorizationStatusRestricted ||
              self.status == PHAuthorizationStatusDenied
              ){//没有访问权限
        NSString *displayName = [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"];
        NSString *message = [NSString stringWithFormat:@"请前往iPhone的\"设置->%@\"中打开\'照片\'按钮", displayName];
        
        [self showAlertWithTitle:@"照片库访问受限" message:message cancelTitle:@"取消" sureTitle:@"去设置" complete:^{//点击设置按钮后的处理逻辑
            NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if ([[UIApplication sharedApplication] canOpenURL:settingUrl]) {//可以打开设置
                UIApplication *app = [UIApplication sharedApplication];
                if ([app respondsToSelector:@selector(openURL:)]) {// >=ios10版本
                    [app openURL:settingUrl];
                }else {// <iOS10版本
                    [app openURL:settingUrl options:@{} completionHandler:nil];
                }
            }else {//不可以打开设置
                [self showAlertWithTitle:@"温馨提示" message:@"无法跳转到设置页面，请手动前往设置" cancelTitle:nil sureTitle:@"知道了" complete:^{
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                }];
            }
        }];
    }else if (self.status == PHAuthorizationStatusAuthorized) {//允许
        [self pushToPhotos];
    }
}

#pragma mark -
#pragma mark - 修改每个相册选中数量
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = YES;//隐藏工具条
    
    if (self.albumArr.count) {
        
        [self filter];
        [self.tableView reloadData];//刷新表
    }
}

#pragma mark -
#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.albumArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LFAlbumCell *cell = [LFAlbumCell albumCellWithTableView:tableView];
    cell.albumM = self.albumArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LFThumbnailViewController *thumbnailVC = [[LFThumbnailViewController alloc] init];
    thumbnailVC.albumM = self.albumArr[indexPath.row];
    thumbnailVC.delegate = self;
    [self.navigationController pushViewController:thumbnailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
}

#pragma mark -
#pragma mark - 检测授权状态的改变
- (void)observeAuthrizationStatus
{
    if (self.status == PHAuthorizationStatusNotDetermined) {//等待授权，坐等
        return;
    }
    
    //能走到这里，说明用户选择完毕，不管选择允许还是拒绝，都要关闭定时器
    if (self.timer) {//如果定时器存在，销毁
        [self.timer invalidate];
        self.timer = nil;
    }
    
    if (self.status == PHAuthorizationStatusAuthorized) {//允许访问
        [self loadAlbumData];//重新加载数据
        [self pushToPhotos];
    }else {//拒绝访问，退出
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark -
#pragma mark - 跳转到所有照片页面
- (void)pushToPhotos
{
    if (lfImagePickerController.showPhotos) {//允许跳转
        LFThumbnailViewController *thumbnailVC = [[LFThumbnailViewController alloc] init];
        thumbnailVC.delegate = self;
        thumbnailVC.albumM = self.albumArr.firstObject;
        [self.navigationController pushViewController:thumbnailVC animated:NO];
    }else {/*不允许跳转*/}
}

#pragma mark -
#pragma mark - 授权状态
- (PHAuthorizationStatus)status
{
    return [PHPhotoLibrary authorizationStatus];
}

#pragma mark -
#pragma mark - 请求相册数据
- (void)loadAlbumData
{
    //同步方法
    [[LFImageManager manager] allAlbums:YES completion:^(NSArray<LFAlbumModel *> *albumModels) {
        _albumArr = albumModels;
        
        if (albumModels.count) {
            [self filter];
        }
    }];
}

#pragma mark -
#pragma mark - 筛选出已经选择的图片
- (void)filter
{
    [self.albumArr enumerateObjectsUsingBlock:^(LFAlbumModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"localIdentifier IN %@", lfImagePickerController.localIdentifiers];
        NSPredicate *unPre = [NSPredicate predicateWithFormat:@"NOT(localIdentifier IN %@)", lfImagePickerController.localIdentifiers];
        obj.selectAssetMs = [obj.assetMs filteredArrayUsingPredicate:pre];
        obj.unSelectAssetMs = [obj.assetMs filteredArrayUsingPredicate:unPre];
    }];
}

#pragma mark -
#pragma mark - 点击相册页的取消按钮
- (void)cancelClick
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(albumViewControllerDidCancel:)]) {
            [self.delegate albumViewControllerDidCancel:self];
        }
    }];
}

#pragma mark -
#pragma mark - LFThumbnailViewControllerDelegate
- (void)thumbnailViewControllerDidCancel:(LFThumbnailViewController *)thumbnailVC
{
    if ([self.delegate respondsToSelector:@selector(albumViewControllerDidCancel:)]) {
        [self.delegate albumViewControllerDidCancel:self];
    }
}

- (void)thumbnailViewControllerDidFinishPicking:(LFThumbnailViewController *)thumbnailVC
{
    if ([self.delegate respondsToSelector:@selector(albumViewControllerDidFinishPicking:)]) {
        [self.delegate albumViewControllerDidFinishPicking:self];
    }
}

@end
