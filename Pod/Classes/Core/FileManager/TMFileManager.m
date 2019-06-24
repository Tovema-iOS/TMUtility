//
//  TMFileManager.m
//  Pods
//
//  Created by LinXiaoBin on 15/9/23.
//
//

#import "TMFileManager.h"
#import <sys/xattr.h>
#import <UIKit/UIKit.h>

/*
 每个沙盒含有3个文件夹：Documents, Library 和 tmp。因为应用的沙盒机制，应用只能在几个目录下读写文件
 
 Documents：苹果建议将程序中建立的或在程序中浏览到的文件数据保存在该目录下，iTunes备份和恢复的时候会包括此目录
 
 Library：存储程序的默认设置或其它状态信息；
 
 Library/Caches：存放缓存文件，iTunes不会备份此目录，此目录下文件不会在应用退出删除
 
 tmp：提供一个即时创建临时文件的地方。
 */

@implementation TMFileManager

// 类似路径 /var/mobile/Applications/3B8EC78A-5EEE-4C2F-B0CB-4C3F02B996D2
+ (NSString *)homeDirectory
{
    return NSHomeDirectory();
}

//类似路径 /var/mobile/Applications/3B8EC78A-5EEE-4C2F-B0CB-4C3F02B996D2/Documents
+ (NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (!paths || [paths count]==0)
        return nil;
    
    NSString *path = [paths objectAtIndex:0];
    return path;
}

//类似路径 /var/mobile/Applications/3B8EC78A-5EEE-4C2F-B0CB-4C3F02B996D2/Library/Caches
+ (NSString *)cachesDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    if (!paths || [paths count]==0)
        return nil;
    
    NSString *path = [paths objectAtIndex:0];
    return path;
}

//类似路径 /var/mobile/Applications/3B8EC78A-5EEE-4C2F-B0CB-4C3F02B996D2/Library
+ (NSString *)libraryDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    if (!paths || [paths count]==0)
        return nil;
    
    NSString *path = [paths objectAtIndex:0];
    return path;
}

//获取Tmp目录
+ (NSString *)tmpDirectory
{
    NSString *tmpDir = NSTemporaryDirectory();
    return tmpDir;
}

// 判断指定路径是否是文件夹
+ (BOOL)isDirectoryAtPath:(NSString *)path
{
    BOOL isDir = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] && isDir) {
        return YES;
    }
    return NO;
}

// 创建目录
+ (void)createDirectory:(NSString *)directory
{
    if (![self isDirectoryAtPath:directory] && [directory isKindOfClass:[NSString class]]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
}

// 批量创建目录
+ (void)createDirectories:(NSArray *)directories
{
    for (NSString *dir in directories) {
        [self createDirectory:dir];
    }
}

// 禁止iCloud备份
+ (void)addSkipBackupAttributeToPaths:(NSArray *)paths
{
    [paths enumerateObjectsUsingBlock:^(id  _Nonnull path, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:path]];
    }];
}

#pragma mark - private

// 5.1以上禁止iCloud备份
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    if ([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]) {
        NSError *error = nil;
        BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                      forKey: NSURLIsExcludedFromBackupKey error: &error];
        if(!success) {
            NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
        }
        
        return success;
    }
    return NO;
}

// 5.0.1禁止iCloud备份，5.0及以下固件不支持
+ (BOOL)addSkipBackupAttributeToPath:(NSString *)path
{
    if ([[NSFileManager defaultManager] fileExistsAtPath: path]) {
        const char* filePath = [path fileSystemRepresentation];
        
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result == 0;
    }
    return NO;
}

@end
