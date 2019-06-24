//
//  TMDeviceInfo.m
//  Pods
//
//  Created by LinXiaoBin on 15/9/23.
//
//

#import "TMDeviceInfo.h"
#import <sys/utsname.h>
#import <sys/mount.h>
#import <sys/sysctl.h>
#import <mach/mach_host.h>

#define PATH_SIMULATER_DEVICE_INFO  @"/tmp/DeviceInfo.plist"

@implementation TMDeviceInfo

//获取设备类型
+ (GBDeviceModel)deviceModel
{
    static GBDeviceModel model = GBDeviceModelUnknown;
    if (model == GBDeviceModelUnknown) {
        model = [GBDeviceInfo deviceInfo].model;
    }
    return model;
}

//获取平台名称 如 “iPhone5,2”
+ (NSString *)platform
{
#if TARGET_IPHONE_SIMULATOR
    NSString *machineName = nil;
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:PATH_SIMULATER_DEVICE_INFO];
    machineName = [dict objectForKey:@"MachineName"];
    if (machineName) {
        return machineName;
    }
    
    UIScreen* screen = [UIScreen mainScreen];
    if (CGSizeEqualToSize(screen.bounds.size, CGSizeMake(320, 480))) {
        if([screen respondsToSelector:@selector(scale)]) {
            float scale = [screen scale];
            if (scale > 1.0f) {
                machineName = @"iPhone4,1";
                return machineName;
            }
        }
        machineName = @"iPhone2,1";
    } else if (CGSizeEqualToSize(screen.bounds.size, CGSizeMake(320, 568))) {
        machineName = @"iPhone5,1";
    } else if (CGSizeEqualToSize(screen.bounds.size, CGSizeMake(414, 736))) {
        machineName = @"iPhone7,1";
    } else if (CGSizeEqualToSize(screen.bounds.size, CGSizeMake(375, 667))) {
        machineName = @"iPhone7,2";
    } else if (CGSizeEqualToSize(screen.bounds.size, CGSizeMake(768, 1024))) {
        machineName = @"iPad1,1";
    } else if (CGSizeEqualToSize(screen.bounds.size, CGSizeMake(1536, 2048))) {
        machineName = @"iPad3,1";
    } else {
        machineName = @"iPhone5,1";
    }
    
    return machineName;
#endif
    
    static NSString *platform = nil;
    if (platform == nil) {
        platform = [GBDeviceInfo deviceInfo].rawSystemInfoString;
    }
    
    return platform;
}

//获取设备名称 - 如 “xxx的iPhone”
+ (NSString *)deviceName
{
    return [UIDevice currentDevice].name;
}

//判断是否iPhone设备
+ (BOOL)isiPhone
{
    return [GBDeviceInfo deviceInfo].family == GBDeviceFamilyiPhone;
}

//判断是否iPod设备
+ (BOOL)isiPod
{
    return [GBDeviceInfo deviceInfo].family == GBDeviceFamilyiPod;
}

//判断是否iPad设备
+ (BOOL)isiPad
{
    return [GBDeviceInfo deviceInfo].family == GBDeviceFamilyiPad;
}

//判断设备是否高清屏
+ (BOOL)isHDMachine
{    
    return [UIScreen mainScreen].scale > 1.f;
}

//判断2x设备
+ (BOOL)is2xMachine
{
    return [UIScreen mainScreen].scale == 2.f;
}

//判断3x设备
+ (BOOL)is3xMachine
{
    return [UIScreen mainScreen].scale == 3.f;
}

//判断设备是否支持多任务
+ (BOOL)isSupportMultiTask
{
    return [[UIDevice currentDevice] isMultitaskingSupported];
}

//判断设备是否支持摄像头
+ (BOOL)isSupportAVCapture
{
    BOOL bSucc = NO;
    NSString *macDev = [TMDeviceInfo platform];
    if (!([macDev isEqualToString:@"iPhone1,1"] || [macDev hasPrefix:@"iPhone1,2"] || [macDev hasPrefix:@"iPhone2,1"]
          || [macDev hasPrefix:@"iPad"]
          || [macDev isEqualToString:@"iPod1,1"] || [macDev isEqualToString:@"iPod2,1"]|| [macDev isEqualToString:@"iPod3,1"]|| [macDev isEqualToString:@"iPod4,1"]))
    {
        bSucc = YES;
    }
    return bSucc;
}

