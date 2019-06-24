//
//  TMFileManager.h
//  Pods
//
//  Created by LinXiaoBin on 15/9/23.
//
//

#import <Foundation/Foundation.h>

#define DIRECTORY_HOME          [TMFileManager homeDirectory]
#define DIRECTORY_DOCUMENTS     [TMFileManager documentsDirectory]
#define DIRECTORY_CACHES        [TMFileManager cachesDirectory]
#define DIRECTORY_LIBRARY       [TMFileManager libraryDirectory]
#define DIRECTORY_TMP           [TMFileManager tmpDirectory]

#define MAIN_BUNDLE     [NSBundle mainBundle]

/*
 沙盒目录结构
 -----Document
 -----Xxx.app
 -----Library
 -----tmp
 */

@interface TMFileManager : NSObject

// 获取Home目录路径
+ (NSString *)homeDirectory;
// 获取Document目录路径
+ (NSString *)documentsDirectory;
// 获取Caches目录路径
+ (NSString *)cachesDirectory;
// 获取Library目录路径
+ (NSString *)libraryDirectory;
// 获取Tmp目录路径
+ (NSString *)tmpDirectory;

// 判断指定路径是否是文件夹
+ (BOOL)isDirectoryAtPath:(NSString *)path;
// 创建目录
+ (void)createDirectory:(NSString *)directory;
// 批量创建目录
+ (void)createDirectories:(NSArray *)directories;

// 禁止iCloud备份
+ (void)addSkipBackupAttributeToPaths:(NSArray *)paths;

@end
