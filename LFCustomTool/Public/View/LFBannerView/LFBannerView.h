//
//  LFBannerView.h
//  LFJXStreet
//
//  Created by 刘丰 on 2017/1/12.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFBannerModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LFBannerViewDelegate;
@interface LFBannerView : UIView

@property(nonatomic,strong) NSArray<LFBannerModel *> *banners;

@property(nonatomic,weak) IBOutlet id<LFBannerViewDelegate> delegate;

/**
 打开／销毁定时器
 */
- (void)fire;
- (void)invalidate;

@end

@protocol LFBannerViewDelegate <NSObject>

@optional
- (void)bannerView:(LFBannerView *)banner didSelectItemAtIndex:(NSInteger)index bannerModel:(LFBannerModel *)bannerModel;

@end

NS_ASSUME_NONNULL_END
