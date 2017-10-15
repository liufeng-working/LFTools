//
//  LFImageManager.m
//  test
//
//  Created by 刘丰 on 2017/1/19.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFImageManager.h"
#import "LFImagePickerTool.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface LFImageManager ()

/** 内存缓存 */
@property(nonatomic,strong) NSCache<NSString *, UIImage *> *memCache;

/** 磁盘缓存 */
@property(nonatomic,strong) NSFileManager *fileManager;

@property(nonatomic,copy) NSString *cachePath;

@property(nonatomic,copy) LFImageManagerSaveSuccess saveSuccess;
@property(nonatomic,copy) LFImageManagerSaveFailure saveFailure;

@end

static LFImageManager *_manager = nil;
@implementation LFImageManager

#pragma mark -
#pragma mark - 获取单例对象
+ (instancetype)manager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [super allocWithZone:zone];
        
        _manager.memCache = [[NSCache alloc] init];
        _manager.memCache.totalCostLimit = 100*1024*1024;
        
        _manager.fileManager = [NSFileManager defaultManager];
        
        _manager.cachePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"com.liufeng.LFImagePickerController.imageCache"];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:_manager selector:@selector(clearMemory) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    });
    return _manager;
}

+ (instancetype)new
{
    NSAssert(NO, @"请使用 \"+ manager\"或者\"- init\"进行初始化");
    return nil;
}

#pragma mark -
#pragma mark - 获取相册
- (void)allAlbums:(BOOL)showVideo
       completion:(void (^)(NSArray<LFAlbumModel *> *albumModels))completion
{
    //type/subType决定了获取到的相册是什么
    //相机相册
    PHFetchResult<PHAssetCollection *> *rollAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    //视频
    PHFetchResult<PHAssetCollection *> *videoAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumVideos options:nil];
    //最近添加
    PHFetchResult<PHAssetCollection *> *addAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumRecentlyAdded options:nil];
    //屏幕快照
    PHFetchResult<PHAssetCollection *> *shotAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumScreenshots options:nil];
    //用户在Photos中创建的相册
    PHFetchResult<PHAssetCollection *> *regularAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    NSArray<PHFetchResult *> *allAlbums = @[rollAlbum, videoAlbum, addAlbum, shotAlbum, regularAlbums];

    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    if (!showVideo) option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    NSMutableArray *albumArr = [NSMutableArray array];
    for (PHFetchResult<PHAssetCollection *> *fetchResult in allAlbums) {
        
        [fetchResult enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            PHFetchResult<PHAsset *> *assetResult = [PHAsset fetchAssetsInAssetCollection:obj options:option];
            //过滤没有图片的相册
            if (assetResult.count) {
                LFAlbumModel *albumModel = [LFAlbumModel albumModel:assetResult title:obj.localizedTitle];
                [albumArr addObject:albumModel];
            }
        }];
    }
    
    if (completion) {
        completion(albumArr);
    }
}

- (void)videoAlbumCompletion:(void (^)(LFAlbumModel *albumModel))completion
{
    PHFetchResult<PHAssetCollection *> *videoAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumVideos options:nil];
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    //按创建时间升序排列
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult<PHAsset *> *fetchResult = [PHAsset fetchAssetsInAssetCollection:videoAlbum.firstObject options:option];
    LFAlbumModel *albumModel = [LFAlbumModel albumModel:fetchResult title:videoAlbum.firstObject.localizedTitle];
    if (completion) {
        completion(albumModel);
    }
}

- (void)rollAlbums:(BOOL)showVideo
       completion:(void (^)(LFAlbumModel *albumM))completion
{
    //type/subType决定了获取到的相册是什么
    //相机相册
    PHFetchResult<PHAssetCollection *> *rollAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    if (!showVideo) option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        
    PHFetchResult<PHAsset *> *assetResult = [PHAsset fetchAssetsInAssetCollection:rollAlbum.firstObject options:option];
    LFAlbumModel *albumModel = [LFAlbumModel albumModel:assetResult title:rollAlbum.firstObject.localizedTitle];
    
    if (completion) {
        completion(albumModel);
    }
}

