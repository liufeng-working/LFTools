//
//  UIDevice+LFCategory.m
//  test1
//
//  Created by NJWC on 16/8/31.
//  Copyright © 2016年 kaituo. All rights reserved.
//

#import "UIDevice+LFCategory.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <mach/mach_init.h>
#include <mach/mach_host.h>
#include <mach/vm_map.h>

#define kUserDefaults [NSUserDefaults standardUserDefaults]

@implementation UIDevice (LFCategory)

- (NSDate *)systemUptime
{
    NSTimeInterval time = [[NSProcessInfo processInfo] systemUptime];
    return [[NSDate alloc] initWithTimeIntervalSinceNow:(0 - time)];
}

- (int64_t)diskSpace
{
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}

- (int64_t)diskSpaceFree
{
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemFreeSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}

- (int64_t)diskSpaceUsed
{
    int64_t total = self.diskSpace;
    int64_t free = self.diskSpaceFree;
    if (total < 0 || free < 0) return -1;
    int64_t used = total - free;
    if (used < 0) used = -1;
    return used;
}

- (int64_t)memoryTotal
{
    int64_t mem = [[NSProcessInfo processInfo] physicalMemory];
    if (mem < -1) mem = -1;
    return mem;
}

- (int64_t)memoryUsed
{
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return page_size * (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count);
}

- (int64_t)memoryFree
{
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.free_count * page_size;
}

- (int64_t)memoryActive {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.active_count * page_size;
}

- (int64_t)memoryInactive {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.inactive_count * page_size;
}

- (int64_t)memoryWired {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.wire_count * page_size;
}

- (int64_t)memoryPurgable {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.purgeable_count * page_size;
}

- (NSUInteger)cpuCount {
    return [NSProcessInfo processInfo].activeProcessorCount;
}

- (float)cpuUsage {
    float cpu = 0;
    NSArray *cpus = [self cpuUsagePerProcessor];
    if (cpus.count == 0) return -1;
    for (NSNumber *n in cpus) {
        cpu += n.floatValue;
    }
    return cpu;
}

- (NSArray *)cpuUsagePerProcessor {
    processor_info_array_t _cpuInfo, _prevCPUInfo = nil;
    mach_msg_type_number_t _numCPUInfo, _numPrevCPUInfo = 0;
    unsigned _numCPUs;
    NSLock *_cpuUsageLock;
    
    int _mib[2U] = { CTL_HW, HW_NCPU };
    size_t _sizeOfNumCPUs = sizeof(_numCPUs);
    int _status = sysctl(_mib, 2U, &_numCPUs, &_sizeOfNumCPUs, NULL, 0U);
    if (_status)
        _numCPUs = 1;
    
    _cpuUsageLock = [[NSLock alloc] init];
    
    natural_t _numCPUsU = 0U;
    kern_return_t err = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &_numCPUsU, &_cpuInfo, &_numCPUInfo);
    if (err == KERN_SUCCESS) {
        [_cpuUsageLock lock];
        
        NSMutableArray *cpus = [NSMutableArray new];
        for (unsigned i = 0U; i < _numCPUs; ++i) {
            Float32 _inUse, _total;
            if (_prevCPUInfo) {
                _inUse = (
                          (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE])
                          );
                _total = _inUse + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE]);
            } else {
                _inUse = _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE];
                _total = _inUse + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE];
            }
            [cpus addObject:@(_inUse / _total)];
        }
        
        [_cpuUsageLock unlock];
        if (_prevCPUInfo) {
            size_t prevCpuInfoSize = sizeof(integer_t) * _numPrevCPUInfo;
            vm_deallocate(mach_task_self(), (vm_address_t)_prevCPUInfo, prevCpuInfoSize);
        }
        return cpus;
    } else {
        return nil;
    }
}

/**
 *  系统中代表设备的字符串
 */
