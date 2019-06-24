//
//  BZReceptionist.m
//  BZUtility
//
//  Created by LinXiaoBin on 15/8/4.
//  Copyright (c) 2015年 Orion. All rights reserved.
//

#import "TMReceptionist.h"

typedef NS_ENUM(NSInteger, BZReceptionistType) {
    BZReceptionistTypeKVO = 0,
    BZReceptionistTypeNotify,
};

@interface TMReceptionist() {
    id observedObject;
    NSString *observedKeyPath;
    NSOperationQueue *operationQueue;
    dispatch_queue_t dispatchQueue;
    
    BZReceptionistType type;
}

@property (nonatomic, copy) TMReceptionKVOBlock kvoTask;
@property (nonatomic, copy) TMReceptionNotifyBlock notifyTask;

@end

@implementation TMReceptionist

- (void)dealloc
{
    switch (type) {
        case BZReceptionistTypeKVO:
        {
            [observedObject removeObserver:self forKeyPath:observedKeyPath];
        }
            break;
        case BZReceptionistTypeNotify:
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:observedKeyPath object:observedObject];
        }
            break;
            
        default:
            break;
    }
    
#if DEBUG
    NSLog(@"BZReceptionist dealloc");
#endif
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (operationQueue) {
        typeof(self) __weak weakSelf = self;
        [operationQueue addOperationWithBlock:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (strongSelf.kvoTask) {
                strongSelf.kvoTask(keyPath, object, change);
            }
        }];
    } else if (dispatchQueue) {
        dispatch_async(dispatchQueue, ^{
            if (self.kvoTask) {
                self.kvoTask(keyPath, object, change);
            }
        });
    }
}

- (void)onNotify:(NSNotification *)notification
{
    if (operationQueue) {
        typeof(self) __weak weakSelf = self;
        [operationQueue addOperationWithBlock:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (strongSelf.notifyTask) {
                strongSelf.notifyTask(notification);
            }
        }];
    } else if (dispatchQueue) {
        dispatch_async(dispatchQueue, ^{
            if (self.notifyTask) {
                self.notifyTask(notification);
            }
        });
    }
}

+ (instancetype)receptionistForKeyPath:(NSString *)keyPath object:(id)object operationQueue:(NSOperationQueue *)queue task:(TMReceptionKVOBlock)task
{
    TMReceptionist *receptionist = [[TMReceptionist alloc] init];
    receptionist.kvoTask = task;
    receptionist->observedKeyPath = [keyPath copy];
    receptionist->observedObject = object;
    receptionist->operationQueue = queue;
    receptionist->type = BZReceptionistTypeKVO;
    [object addObserver:receptionist forKeyPath:keyPath options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
    
    return receptionist;
}

+ (instancetype)receptionistForKeyPath:(NSString *)keyPath object:(id)object dispatchQueue:(dispatch_queue_t)queue task:(TMReceptionKVOBlock)task
{
    TMReceptionist *receptionist = [[TMReceptionist alloc] init];
    receptionist.kvoTask = task;
    receptionist->observedKeyPath = [keyPath copy];
    receptionist->observedObject = object;
    receptionist->dispatchQueue = queue;
    receptionist->type = BZReceptionistTypeKVO;
    [object addObserver:receptionist forKeyPath:keyPath options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
    
    return receptionist;
}

+ (instancetype)receptionistForNotificationName:(NSString *)aName object:(id)anObject operationQueue:(NSOperationQueue *)queue task:(TMReceptionNotifyBlock)task
{
    TMReceptionist *receptionist = [[TMReceptionist alloc] init];
    receptionist.notifyTask = task;
    receptionist->observedKeyPath = [aName copy];
    receptionist->observedObject = anObject;
    receptionist->operationQueue = queue;
    receptionist->type = BZReceptionistTypeNotify;
    [[NSNotificationCenter defaultCenter] addObserver:receptionist selector:@selector(onNotify:) name:aName object:anObject];
    
    return receptionist;
}

+ (instancetype)receptionistForNotificationName:(NSString *)aName object:(id)anObject dispatchQueue:(dispatch_queue_t)queue task:(TMReceptionNotifyBlock)task
{
    TMReceptionist *receptionist = [[TMReceptionist alloc] init];
    receptionist.notifyTask = task;
    receptionist->observedKeyPath = [aName copy];
    receptionist->observedObject = anObject;
    receptionist->dispatchQueue = queue;
    receptionist->type = BZReceptionistTypeNotify;
    [[NSNotificationCenter defaultCenter] addObserver:receptionist selector:@selector(onNotify:) name:aName object:anObject];
    
    return receptionist;
}

@end
