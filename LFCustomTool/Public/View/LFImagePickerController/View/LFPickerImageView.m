//
//  LFPickerImageView.m
//  
//
//  Created by 刘丰 on 2017/1/23.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFPickerImageView.h"
#import "LFImagePickerTool.h"

#define kTimeFont [UIFont boldSystemFontOfSize:10]
#define KGifFont [UIFont boldSystemFontOfSize:13]
#define kGifFont1 [UIFont boldSystemFontOfSize:13]
#define kGifText @"动图"
#define kGifText1 @"GIF"
#define kVideoMaker [LFImagePickerTool imageNamed:@"videoMarker"]
#define kVideoMaker1 [LFImagePickerTool imageNamed:@"videoMarker1"]
@interface LFPickerImageView ()<LFPhotoPickerButtonDelegate>

/** 选择图片 */
@property(nonatomic,weak) LFPhotoPickerButton *photoPicker;

/** 视频标志 */
@property(nonatomic,weak) UIImageView *videoMarker;

/** 视频标志1 */
@property(nonatomic,weak) UIImageView *videoMarker1;
@property(nonatomic,weak) UILabel *videoTimeL;

/** gif标志 */
@property(nonatomic,weak) UILabel *gifMarker;
@property(nonatomic,weak) UILabel *gifMarker1;

@end

@implementation LFPickerImageView

#pragma mark -
#pragma mark - 懒加载控件
- (LFPhotoPickerButton *)photoPicker
{
    if (!_photoPicker) {
        LFPhotoPickerButton *photoPicker = [[LFPhotoPickerButton alloc] init];
        photoPicker.delegate = self;
        photoPicker.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        photoPicker.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        photoPicker.imageEdgeInsets = UIEdgeInsetsMake(2, 0, 0, 2);
        [self addSubview:photoPicker];
        _photoPicker = photoPicker;
    }
    return _photoPicker;
}

- (UIImageView *)videoMarker
{
    if (!_videoMarker) {
        UIImageView *player = [[UIImageView alloc] init];
        player.image = kVideoMaker;
        [self addSubview:player];
        _videoMarker = player;
    }
    return _videoMarker;
}

- (UIImageView *)videoMarker1
{
    if (!_videoMarker1) {
        UIImageView *video = [[UIImageView alloc] init];
        video.image = kVideoMaker1;
        [self addSubview:video];
        _videoMarker1 = video;
    }
    return _videoMarker1;
}

- (UILabel *)videoTimeL
{
    if (!_videoTimeL) {
        UILabel *videoTimeL = [[UILabel alloc] init];
        videoTimeL.backgroundColor = [UIColor clearColor];
        videoTimeL.font = kTimeFont;
        videoTimeL.textColor = [UIColor whiteColor];
        videoTimeL.textAlignment = NSTextAlignmentRight;
        [self addSubview:videoTimeL];
        _videoTimeL = videoTimeL;
    }
    return _videoTimeL;
}

- (UILabel *)gifMarker
{
    if (!_gifMarker) {
        UILabel *gifMarker = [[UILabel alloc] init];
        gifMarker.backgroundColor = [UIColor clearColor];
        gifMarker.font = KGifFont;
        gifMarker.text = kGifText;
        gifMarker.textColor = [UIColor whiteColor];
        gifMarker.textAlignment = NSTextAlignmentCenter;
        [self addSubview:gifMarker];
        _gifMarker = gifMarker;
    }
    return _gifMarker;
}

- (UILabel *)gifMarker1
{
    if (!_gifMarker1) {
        UILabel *gifMarker1 = [[UILabel alloc] init];
        gifMarker1.backgroundColor = [UIColor clearColor];
        gifMarker1.font = kGifFont1;
        gifMarker1.text = kGifText1;
        gifMarker1.textColor = [UIColor whiteColor];
        gifMarker1.textAlignment = NSTextAlignmentCenter;
        [self addSubview:gifMarker1];
        _gifMarker1 = gifMarker1;
    }
    return _gifMarker1;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.layer.masksToBounds = YES;
        self.type = LFPickerImageViewTypeNone;//默认为原始图片
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat width = CGRectGetWidth(self.bounds);
    
    self.photoPicker.frame = CGRectMake(CGRectGetWidth(self.bounds) - width*0.5, 0, width*0.5, height*0.5);
    
    CGFloat imgW = kVideoMaker.size.width;
    CGFloat supW = MIN(width, height);
    if (imgW >= supW*0.4) {
        imgW = supW*0.4;
    }
    self.videoMarker.bounds = CGRectMake(0, 0, imgW, imgW);
    self.videoMarker.center = self.center;
    
    CGFloat videoH = kVideoMaker1.size.height;
    CGFloat videoW = kVideoMaker1.size.width;
    self.videoMarker1.frame = CGRectMake(2, CGRectGetHeight(self.bounds) - videoH, videoW, videoH);
    
    CGFloat videoMarkerMaxX = CGRectGetMaxX(self.videoMarker1.frame);
    CGFloat videoMarkerMidY = CGRectGetMidY(self.videoMarker1.frame);
    CGFloat timeX = videoMarkerMaxX + 5;
    CGFloat timeH = kTimeFont.lineHeight;
    CGFloat timeY = videoMarkerMidY - timeH*0.5;
    CGFloat timeW = CGRectGetWidth(self.bounds) - timeX - 2;
    self.videoTimeL.frame = CGRectMake(timeX, timeY, timeW, timeH);
    
    CGSize gifS = [kGifText boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: KGifFont} context:nil].size;
    CGFloat gifW = gifS.width + 5;
    CGFloat gifH = gifS.height + 5;
    self.gifMarker.frame = CGRectMake(width - gifW, CGRectGetHeight(self.bounds) - gifH, gifW, gifH);
    
    CGSize gifS1 = [kGifText1 boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: kGifFont1} context:nil].size;
    CGFloat gifW1 = gifS1.width + 5;
    CGFloat gifH1 = gifS1.height + 5;
    self.gifMarker1.frame = CGRectMake(width - gifW1, CGRectGetHeight(self.bounds) - gifH1, gifW1, gifH1);
}