- (NSString *)systemString
{
    NSString *platform = [kUserDefaults objectForKey:@"systemString"];
    if (platform) {
        return platform;
    }
    //第一种方法
    /*
     size_t size;
     sysctlbyname("hw.machine", NULL, &size, NULL, 0);
     char *machine = (char *)malloc(size);
     sysctlbyname("hw.machine", machine, &size, NULL, 0);
     NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
     free(machine);
     */
    //第二种方法（个人感觉这个方法好点）
    size_t size;
    int mib[2] = {CTL_HW, HW_MACHINE};
    sysctl(mib, 2, NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctl(mib, 2, machine, &size, NULL, 0);
    platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    [kUserDefaults setObject:platform forKey:@"systemString"];
    [kUserDefaults synchronize];
    
    return platform;
}

/**
 *  自定义的代表设备的字符串
 */
- (NSString *)deviceString
{
    NSString *platform = [self systemString];
    
    //来源https://www.theiphonewiki.com/wiki/Models
    //iPhone
    if ([platform isEqualToString:@"iPhone1,1"])  return @"iPhone";
    if ([platform isEqualToString:@"iPhone1,2"])  return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])  return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])  return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])  return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])  return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])  return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])  return @"iPhone 5(GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])  return @"iPhone 5(GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])  return @"iPhone 5c(GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])  return @"iPhone 5c(GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,1"])  return @"iPhone 5s(GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])  return @"iPhone 5s(GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone7,1"])  return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])  return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"])  return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"])  return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"])  return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"])  return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"])  return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone9,3"])  return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,4"])  return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone10,1"])  return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"])  return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"])  return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,4"])  return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,5"])  return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,6"])  return @"iPhone X";
    
    //iPod Touch
    if ([platform isEqualToString:@"iPod1,1"])    return @"iPod touch";
    if ([platform isEqualToString:@"iPod2,1"])    return @"iPod touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])    return @"iPod touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])    return @"iPod touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])    return @"iPod touch 5G";
    if ([platform isEqualToString:@"iPod7,1"])    return @"iPod touch 6G";
    
    //iPad
    if ([platform isEqualToString:@"iPad1,1"])    return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])    return @"iPad 2(WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])    return @"iPad 2(GSM)";
    if ([platform isEqualToString:@"iPad2,3"])    return @"iPad 2(CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])    return @"iPad 2(WiFi))";
    if ([platform isEqualToString:@"iPad2,5"])    return @"iPad mini(WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])    return @"iPad mini(GSM)";
    if ([platform isEqualToString:@"iPad2,7"])    return @"iPad mini(GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])    return @"iPad 3(WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])    return @"iPad 3(GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])    return @"iPad 3(GSM)";
    if ([platform isEqualToString:@"iPad3,4"])    return @"iPad 4(WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])    return @"iPad 4(GSM)";
    if ([platform isEqualToString:@"iPad3,6"])    return @"iPad 4(GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])    return @"iPad Air(WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])    return @"iPad Air(Cellular)";
    if ([platform isEqualToString:@"iPad4,3"])    return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])    return @"iPad mini 2(WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])    return @"iPad mini 2(Cellular)";
    if ([platform isEqualToString:@"iPad4,6"])    return @"iPad mini 2";
    if ([platform isEqualToString:@"iPad4,7"])    return @"iPad mini 3";
    if ([platform isEqualToString:@"iPad4,8"])    return @"iPad mini 3";
    if ([platform isEqualToString:@"iPad4,9"])    return @"iPad mini 3";
    if ([platform isEqualToString:@"iPad5,1"])    return @"iPad mini 4(WiFi)";
    if ([platform isEqualToString:@"iPad5,2"])    return @"iPad mini 4(Cellular)";
    if ([platform isEqualToString:@"iPad5,3"])    return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad5,4"])    return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad6,3"])    return @"iPad Pro(9.7 inch)";
    if ([platform isEqualToString:@"iPad6,4"])    return @"iPad Pro(9.7 inch)";
    if ([platform isEqualToString:@"iPad6,7"])    return @"iPad Pro(12.9 inch)";
    if ([platform isEqualToString:@"iPad6,8"])    return @"iPad Pro(12.9 inch)";
    
    //Apple TV
    if ([platform isEqualToString:@"AppleTV2,1"]) return @"Apple TV 2G";
    if ([platform isEqualToString:@"AppleTV3,1"]) return @"Apple TV 3G";
    if ([platform isEqualToString:@"AppleTV3,2"]) return @"Apple TV 3G";
    if ([platform isEqualToString:@"AppleTV5,3"]) return @"Apple TV 4G";
    
    //Apple Watch
    if ([platform isEqualToString:@"Watch1,1"])   return @"Apple Watch";
    if ([platform isEqualToString:@"Watch1,2"])   return @"Apple Watch";
    
    //simulator
    if ([platform isEqualToString:@"i386"])       return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])     return @"iPhone Simulator";
    
    return platform;
}

