//
//  LFImagePickerController.h
//  test
//
//  Created by 刘丰 on 2017/1/19.
//  Copyright © 2017年 liufeng. All rights reserved.
//

/************************************************************/
/** 图片选择器 */
/************************************************************/
#import <UIKit/UIKit.h>
#import "LFImageManager.h"
#import "LFPublicModel.h"

typedef NS_ENUM(NSInteger, LFImagePickerType) {
    LFImagePickerTypeUnknown = 0,
    LFImagePickerTypePhoto, //选择图片
    LFImagePickerTypeVideo,     //选择视频
};

@protocol LFImagePickerControllerDelegate;
@interface LFImagePickerController : UINavigationController

/**
 初始化方法

 @param show YES：展示所有照片 NO：展示相册列表（使用“- init”方法初始化默认YES）
 */
- (instancetype)initWithShowPhotos:(BOOL)show;

/**
 预览图片

 @param assetMs 图片模型
 @param publicMs 外界使用模型
 @param index 当前展示第几张
 */
- (instancetype)initWithAssets:(NSArray<LFAssetModel *> *)assetMs
                       publics:(NSArray<LFPublicModel *> *)publicMs
                         index:(NSInteger)index;

@property(nonatomic,weak) id<LFImagePickerControllerDelegate> pickerDelegate;

/**
 最大可选照片数，默认9
 */
@property(nonatomic,assign) NSInteger maxSelect;

/**
 是否直接显示照片
 */
@property(nonatomic,assign,readonly) BOOL showPhotos;

/**
 选择类型（无默认值，根据用户选择的第一个来确定）
 */
@property(nonatomic,assign) LFImagePickerType type;

/**
 选中照片的模型（注意：assets和publics都要赋值，否则会出现问题）
 */
@property(nonatomic,strong) NSArray<LFAssetModel *> *assets;

/**
 外界展示图像时使用（注意：assets和publics都要赋值，否则会出现问题）
 */
@property(nonatomic,strong) NSArray<LFPublicModel *> *publics;

/**
 所有选中照片的唯一标识符
 */
@property(nonatomic,strong,readonly) NSArray<NSString *> *localIdentifiers;

/**
 转换类型

 @param type 选择类型
 @return 媒体类型
 */
- (LFImagePickerType)selectTypeFromMediaType:(LFAssetMediaType)type;

@end

@protocol LFImagePickerControllerDelegate <NSObject>

@optional

/**
 取消
 */
- (void)imagePickerControllerDidCancel:(LFImagePickerController *)picker;

/**
 完成选择
 
 @param assetMs 选中图片的模型数组（可以用[[LFImageManager manager] imageData:complete:]获取原图data）
 @param publicMs 外界使用模型 数组
 */
- (void)imagePickerController:(LFImagePickerController *)picker
       didFinishPickingAssets:(NSArray<LFAssetModel *> *)assetMs
                      publics:(NSArray<LFPublicModel *> *)publicMs;

@end

@interface UIViewController (LFImagePickerController)

- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
               cancelTitle:(NSString *)cancelTitle
                 sureTitle:(NSString *)sureTitle
                  complete:(void(^)())com;

@end

