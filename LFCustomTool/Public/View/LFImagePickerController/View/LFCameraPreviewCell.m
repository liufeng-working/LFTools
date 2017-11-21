//
//  LFCameraPreviewCell.m
//  ImagePicker
//
//  Created by 刘丰 on 2017/11/17.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFCameraPreviewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "LFImagePickerTool.h"

@interface LFCameraPreviewCell ()

@property(nonatomic,strong) AVCaptureSession *session;

@property(nonatomic,weak) UIImageView *cameraView;

@end

@implementation LFCameraPreviewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    }
    return self;
}

- (AVCaptureSession *)session
{
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
        
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
        if ([_session canAddInput:input] && [_session canAddOutput:output]) {
            [_session addInput:input];
            [_session addOutput:output];
        }
        
        AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
        previewLayer.frame = self.contentView.bounds;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.contentView.layer addSublayer:previewLayer];
    }
    return _session;
}

- (UIImageView *)cameraView
{
    if (!_cameraView) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[LFImagePickerTool imageNamed:@"camera"]];
        [self.contentView addSubview:imageView];
        _cameraView = imageView;
    }
    return _cameraView;
}

- (void)start
{
    if (!self.session.isRunning) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.session startRunning];
        });
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.cameraView.center = self.contentView.center;
}

- (void)dealloc {
    [self.session stopRunning];
}

@end