/**
 *  以枚举代表设备
 */
- (UIDeviceType)deviceEnum
{
    NSString *platform = [self systemString];
    
    //来源https://www.theiphonewiki.com/wiki/Models
    //iPhone
    if ([platform isEqualToString:@"iPhone1,1"])  return UIDeviceType_iPhone;
    if ([platform isEqualToString:@"iPhone1,2"])  return UIDeviceType_iPhone_3G;
    if ([platform isEqualToString:@"iPhone2,1"])  return UIDeviceType_iPhone_3GS;
    if ([platform isEqualToString:@"iPhone3,1"])  return UIDeviceType_iPhone_4;
    if ([platform isEqualToString:@"iPhone3,2"])  return UIDeviceType_iPhone_4;
    if ([platform isEqualToString:@"iPhone3,3"])  return UIDeviceType_iPhone_4;
    if ([platform isEqualToString:@"iPhone4,1"])  return UIDeviceType_iPhone_4S;
    if ([platform isEqualToString:@"iPhone5,1"])  return UIDeviceType_iPhone_5;
    if ([platform isEqualToString:@"iPhone5,2"])  return UIDeviceType_iPhone_5;
    if ([platform isEqualToString:@"iPhone5,3"])  return UIDeviceType_iPhone_5c;
    if ([platform isEqualToString:@"iPhone5,4"])  return UIDeviceType_iPhone_5c;
    if ([platform isEqualToString:@"iPhone6,1"])  return UIDeviceType_iPhone_5s;
    if ([platform isEqualToString:@"iPhone6,2"])  return UIDeviceType_iPhone_5s;
    if ([platform isEqualToString:@"iPhone7,1"])  return UIDeviceType_iPhone_6_Plus;
    if ([platform isEqualToString:@"iPhone7,2"])  return UIDeviceType_iPhone_6;
    if ([platform isEqualToString:@"iPhone8,1"])  return UIDeviceType_iPhone_6s;
    if ([platform isEqualToString:@"iPhone8,2"])  return UIDeviceType_iPhone_6s_Plus;
    if ([platform isEqualToString:@"iPhone8,4"])  return UIDeviceType_iPhone_SE;
    if ([platform isEqualToString:@"iPhone9,1"])  return UIDeviceType_iPhone_7;
    if ([platform isEqualToString:@"iPhone9,2"])  return UIDeviceType_iPhone_7_Plus;
    if ([platform isEqualToString:@"iPhone9,3"])  return UIDeviceType_iPhone_7;
    if ([platform isEqualToString:@"iPhone9,4"])  return UIDeviceType_iPhone_7_Plus;
    if ([platform isEqualToString:@"iPhone10,1"])  return UIDeviceType_iPhone_8;
    if ([platform isEqualToString:@"iPhone10,2"])  return UIDeviceType_iPhone_8_Plus;
    if ([platform isEqualToString:@"iPhone10,3"])  return UIDeviceType_iPhone_X;
    if ([platform isEqualToString:@"iPhone10,4"])  return UIDeviceType_iPhone_8;
    if ([platform isEqualToString:@"iPhone10,5"])  return UIDeviceType_iPhone_8_Plus;
    if ([platform isEqualToString:@"iPhone10,6"])  return UIDeviceType_iPhone_X;
    
    //iPod Touch
    if ([platform isEqualToString:@"iPod1,1"])    return UIDeviceType_iPod_touch;
    if ([platform isEqualToString:@"iPod2,1"])    return UIDeviceType_iPod_touch_2G;
    if ([platform isEqualToString:@"iPod3,1"])    return UIDeviceType_iPod_touch_3G;
    if ([platform isEqualToString:@"iPod4,1"])    return UIDeviceType_iPod_touch_4G;
    if ([platform isEqualToString:@"iPod5,1"])    return UIDeviceType_iPod_touch_5G;
    if ([platform isEqualToString:@"iPod7,1"])    return UIDeviceType_iPod_touch_6G;
    
    //iPad
    if ([platform isEqualToString:@"iPad1,1"])    return UIDeviceType_iPad;
    if ([platform isEqualToString:@"iPad2,1"])    return UIDeviceType_iPad_2;
    if ([platform isEqualToString:@"iPad2,2"])    return UIDeviceType_iPad_2;
    if ([platform isEqualToString:@"iPad2,3"])    return UIDeviceType_iPad_2;
    if ([platform isEqualToString:@"iPad2,4"])    return UIDeviceType_iPad_2;
    if ([platform isEqualToString:@"iPad2,5"])    return UIDeviceType_iPad_mini;
    if ([platform isEqualToString:@"iPad2,6"])    return UIDeviceType_iPad_mini;
    if ([platform isEqualToString:@"iPad2,7"])    return UIDeviceType_iPad_mini;
    if ([platform isEqualToString:@"iPad3,1"])    return UIDeviceType_iPad_3;
    if ([platform isEqualToString:@"iPad3,2"])    return UIDeviceType_iPad_3;
    if ([platform isEqualToString:@"iPad3,3"])    return UIDeviceType_iPad_3;
    if ([platform isEqualToString:@"iPad3,4"])    return UIDeviceType_iPad_4;
    if ([platform isEqualToString:@"iPad3,5"])    return UIDeviceType_iPad_4;
    if ([platform isEqualToString:@"iPad3,6"])    return UIDeviceType_iPad_4;
    if ([platform isEqualToString:@"iPad4,1"])    return UIDeviceType_iPad_Air;
    if ([platform isEqualToString:@"iPad4,2"])    return UIDeviceType_iPad_Air;
    if ([platform isEqualToString:@"iPad4,3"])    return UIDeviceType_iPad_Air;
    if ([platform isEqualToString:@"iPad4,4"])    return UIDeviceType_iPad_mini_2;
    if ([platform isEqualToString:@"iPad4,5"])    return UIDeviceType_iPad_mini_2;
    if ([platform isEqualToString:@"iPad4,6"])    return UIDeviceType_iPad_mini_2;
    if ([platform isEqualToString:@"iPad4,7"])    return UIDeviceType_iPad_mini_3;
    if ([platform isEqualToString:@"iPad4,8"])    return UIDeviceType_iPad_mini_3;
    if ([platform isEqualToString:@"iPad4,9"])    return UIDeviceType_iPad_mini_3;
    if ([platform isEqualToString:@"iPad5,1"])    return UIDeviceType_iPad_mini_4;
    if ([platform isEqualToString:@"iPad5,2"])    return UIDeviceType_iPad_mini_4;
    if ([platform isEqualToString:@"iPad5,3"])    return UIDeviceType_iPad_Air;
    if ([platform isEqualToString:@"iPad5,4"])    return UIDeviceType_iPad_Air;
    if ([platform isEqualToString:@"iPad6,3"])    return IDeviceType_iPad_Pro_9_7;
    if ([platform isEqualToString:@"iPad6,4"])    return IDeviceType_iPad_Pro_9_7;
    if ([platform isEqualToString:@"iPad6,7"])    return IDeviceType_iPad_Pro_12_9;
    if ([platform isEqualToString:@"iPad6,8"])    return IDeviceType_iPad_Pro_12_9;
    
    //Apple TV
    if ([platform isEqualToString:@"AppleTV2,1"]) return IDeviceType_Apple_TV_2G;
    if ([platform isEqualToString:@"AppleTV3,1"]) return IDeviceType_Apple_TV_3G;
    if ([platform isEqualToString:@"AppleTV3,2"]) return IDeviceType_Apple_TV_3G;
    if ([platform isEqualToString:@"AppleTV5,3"]) return IDeviceType_Apple_TV_4G;
    
    //Apple Watch
    if ([platform isEqualToString:@"Watch1,1"])   return IDeviceType_Apple_Watch;
    if ([platform isEqualToString:@"Watch1,2"])   return IDeviceType_Apple_Watch;
    
    //simulator
    if ([platform isEqualToString:@"i386"])       return IDeviceType_iPhone_Simulator;
    if ([platform isEqualToString:@"x86_64"])     return IDeviceType_iPhone_Simulator;
    
    return UIDeviceType_Unknown;
}