//获取缩略图
- (void)thumbnail:(LFAssetModel *)assetM
       completion:(void (^)(UIImage *thumbnail, BOOL isThumbnail, LFAssetModel *model))completion
{
    //缓存的图片
    NSString *key = [self key:assetM suffix:@"thumbnail"];
    UIImage *cacheImage = [self imageForKey:key];
    if (cacheImage) {
        if (completion) {
            completion(cacheImage, YES, assetM);
        }
        return;
    }
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    [[PHImageManager defaultManager] requestImageForAsset:assetM.asset targetSize:CGSizeMake(50*scale, 50*scale) contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        //缓存清晰点的图
        BOOL isDegraded = ![info[PHImageResultIsDegradedKey] boolValue];
        if (completion) {
            completion(result, isDegraded, assetM);
        }
        
        if (isDegraded) {
            //缓存图片
            [self saveImage:result key:key];
        }
    }];
    if (assetM.type == LFAssetMediaTypeGif) {
        [[LFImageManager manager] imageData:assetM completion:nil];//如果是gif提前获取数据
    }
}

//获取大图
- (void)big:(LFAssetModel *)assetM
 completion:(void (^)(UIImage *big, BOOL isBig))completion
{
    //缓存的图片
    NSString *key = [self key:assetM suffix:@"big"];
    UIImage *cacheImage = [self imageForKey:key];
    if (cacheImage) {
        if (completion) {
            completion(cacheImage, YES);
        }
        return;
    }
    
    if (assetM.type == LFAssetMediaTypeGif) {
        [self imageData:assetM completion:^(NSData *imageData) {
            UIImage *gifImage = [LFImagePickerTool gifImageWithData:imageData];
            if (completion) {
                completion(gifImage, YES);
            }
            
            //缓存数据
            [self saveImageDataToDisk:imageData key:key];
        }];
    }else {
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
        option.resizeMode = PHImageRequestOptionsResizeModeFast;
        
        CGSize imageSize = CGSizeMake(assetM.asset.pixelWidth, assetM.asset.pixelHeight);
        CGSize fitSize = [LFImagePickerTool fitSize:imageSize maxSize:CGSizeMake(LFImagePickerScreenWidth*[UIScreen mainScreen].scale, CGFLOAT_MAX)];
        [[PHImageManager defaultManager] requestImageForAsset:assetM.asset targetSize:fitSize contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            //是否大图
            BOOL isBig = ![info[PHImageResultIsDegradedKey] boolValue];
            if (completion) {
                completion(result, isBig);
            }
            
            if (isBig) {
                //缓存图片
                [self saveImage:result key:key];
            }
        }];
    }
}

/**
 获取原图
 */
- (void)original:(LFAssetModel *)assetM
      completion:(void (^)(UIImage *original))completion
{
    //缓存的图片
    NSString *key = [self key:assetM suffix:@"original"];
    UIImage *cacheImage = [self imageForKey:key];
    if (cacheImage) {
        if (completion) {
            completion(cacheImage);
        }
        return;
    }
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    [[PHImageManager defaultManager] requestImageForAsset:assetM.asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (completion) {
            completion(result);
        }
        //缓存图片
        [self saveImage:result key:key];
    }];
}

/**
 图片二进制数据
 */
- (void)imageData:(LFAssetModel *)assetM
       completion:(void (^)(NSData *imageData))completion
{
    if (assetM.type != LFAssetMediaTypePhoto &&
        assetM.type != LFAssetMediaTypeGif) {
        if (completion) {
            completion(nil);
        }
        return;
    }
    
    //缓存的图片
    NSString *key = [self key:assetM suffix:@"data"];
    NSData *data = [self imageDataFromDiskForKey:key];
    if (data) {
        if (completion) {
            completion(data);
        }
        return;
    }
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    [[PHImageManager defaultManager] requestImageDataForAsset:assetM.asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        if (completion) {
            completion(imageData);
        }
        [self saveImageDataToDisk:imageData key:key];
    }];
}

/**
 获取视频
 */
- (void)video:(LFAssetModel *)assetM
   completion:(void (^)(AVPlayerItem *playerItem))completion
{
    if (assetM.type != LFAssetMediaTypeVideo) {
        if (completion) {
            completion(nil);
        }
        return;
    }
    
    PHVideoRequestOptions *option = [[PHVideoRequestOptions alloc] init];
    option.networkAccessAllowed = NO;
    option.version = PHVideoRequestOptionsVersionOriginal;
    option.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    [[PHImageManager defaultManager] requestPlayerItemForVideo:assetM.asset options:option resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(playerItem);
            }
        });
    }];
}

