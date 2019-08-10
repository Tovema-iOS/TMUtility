//
//  TMDeviceInfo.h
//  Pods
//
//  Created by LinXiaoBin on 15/9/23.
//
//

#import <UIKit/UIKit.h>
#import <GBDeviceInfo/GBDeviceInfo.h>

typedef NS_ENUM (NSInteger, TMLanguageType) {
    TMLanguageTypeUnknown = -1,
    TMLanguageTypeEnglish = 0,
    TMLanguageTypeSimplifiedChinese,
    TMLanguageTypeTraditionalChinese,
};

@interface TMDeviceInfo : NSObject

//获取设备类型
+ (GBDeviceModel)deviceModel;
//获取平台名称 如 “iPhone5,2”
+ (NSString *)platform;
//获取设备名称 - 如 “xxx的iPhone”
+ (NSString *)deviceName;

//判断是否iPhone设备
+ (BOOL)isiPhone;
//判断是否iPod设备
+ (BOOL)isiPod;
//判断是否iPad设备
+ (BOOL)isiPad;
//判断设备是否高清屏
+ (BOOL)isHDMachine;
//判断2x设备
+ (BOOL)is2xMachine;
//判断3x设备
+ (BOOL)is3xMachine;
//判断设备是否支持多任务
+ (BOOL)isSupportMultiTask;
//判断设备是否支持摄像头
+ (BOOL)isSupportAVCapture;
//是否支持64bit
+ (BOOL)is64bitSupported;
//判断设备是否高于iPhoneX
+ (BOOL)isAboveOrEqualToIPhoneX;

//获取固件
+ (NSString *)osVersion;
//获取app版本
+ (NSString *)appVersion;
//获取app编译版本
+ (NSString *)appBuildVersion;

//获取屏幕大小
+ (CGSize)screenSize;
//获取系统分辨率
+ (CGSize)resolutionSize;

//当前语言
+ (NSString *)currentLanguage;
+ (BOOL)currentLanguageIsChinese;
+ (BOOL)currentLanguageIsChineseSimplified;
+ (TMLanguageType)languageType;

//Sim 卡国家，大写
+ (NSString *)simCountry;

//设备是否越狱
+ (BOOL)isJailbroken;

//电池
+ (float)batteryLevel;
+ (UIDeviceBatteryState)batteryState;

// 可用磁盘容量
+ (NSString *)machineDiskAvailableString;
+ (unsigned long long)machineDiskAvailable;
// 已用磁盘容量
+ (NSString *)machineDiskInavailableString;
+ (unsigned long long)machineDiskInavailable;
// 总磁盘容量
+ (NSString *)machineDiskCapString;
+ (unsigned long long)machineDiskCap;

//内存
+ (unsigned long long)totalMemory;
+ (NSUInteger)activeMemory;
+ (NSUInteger)inactiveMemory;
+ (NSUInteger)freeMemory;
+ (NSUInteger)wiredMemory;
+ (NSUInteger)totalUserMemory;

//other
+ (void)simulateDeviece:(NSString *)deviceModel osVersion:(NSString *)osVersion;

@end