- (NSString *)deviceDefine
{
    switch ([self deviceEnum]) {
            
            //iPhone
        case UIDeviceType_iPhone:        return IPHONE;
        case UIDeviceType_iPhone_3G:     return IPHONE_3G;
        case UIDeviceType_iPhone_3GS:    return IPHONE_3GS;
        case UIDeviceType_iPhone_4:      return IPHONE_4;
        case UIDeviceType_iPhone_4S:     return IPHONE_4S;
        case UIDeviceType_iPhone_5:      return IPHONE_5;
        case UIDeviceType_iPhone_5c:     return IPHONE_5c;
        case UIDeviceType_iPhone_5s:     return IPHONE_5s;
        case UIDeviceType_iPhone_6:      return IPHONE_6;
        case UIDeviceType_iPhone_6_Plus:  return IPHONE_6Plus;
        case UIDeviceType_iPhone_6s:     return IPHONE_6s;
        case UIDeviceType_iPhone_6s_Plus:return IPHONE_6sPlus;
        case UIDeviceType_iPhone_SE:     return IPHONE_SE;
        case UIDeviceType_iPhone_7:     return IPHONE_7;
        case UIDeviceType_iPhone_7_Plus:return IPHONE_7Plus;
        case UIDeviceType_iPhone_8:     return IPHONE_8;
        case UIDeviceType_iPhone_8_Plus:return IPHONE_8Plus;
        case UIDeviceType_iPhone_X:     return IPHONE_X;
        case UIDeviceType_iPhone_8:     return IPHONE_8;
        case UIDeviceType_iPhone_8_Plus:return IPHONE_8Plus;
        case UIDeviceType_iPhone_X:     return IPHONE_X;
            
            //iPod Touch
        case UIDeviceType_iPod_touch:    return IPOD_TOUCH;
        case UIDeviceType_iPod_touch_2G: return IPOD_TOUCH_2G;
        case UIDeviceType_iPod_touch_3G: return IPOD_TOUCH_3G;
        case UIDeviceType_iPod_touch_4G: return IPOD_TOUCH_4G;
        case UIDeviceType_iPod_touch_5G: return IPOD_TOUCH_5G;
        case UIDeviceType_iPod_touch_6G: return IPOD_TOUCH_6G;
            
            //iPad
        case UIDeviceType_iPad:           return IPAD;
        case UIDeviceType_iPad_2:         return IPAD_2;
        case UIDeviceType_iPad_3:         return IPAD_3;
        case UIDeviceType_iPad_4:         return IPAD_4;
        case UIDeviceType_iPad_mini:      return IPAD_MINI;
        case UIDeviceType_iPad_mini_2:    return IPAD_MINI_2;
        case UIDeviceType_iPad_mini_3:    return IPAD_MINI_3;
        case UIDeviceType_iPad_mini_4:    return IPAD_MINI_4;
        case UIDeviceType_iPad_Air:       return IPAD_AIR;
        case UIDeviceType_iPad_Air_2:     return IPAD_AIR_2;
        case IDeviceType_iPad_Pro_9_7 :   return IPAD_PRO_9_7;
        case IDeviceType_iPad_Pro_12_9:   return IPAD_PRO_12_9;
            
            //Apple TV
        case IDeviceType_Apple_TV_2G:      return APPLE_TV_2G;
        case IDeviceType_Apple_TV_3G:      return APPLE_TV_3G;
        case IDeviceType_Apple_TV_4G:      return APPLE_TV_4G;
            
            //Apple Watch
        case IDeviceType_Apple_Watch:      return APPLE_WATCH;
            
            //simulator
        case IDeviceType_iPhone_Simulator: return IPHONE_SIMULATOR;
            
        default:                           return DEVICE_UNKNOWN;
            
    }
}

/**
 *  判断设备属于哪个父类（iPhone、iPad、iPod...）
 */
- (UIDeviceFamily)deviceFamily
{
    NSString *platform = [self systemString];
    
    if ([platform hasPrefix:@"iPhone"])  return UIDeviceFamily_iPhone;
    if ([platform hasPrefix:@"iPod"])    return UIDeviceFamily_iPod_touch;
    if ([platform hasPrefix:@"iPad"])    return UIDeviceFamily_iPad;
    if ([platform hasPrefix:@"AppleTV"]) return UIDeviceFamily_Apple_TV;
    if ([platform hasPrefix:@"Watch"])   return UIDeviceFamily_Apple_Watch;
    
    return UIDeviceFamily_Unknown;
}

@end
