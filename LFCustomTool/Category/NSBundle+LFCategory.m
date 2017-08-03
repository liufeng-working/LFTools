//
//  NSBundle+LFCategory.m
//  LFJXStreet
//
//  Created by 刘丰 on 2017/2/22.
//  Copyright © 2017年 liufeng. All rights reserved.
//

/*
 {
 BuildMachineOSBuild = 16D32;
 CFBundleDevelopmentRegion = en;
 CFBundleDisplayName = "\U5e73\U5b89\U6c5f\U6eaa";
 CFBundleExecutable = LFJXStreet;
 CFBundleIcons =     {
 CFBundlePrimaryIcon =         {
 CFBundleIconFiles =             (
 AppIcon20x20,
 AppIcon29x29,
 AppIcon40x40,
 AppIcon60x60
 );
 };
 };
 CFBundleIdentifier = "com.kaituo.LFJXStreet";
 CFBundleInfoDictionaryVersion = "6.0";
 CFBundleName = LFJXStreet;
 CFBundleNumericVersion = 16875520;
 CFBundlePackageType = APPL;
 CFBundleShortVersionString = "1.0.0";
 CFBundleSupportedPlatforms =     (
 iPhoneSimulator
 );
 CFBundleVersion = "1.0.1";
 DTCompiler = "com.apple.compilers.llvm.clang.1_0";
 DTPlatformBuild = "";
 DTPlatformName = iphonesimulator;
 DTPlatformVersion = "10.2";
 DTSDKBuild = 14C89;
 DTSDKName = "iphonesimulator10.2";
 DTXcode = 0820;
 DTXcodeBuild = 8C38;
 LSRequiresIPhoneOS = 1;
 MinimumOSVersion = "8.0";
 NSAppTransportSecurity =     {
 NSAllowsArbitraryLoads = 1;
 };
 NSPhotoLibraryUsageDescription = "\U5141\U8bb8\U6b64\U6743\U9650\U624d\U80fd\U4f7f\U7528\U76f8\U518c";
 UIDeviceFamily =     (
 1
 );
 UILaunchStoryboardName = LaunchScreen;
 UIMainStoryboardFile = Login;
 UIRequiredDeviceCapabilities =     (
 armv7
 );
 UIStatusBarHidden = 1;
 UIStatusBarStyle = UIStatusBarStyleDefault;
 UISupportedInterfaceOrientations =     (
 UIInterfaceOrientationPortrait
 );
 UIViewControllerBasedStatusBarAppearance = 0;
 }
 */

#import "NSBundle+LFCategory.h"

@implementation NSBundle (LFCategory)

- (NSString *)displayName
{
    return self.infoDictionary[@"CFBundleDisplayName"];
}

- (NSString *)bundleIdentifier
{
    return self.infoDictionary[@"CFBundleIdentifier"];
}

- (NSString *)version
{
    return self.infoDictionary[@"CFBundleShortVersionString"];
}

- (NSString *)build
{
    return self.infoDictionary[@"CFBundleVersion"];
}

@end
