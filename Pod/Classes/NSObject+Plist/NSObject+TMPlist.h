//
//  NSObject+Plist.h
//  Pods
//
//  Created by LinXiaoBin on 16/8/10.
//
//

#import <Foundation/Foundation.h>

@interface NSObject(TMPlist)

@property (nonatomic, readonly, copy) NSString *tm_path;

+ (instancetype)tm_objectWithContentsOfFile:(NSString *)path;

- (void)tm_saveData;

@end