//是否支持64bit
+ (BOOL)is64bitSupported
{
#if defined(__LP64__) && __LP64__
    return YES;
#else
    return NO;
#endif
}

+ (BOOL)isAboveOrEqualToIPhoneX
{
    if ([[self class] screenSize].height >= 812.f)
        return YES;
    else
        return NO;
}

//获取固件
+ (NSString *)osVersion
{
#if TARGET_IPHONE_SIMULATOR
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:PATH_SIMULATER_DEVICE_INFO];
    NSString *osVersion = [dict objectForKey:@"OsVersion"];
    if (osVersion) {
        return osVersion;
    }
#endif
    
    return [[UIDevice currentDevice] systemVersion];
}

//获取app版本
+ (NSString *)appVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

//获取app编译版本
+ (NSString *)appBuildVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:(__bridge NSString *)kCFBundleVersionKey];
}

//获取屏幕大小
+ (CGSize)screenSize
{
    CGSize size = CGSizeZero;
    size = [UIScreen mainScreen].bounds.size;
    return size;
}

//获取系统分辨率
+ (CGSize)resolutionSize
{
    return [UIScreen mainScreen].currentMode.size;
}

//当前语言
+ (NSString *)currentLanguage
{
    NSArray *loc =[NSLocale preferredLanguages];
    NSString *lau = nil;
    if (loc) {
        if ([loc count] >0) {
            lau = [loc objectAtIndex:0];
        }
    }
    return lau;
}

+ (BOOL)currentLanguageIsChinese
{
    TMLanguageType type = [self languageType];
    if (type == TMLanguageTypeSimplifiedChinese || type == TMLanguageTypeTraditionalChinese) {
        return YES;
    }
    return NO;
}

+ (BOOL)currentLanguageIsChineseSimplified
{
    return [self languageType] == TMLanguageTypeSimplifiedChinese;
}

+ (TMLanguageType)languageType
{
    static TMLanguageType kLanguageType = TMLanguageTypeUnknown;
    if (kLanguageType != TMLanguageTypeUnknown) {
        return kLanguageType;
    }
    
    NSString *language = [[self class] currentLanguage];
    if (language)
    {
        if ([language hasPrefix:@"zh-Hans"]) {
            kLanguageType = TMLanguageTypeSimplifiedChinese;
        }
        else if ([language hasPrefix:@"zh-Hant"]) {
            kLanguageType = TMLanguageTypeTraditionalChinese;
        } else {
            kLanguageType = TMLanguageTypeEnglish;
        }
    } else {
        kLanguageType = TMLanguageTypeUnknown;
    }
    return kLanguageType;
}

//设备是否越狱
#define ARRAY_SIZE(a) sizeof(a)/sizeof(a[0])
const char* jailbreak_tool_pathes[] = {
    "/Applications/Cydia.app",
    "/Library/MobileSubstrate/MobileSubstrate.dylib",
    "/bin/bash",
    "/usr/sbin/sshd",
    "/etc/apt",
//    "/private/var/lib/apt/" //从越狱设备升级到新固件，未越狱时该目录存在
};

+ (BOOL)isJailbroken
{
    BOOL jailbroken = NO;
    for (int i=0; i<ARRAY_SIZE(jailbreak_tool_pathes); i++) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:jailbreak_tool_pathes[i]]]) {
            jailbroken =  YES;
            break;
        }
    }
    return jailbroken;
}

//电池
+ (float)batteryLevel
{
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    return fabsf([UIDevice currentDevice].batteryLevel);
}

+ (UIDeviceBatteryState)batteryState
{
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    UIDeviceBatteryState batteryState = [UIDevice currentDevice].batteryState;
    return batteryState;
}

// 可用磁盘容量
+ (NSString *)diskStringFromNumber:(unsigned long long)number
{
    float capacity = number/1024.f/1024.f/1024.f;
    return [NSString stringWithFormat:@"%.2fGB", capacity];
}

