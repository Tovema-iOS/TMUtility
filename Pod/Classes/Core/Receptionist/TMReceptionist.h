//
//  BZReceptionist.h
//  BZUtility
//
//  Created by LinXiaoBin on 15/8/4.
//  Copyright (c) 2015年 Orion. All rights reserved.
//

#import <Foundation/Foundation.h>

//KVO中转回调
typedef void(^TMReceptionKVOBlock)(NSString *keyPath, id object, NSDictionary *change);

//通知中转回调
typedef void(^TMReceptionNotifyBlock)(NSNotification *notification);

/**
 *  @brief  KVO消息、通知中转
 *  使用时注意避免循环引用
 */
@interface TMReceptionist : NSObject

//KVO中转
+ (instancetype)receptionistForKeyPath:(NSString *)keyPath object:(id)anObject operationQueue:(NSOperationQueue *)queue task:(TMReceptionKVOBlock)task;
+ (instancetype)receptionistForKeyPath:(NSString *)keyPath object:(id)anObject dispatchQueue:(dispatch_queue_t)queue task:(TMReceptionKVOBlock)task;

//通知中转
+ (instancetype)receptionistForNotificationName:(NSString *)aName object:(id)anObject operationQueue:(NSOperationQueue *)queue task:(TMReceptionNotifyBlock)task;
+ (instancetype)receptionistForNotificationName:(NSString *)aName object:(id)anObject dispatchQueue:(dispatch_queue_t)queue task:(TMReceptionNotifyBlock)task;

@end