/**
 视频二进制数据
 */
- (void)videoData:(LFAssetModel *)assetM
       completion:(void (^)(NSData *videoData, CGSize size, NSError *error))completion
{
    if (assetM.type != LFAssetMediaTypeVideo) {
        if (completion) {
            completion(nil, CGSizeZero, nil);
        }
        return;
    }
    
    PHVideoRequestOptions* options = [[PHVideoRequestOptions alloc] init];
    options.version = PHVideoRequestOptionsVersionOriginal;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    options.networkAccessAllowed = YES;
    [[PHImageManager defaultManager] requestAVAssetForVideo:assetM.asset options:options resultHandler:^(AVAsset* avasset, AVAudioMix* audioMix, NSDictionary* info){
        
        NSArray *presets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avasset];

        //压缩比例
        AVAssetExportSession *session;
        if ([presets containsObject:AVAssetExportPresetMediumQuality]) {
            session = [[AVAssetExportSession alloc] initWithAsset:avasset presetName:AVAssetExportPresetMediumQuality];
        }else if ([presets containsObject:AVAssetExportPreset640x480]) {
            session = [[AVAssetExportSession alloc] initWithAsset:avasset presetName:AVAssetExportPreset640x480];
        }else if ([presets containsObject:AVAssetExportPreset960x540]) {
            session = [[AVAssetExportSession alloc] initWithAsset:avasset presetName:AVAssetExportPreset960x540];
        }else {
            session = [[AVAssetExportSession alloc] initWithAsset:avasset presetName:presets.firstObject];
        }
        
        //视频名称
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd-HH-mm-ss-SSS"];
        NSString *dateStr = [formater stringFromDate:[NSDate date]];
        NSString *outputPath = [NSTemporaryDirectory() stringByAppendingFormat:@"video_%@.mp4", dateStr];
        
        //地址
        session.outputURL = [NSURL fileURLWithPath:outputPath];
        //网络优化
        session.shouldOptimizeForNetworkUse = YES;
        //格式
        session.outputFileType = AVFileTypeMPEG4;

        //临时存入本地
        [session exportAsynchronouslyWithCompletionHandler:^(void) {
            switch (session.status) {
                case AVAssetExportSessionStatusUnknown: //未知
                case AVAssetExportSessionStatusFailed: {//失败
                    if (completion) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(nil, CGSizeZero, [NSError new]);
                        });
                    }
                }
                    break;
                case AVAssetExportSessionStatusWaiting:
                case AVAssetExportSessionStatusExporting:
                case AVAssetExportSessionStatusCancelled:
                    break;
                case AVAssetExportSessionStatusCompleted: {//成功
                    NSData *videoData = [NSData dataWithContentsOfFile:outputPath];
                    if (videoData) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            AVAsset *video = [AVAsset assetWithURL:[NSURL fileURLWithPath:outputPath]];
                            CGSize size = [self videoSizeFromAVAsset:video];
                            if (completion) {
                                completion(videoData, size, nil);
                            }
                            [self.fileManager removeItemAtPath:outputPath error:nil];//移除视频
                        });
                    }else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (completion) {
                                completion(nil, CGSizeZero, [NSError new]);
                            }
                        });
                    }    
                }
                    break;
            }
        }];
        
    }];
}


//获取视频分辨率
- (CGSize)videoSizeFromAVAsset:(AVAsset *)asset {
    AVAssetTrack *track = [asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
    CGSize size = track.naturalSize;
    CGAffineTransform t = track.preferredTransform;
    if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0) {
        return CGSizeMake(size.height, size.width);
    }
    
    return size;
}

//保存图片
- (void)savePhotoToPhotosAlbum:(UIImage *)image
                       success:(LFImageManagerSaveSuccess)success
                       failure:(LFImageManagerSaveFailure)failure
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        self.saveSuccess = success;
        self.saveFailure = failure;
    });
}

//保存视频到相册
- (void)saveVideoToPhotosAlbum:(NSURL *)videoPath
                       success:(LFImageManagerSaveSuccess)success
                       failure:(LFImageManagerSaveFailure)failure
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UISaveVideoAtPathToSavedPhotosAlbum(videoPath.path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        self.saveSuccess = success;
        self.saveFailure = failure;
    });
}

