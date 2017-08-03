//
//  UIDevice+LFCategory.h
//  test1
//
//  Created by NJWC on 16/8/31.
//  Copyright © 2016年 kaituo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**************************/
/*用这个宏 和下面的枚举 做比较*/
/**************************/
#define lfDevice_type_enum [[UIDevice currentDevice] deviceEnum]

typedef NS_ENUM(NSInteger, UIDeviceType){
    
    UIDeviceType_Unknown,
    
    //iPhone
    UIDeviceType_iPhone,
    UIDeviceType_iPhone_3G,
    UIDeviceType_iPhone_3GS,
    UIDeviceType_iPhone_4,
    UIDeviceType_iPhone_4S,
    UIDeviceType_iPhone_5,
    UIDeviceType_iPhone_5c,
    UIDeviceType_iPhone_5s,
    UIDeviceType_iPhone_6,
    UIDeviceType_iPhone_6_Plus,
    UIDeviceType_iPhone_6s,
    UIDeviceType_iPhone_6s_Plus,
    UIDeviceType_iPhone_SE,
    UIDeviceType_iPhone_7,
    UIDeviceType_iPhone_7_Plus,
    
    //iPod Touch
    UIDeviceType_iPod_touch,
    UIDeviceType_iPod_touch_2G,
    UIDeviceType_iPod_touch_3G,
    UIDeviceType_iPod_touch_4G,
    UIDeviceType_iPod_touch_5G,
    UIDeviceType_iPod_touch_6G,
    
    //iPad
    UIDeviceType_iPad,
    UIDeviceType_iPad_2,
    UIDeviceType_iPad_3,
    UIDeviceType_iPad_4,
    UIDeviceType_iPad_mini,
    UIDeviceType_iPad_mini_2,
    UIDeviceType_iPad_mini_3,
    UIDeviceType_iPad_mini_4,
    UIDeviceType_iPad_Air,
    UIDeviceType_iPad_Air_2,
    IDeviceType_iPad_Pro_9_7, //9.7inch
    IDeviceType_iPad_Pro_12_9,//12.9inch
    
    //Apple TV
    IDeviceType_Apple_TV_2G,
    IDeviceType_Apple_TV_3G,
    IDeviceType_Apple_TV_4G,
    
    //Apple Watch
    IDeviceType_Apple_Watch,
    
    //iPhone simulator
    IDeviceType_iPhone_Simulator,
};


/****************************/
/*用这个宏 与 下面的类型宏 做比较*/
/****************************/
#define lfDevice_type_define [[UIDevice currentDevice] deviceDefine]

#define DEVICE_UNKNOWN   @"device Unknown"
//iPhone
#define IPHONE           @"iPhone"
#define IPHONE_3G        @"iPhone 3G"
#define IPHONE_3GS       @"iPhone 3GS"
#define IPHONE_4         @"iPhone 4"
#define IPHONE_4S        @"iPhone 4S"
#define IPHONE_5         @"iPhone 5"
#define IPHONE_5c        @"iPhone 5c"
#define IPHONE_5s        @"iPhone 5s"
#define IPHONE_6         @"iPhone 6"
#define IPHONE_6Plus     @"iPhone 6 Plus"
#define IPHONE_6s        @"iPhone 6s"
#define IPHONE_6sPlus    @"iPhone 6s Plus"
#define IPHONE_SE        @"iPhone SE"
#define IPHONE_7         @"iPhone 7"
#define IPHONE_7Plus     @"iPhone 7 Plus"

//iPod touch
#define IPOD_TOUCH       @"iPod touch"
#define IPOD_TOUCH_2G    @"iPod touch 2G"
#define IPOD_TOUCH_3G    @"iPod touch 3G"
#define IPOD_TOUCH_4G    @"iPod touch 4G"
#define IPOD_TOUCH_5G    @"iPod touch 5G"
#define IPOD_TOUCH_6G    @"iPod touch 6G"

//iPad
#define IPAD             @"iPad"
#define IPAD_2           @"iPad 2"
#define IPAD_3           @"iPad 3"
#define IPAD_4           @"iPad 4"
#define IPAD_MINI        @"iPad mini"
#define IPAD_MINI_2      @"iPad mini 2"
#define IPAD_MINI_3      @"iPad mini 3"
#define IPAD_MINI_4      @"iPad mini 4"
#define IPAD_AIR         @"iPad Air"
#define IPAD_AIR_2       @"iPad Air 2"
#define IPAD_PRO_9_7     @"iPad Pro 9.7"
#define IPAD_PRO_12_9    @"iPad Pro 12.9"

//Apple TV
#define APPLE_TV_2G      @"Apple TV 2G"
#define APPLE_TV_3G      @"Apple TV 3G"
#define APPLE_TV_4G      @"Apple TV 4G"

//Apple Watch
#define APPLE_WATCH      @"Apple Watch"

//iPhone simulator
#define IPHONE_SIMULATOR @"iPhone Simulator"

typedef NS_ENUM(NSInteger, UIDeviceFamily){
    
    UIDeviceFamily_Unknown,
    UIDeviceFamily_iPhone,
    UIDeviceFamily_iPod_touch,
    UIDeviceFamily_iPad,
    UIDeviceFamily_Apple_TV,
    UIDeviceFamily_Apple_Watch,
};

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (LFCategory)

/**
 *  获取硬件信息
 */
@property (nonatomic, readonly) NSDate *systemUptime;
@property (nonatomic, readonly) int64_t diskSpace;
@property (nonatomic, readonly) int64_t diskSpaceFree;
@property (nonatomic, readonly) int64_t diskSpaceUsed;
@property (nonatomic, readonly) int64_t memoryTotal;
@property (nonatomic, readonly) int64_t memoryUsed;
@property (nonatomic, readonly) int64_t memoryFree;
@property (nonatomic, readonly) int64_t memoryActive;
@property (nonatomic, readonly) int64_t memoryInactive;
@property (nonatomic, readonly) int64_t memoryWired;
@property (nonatomic, readonly) int64_t memoryPurgable;
@property (nonatomic, readonly) NSUInteger cpuCount;
@property (nonatomic, readonly) float cpuUsage;
@property (nullable, nonatomic, readonly) NSArray<NSNumber *> *cpuUsagePerProcessor;

/**
 *  系统中代表设备的字符串
 */
- (NSString *)systemString;

/**
 *  自定义的代表设备的字符串
 */
- (NSString *)deviceString;

/**
 *  以枚举代表设备
 */
- (UIDeviceType)deviceEnum;

/**
 *  以宏代表设备
 */
- (NSString *)deviceDefine;

/**
 *  判断设备属于哪个父类（iPhone、iPad、iPod...）
 */
- (UIDeviceFamily)deviceFamily;

@end

NS_ASSUME_NONNULL_END
