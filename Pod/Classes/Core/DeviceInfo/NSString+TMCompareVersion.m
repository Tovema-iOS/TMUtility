//
//  NSString+CompareVersion.m
//  Pods
//
//  Created by LinXiaoBin on 15/9/25.
//
//

#import "NSString+TMCompareVersion.h"

@implementation NSString(TMCompareVersion)

+ (NSComparisonResult)tm_version:(NSString *)versionA compareToVersion:(NSString *)versionB
{
    if (versionA == nil) {
        if (versionB == nil) {
            return NSOrderedSame;
        } else {
            return NSOrderedAscending;
        }
    } else {
        if (versionB == nil) {
            return NSOrderedDescending;
        } else {
            return [versionA compare:versionB options:NSNumericSearch];
        }
    }
}

+ (BOOL)tm_isVersion:(NSString *)versionA greaterThan:(NSString *)versionB
{
    return [self tm_version:versionA compareToVersion:versionB] == NSOrderedDescending;
}

+ (BOOL)tm_isVersion:(NSString *)versionA greaterThanOrEqualTo:(NSString *)versionB
{
    return [self tm_version:versionA compareToVersion:versionB] != NSOrderedAscending;
}

+ (BOOL)tm_isVersion:(NSString *)versionA lessThan:(NSString *)versionB
{
    return [self tm_version:versionA compareToVersion:versionB] == NSOrderedAscending;
}

+ (BOOL)tm_isVersion:(NSString *)versionA lessThanOrEqualTo:(NSString *)versionB
{
    return [self tm_version:versionA compareToVersion:versionB] != NSOrderedDescending;
}

@end