- (void)setType:(LFPickerImageViewType)type
{
    _type = type;
    
    //分析有哪几种类型
    BOOL photoPicker = YES, videoMarker = YES, videoMarker1 = YES, gifMarker = YES, gifMarker1 = YES;
    if (type != LFPickerImageViewTypeNone) {
        
        if (type&LFPickerImageViewTypePhoto) {//图片选择按钮
            photoPicker = NO;
        }
        
        if (type&LFPickerImageViewTypeVideo) {//播放按钮
            videoMarker = NO;
        }
        
        if (type&LFPickerImageViewTypeVideo1) {//摄像头+时间
            videoMarker1 = NO;
        }
        
        if (type&LFPickerImageViewTypeGif) {//动图 字样
            gifMarker = NO;
        }
        
        if (type&LFPickerImageViewTypeGif1) {//GIF 字样
            gifMarker1 = NO;
        }
    }
    
    [self setupHidden:photoPicker videoMarker:videoMarker videoMarker1:videoMarker1 gifMarker:gifMarker gifMarker1:gifMarker1];
}

- (void)setVideoTime:(NSString *)videoTime
{
    _videoTime = videoTime;
    
    self.videoTimeL.text = videoTime;
}

- (void)setupHidden:(BOOL)photoPicker videoMarker:(BOOL)videoMarker videoMarker1:(BOOL)videoMarker1 gifMarker:(BOOL)gifMarker gifMarker1:(BOOL)gifMarker1
{
    self.photoPicker.hidden = photoPicker;
    self.videoMarker.hidden = videoMarker;
    self.videoMarker1.hidden = videoMarker1;
    self.videoTimeL.hidden = videoMarker1;
    self.gifMarker.hidden = gifMarker;
    self.gifMarker1.hidden = gifMarker1;
}

- (void)setupSelect:(BOOL)select
{
    self.photoPicker.selected = select;
}

#pragma mark -
#pragma mark - LFPhotoPickerButton
- (void)photoPickerButtonClick:(LFPhotoPickerButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(pickerImageView:didPickerClick:)]) {
        [self.delegate pickerImageView:self didPickerClick:sender.selected];
    }
}

@end

@interface LFPhotoPickerButton ()

/** 按钮的动画 */
@property(nonatomic,strong) CAKeyframeAnimation *keyframeA;

@end

@implementation LFPhotoPickerButton

- (CAKeyframeAnimation *)keyframeA
{
    if (!_keyframeA) {
        CAKeyframeAnimation *keyframeA = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        keyframeA.values = @[@0, @1.2, @0.8, @1];
        _keyframeA = keyframeA;
    }
    return _keyframeA;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(photoPickerClick:) forControlEvents:UIControlEventTouchUpInside];
        [self setImage:[LFImagePickerTool imageNamed:@"pickerPhoto_normal"] forState:UIControlStateNormal];
        [self setImage:[LFImagePickerTool imageNamed:@"pickerPhoto_select"] forState:UIControlStateSelected];
    }
    return self;
}

#pragma mark -
#pragma mark - 图片选择与取消
- (void)photoPickerClick:(UIButton *)sender
{
    //改变选择状态
    sender.selected = !sender.selected;
    //给按钮增加动画
    if (sender.selected) {
        [sender.layer addAnimation:self.keyframeA forKey:@"photoPickerAnimaiton"];
    }else {
        [sender.layer removeAllAnimations];
    }
    
    if ([self.delegate respondsToSelector:@selector(photoPickerButtonClick:)]) {
        [self.delegate photoPickerButtonClick:self];
    }
}

- (void)dealloc {
    [self.layer removeAllAnimations];
}

@end
