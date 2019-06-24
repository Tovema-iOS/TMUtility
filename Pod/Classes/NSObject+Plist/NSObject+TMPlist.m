//
//  NSObject+Plist.m
//  Pods
//
//  Created by LinXiaoBin on 16/8/10.
//
//

#import "NSObject+TMPlist.h"
#import <YYModel/YYModel.h>
#import <objc/runtime.h>

@interface NSObject(_TMPlist)

@property (nonatomic, copy) NSString *tm_path;
@property (nonatomic, strong) NSOperationQueue *tm_saveQueue;

@end

@implementation NSObject(TMPlist)

+ (instancetype)tm_objectWithContentsOfFile:(NSString *)path
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    NSObject *obj = [self yy_modelWithJSON:dictionary];
    if (!obj) {
        obj = [[self class] alloc];
    }
    obj.tm_path = path;
    return obj;
}

- (NSString *)tm_path
{
    return objc_getAssociatedObject(self, @selector(tm_path));
}

- (void)setFl_path:(NSString *)tm_path
{
    objc_setAssociatedObject(self, @selector(tm_path), tm_path, OBJC_ASSOCIATION_COPY);
}

- (NSOperationQueue *)tm_saveQueue
{
    return objc_getAssociatedObject(self, @selector(tm_saveQueue));
}

- (void)settm_saveQueue:(NSOperationQueue *)tm_saveQueue
{
    objc_setAssociatedObject(self, @selector(tm_saveQueue), tm_saveQueue, OBJC_ASSOCIATION_RETAIN);
}

- (void)tm_saveData
{
    if (!self.tm_saveQueue) {
        self.tm_saveQueue = [[NSOperationQueue alloc] init];
        self.tm_saveQueue.maxConcurrentOperationCount = 1;
        self.tm_saveQueue.name = [NSString stringWithFormat:@"com.fl.save.%@.%@", self.tm_path.lastPathComponent, @((NSInteger)[[NSDate date] timeIntervalSince1970])];
    }
    
    [self.tm_saveQueue cancelAllOperations];
    
    NSObject *obj = self;
    NSString *path = self.tm_path.copy;
    [self.tm_saveQueue addOperationWithBlock:^{
        NSDictionary *dict = [obj yy_modelToJSONObject];        
        if (dict) {
            NSString *dir = [path stringByDeletingLastPathComponent];
            BOOL isDir = NO;
            if (!([[NSFileManager defaultManager] fileExistsAtPath:dir isDirectory:&isDir] && isDir)) {
                [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:NULL];
            }
            
            [dict writeToFile:path atomically:YES];
        }
    }];
    
}

@end