//保存图片完成后
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [self saveFinishWithError:error type:LFAssetMediaTypePhoto];
}

//保存视频完成后
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [self saveFinishWithError:error type:LFAssetMediaTypeVideo];
}

//保存图片／视频完成后
- (void)saveFinishWithError:(NSError *)error type:(LFAssetMediaType)type
{
    if (!error) {
        if (self.saveSuccess) {
            [self rollAlbums:YES completion:^(LFAlbumModel *albumM) {
                LFAssetModel *a = albumM.assetMs.firstObject;
                a.select = YES;
                [self thumbnail:a completion:^(UIImage *thumbnail, BOOL isThumbnail, LFAssetModel *model) {
                    if (isThumbnail) {
                        LFPublicModel *p = [LFPublicModel publicModelWithImage:thumbnail type:type];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.saveSuccess(a, p);
                        });
                    }
                }];
                [self big:a completion:nil];//提前请求大图
            }];
        }
    }else {
        if (self.saveFailure) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.saveFailure();
            });
        }
    }
}

#pragma mark -
#pragma mark - 清空内存缓存
- (void)clearMemory
{
    [self.memCache removeAllObjects];
}

- (void)clearDiskOnCompletion:(void(^)())completion
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.fileManager removeItemAtPath:self.cachePath error:nil];
        [self.fileManager createDirectoryAtPath:self.cachePath withIntermediateDirectories:YES attributes:nil error:NULL];
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        }
    });
}

#pragma mark -
#pragma mark - 磁盘缓存
- (NSUInteger)getSize
{
    __block NSUInteger size = 0;
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        NSDirectoryEnumerator *fileEnumerator = [self.fileManager enumeratorAtPath:self.cachePath];
        for (NSString *fileName in fileEnumerator) {
            NSString *filePath = [self.cachePath stringByAppendingPathComponent:fileName];
            NSDictionary<NSString *, id> *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
            size += [attrs fileSize];
        }
    });
    
    return size;
}

#pragma mark -
#pragma mark - 缓存图片
- (void)saveImage:(UIImage *)image
              key:(NSString *)key
{
    if (!image || !key) { return; }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSUInteger cost = image.size.height * image.size.width * image.scale * image.scale;
        [self.memCache setObject:image forKey:key cost:cost];
        NSData *data;
        if ([[key uppercaseString] hasSuffix:@"PNG"]) {
            data = UIImagePNGRepresentation(image);
        }else {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        
        [self saveImageDataToDisk:data key:key];
    });
    
}

- (void)saveImageDataToDisk:(NSData *)imageData
                        key:(NSString *)key
{
    if (!imageData || !key) { return; }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        if (![self.fileManager fileExistsAtPath:self.cachePath]) {
            [self.fileManager createDirectoryAtPath:self.cachePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString *filePath = [self.cachePath stringByAppendingPathComponent:key];
        [self.fileManager createFileAtPath:filePath contents:imageData attributes:nil];
    });
}

#pragma mark -
#pragma mark - 获取图片
- (UIImage *)imageForKey:(NSString *)key
{
    if (!key) { return nil; }
    UIImage *memoryImage = [self.memCache objectForKey:key];
    if (memoryImage) {
        return memoryImage;
    }
    
    NSData *data = [self imageDataFromDiskForKey:key];
    UIImage *diskImage = [LFImagePickerTool gifImageWithData:data];
    
    if (diskImage) {
        NSUInteger cost = diskImage.size.height*diskImage.size.width*diskImage.scale*diskImage.scale;
        [self.memCache setObject:diskImage forKey:key cost:cost];
    }
    
    return diskImage;
}

- (NSData *)imageDataFromDiskForKey:(NSString *)key
{
    if (!key) { return nil; }
    NSString *filePath = [self.cachePath stringByAppendingPathComponent:key];
    return [NSData dataWithContentsOfFile:filePath];
}

- (NSString *)key:(LFAssetModel *)assetM suffix:(NSString *)suffix
{
    return [NSString stringWithFormat:@"%@_%@.%@", assetM.ID, suffix, assetM.suffix];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

@end