+ (NSString *)machineDiskAvailableString
{
    return [self diskStringFromNumber:[[self class] machineDiskAvailable]];
}

+ (unsigned long long)machineDiskAvailable
{
    struct statfs tStats;
    statfs([NSHomeDirectory() UTF8String], &tStats);
    return (unsigned long long)tStats.f_bavail * (unsigned long long)tStats.f_bsize;
}

// 已用磁盘容量
+ (NSString *)machineDiskInavailableString
{
    return [self diskStringFromNumber:[[self class] machineDiskInavailable]];
}

/*#include <sys/mount.h>*/
+ (unsigned long long)machineDiskInavailable
{
    return (unsigned long long)([[self class] machineDiskCap] - [[self class] machineDiskAvailable]);
}

// 总磁盘容量
+ (NSString *)machineDiskCapString
{
    return [self diskStringFromNumber:[[self class] machineDiskCap]];
}

/*#include <sys/mount.h>*/
+ (unsigned long long)machineDiskCap
{
    struct statfs tStats;
    statfs([NSHomeDirectory() UTF8String], &tStats);
    return (unsigned long long)tStats.f_blocks * (unsigned long long)tStats.f_bsize;
}

//内存
/*#import <sys/sysctl.h>*/
NSUInteger getSysInfo(uint typeSpecifier)
{
    size_t size = sizeof(NSInteger);
    NSInteger results;
    int mib[2] = {CTL_HW, (int)typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

+ (unsigned long long)totalMemory
{
    return [[NSProcessInfo processInfo] physicalMemory];
}

BOOL memoryInfo(vm_statistics_data_t *vmStats) {
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)vmStats, &infoCount);
    
    return kernReturn == KERN_SUCCESS;
}

+ (NSUInteger)activeMemory
{
    vm_statistics_data_t vmstat;
    if (!memoryInfo(&vmstat)) {
        printf("Failed to get VM statistics.");
    }
    
    if ([self is64bitSupported]) {
        return vmstat.active_count * vm_page_size >> 2;
    } else {
        return vmstat.active_count * vm_page_size;
    }
}

+ (NSUInteger)inactiveMemory
{
    vm_statistics_data_t vmstat;
    if (!memoryInfo(&vmstat)) {
        printf("Failed to get VM statistics.");
    }
    
    if ([self is64bitSupported]) {
        return vmstat.inactive_count * vm_page_size >> 2;
    } else {
        return vmstat.inactive_count * vm_page_size;
    }
}

+ (NSUInteger)freeMemory
{
    vm_statistics_data_t vmstat;
    if (!memoryInfo(&vmstat)) {
        printf("Failed to get VM statistics.");
    }
    
    if ([self is64bitSupported]) {
        return vmstat.free_count * vm_page_size >> 2;
    } else {
        return vmstat.free_count * vm_page_size;
    }
}

+ (NSUInteger)wiredMemory
{
    vm_statistics_data_t vmstat;
    if (!memoryInfo(&vmstat)) {
        printf("Failed to get VM statistics.");
    }
    
    if ([self is64bitSupported]) {
        return vmstat.wire_count * vm_page_size >> 2;
    } else {
        return vmstat.wire_count * vm_page_size;
    }
}

+ (NSUInteger)totalUserMemory
{
    if ([self is64bitSupported]) {
        return getSysInfo(HW_USERMEM) >> 2;
    } else {
        return getSysInfo(HW_USERMEM);
    }
}

//other
+ (void)simulateDeviece:(NSString *)deviceModel osVersion:(NSString *)osVersion
{
    NSMutableDictionary *dict = @{}.mutableCopy;
    if (deviceModel) {
        [dict setObject:deviceModel forKey:@"MachineName"];
    }
    if (osVersion) {
        [dict setObject:osVersion forKey:@"OsVersion"];
    }
    if ([dict allKeys].count > 0) {
        [dict writeToFile:PATH_SIMULATER_DEVICE_INFO atomically:YES];
    }
}

@end
