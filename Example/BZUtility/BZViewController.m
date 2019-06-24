//
//  BZViewController.m
//  BZUtility
//
//  Created by Orion777 on 09/23/2015.
//  Copyright (c) 2015 Orion777. All rights reserved.
//

#import "BZViewController.h"
#import <TMUtility/TMUtility.h>
#import "BZTestObjectA.h"
#import "BZTestObjectB.h"
#import <TMUtility/TMThreadSafeArray.h>

#define kSectionTitleKey    @"SectionTitle"
#define kCellTitleArrayKey      @"CellTitleArray"
#define kCellTitleKey   @"Title"
#define kCellOperationKey @"Operation"

@interface BZViewController () {
}

@property (nonatomic, retain) NSMutableArray *sections;

@end

@implementation BZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sections = [NSMutableArray array];
    typeof(self) __weak weakSelf = self;
    {
        NSMutableArray *array = [NSMutableArray array];
        
        [array addObject:@{kCellTitleKey: @"KVO dispatchQueue", kCellOperationKey: [NSBlockOperation blockOperationWithBlock:^{
            [weakSelf testBZReceptionistKVODispatchQueue];
        }]}];
        [array addObject:@{kCellTitleKey: @"KVO operationQueue", kCellOperationKey: [NSBlockOperation blockOperationWithBlock:^{
            [weakSelf testBZReceptionistKVOOperationQueue];
        }]}];
        [array addObject:@{kCellTitleKey: @"Notify operationQueue", kCellOperationKey: [NSBlockOperation blockOperationWithBlock:^{
            [weakSelf testBZReceptionistNotifyDispatchQueue];
        }]}];
        
        [self.sections addObject:@{kSectionTitleKey: @"KVO转发",
                                   kCellTitleArrayKey: array}];
    }
    {
        NSMutableArray *array = [NSMutableArray array];
        
        [array addObject:@{kCellTitleKey: @"获取沙盒路径", kCellOperationKey: [NSBlockOperation blockOperationWithBlock:^{
            [weakSelf testSandbox];
        }]}];
        [array addObject:@{kCellTitleKey: @"创建目录", kCellOperationKey: [NSBlockOperation blockOperationWithBlock:^{
            [weakSelf testCreateDirectory];
        }]}];
        [array addObject:@{kCellTitleKey: @"取消iCloud备份", kCellOperationKey: [NSBlockOperation blockOperationWithBlock:^{
            [weakSelf testSkipICloudBackup];
        }]}];
        
        [self.sections addObject:@{kSectionTitleKey: @"文件处理",
                                   kCellTitleArrayKey: array}];
    }
    {
        NSMutableArray *array = [NSMutableArray array];
        
        [array addObject:@{kCellTitleKey: @"基础信息", kCellOperationKey: [NSBlockOperation blockOperationWithBlock:^{
            [weakSelf testDeviceInfo];
        }]}];
        [array addObject:@{kCellTitleKey: @"版本比较", kCellOperationKey: [NSBlockOperation blockOperationWithBlock:^{
            [weakSelf testVersionCompare];
        }]}];
        [array addObject:@{kCellTitleKey: @"常用宏", kCellOperationKey: [NSBlockOperation blockOperationWithBlock:^{
            [weakSelf testMacro];
        }]}];
        [array addObject:@{kCellTitleKey: @"内存", kCellOperationKey: [NSBlockOperation blockOperationWithBlock:^{
            [weakSelf testMemory];
        }]}];
        
        [self.sections addObject:@{kSectionTitleKey: @"DeviceInfo",
                                   kCellTitleArrayKey: array}];
    }
    
    {
        NSMutableArray *array = [NSMutableArray array];
        
        [array addObject:@{kCellTitleKey: @"ThreadSafeArray", kCellOperationKey: [NSBlockOperation blockOperationWithBlock:^{
            NSString *path = [DIRECTORY_DOCUMENTS stringByAppendingPathComponent:@"a/c/text.plist"];
            TMThreadSafeArray *tsArray = [TMThreadSafeArray arrayWithContentsOfFile:path modelClass:BZTestObjectA.class];
            for (NSInteger i=0; i<100; i++) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(arc4random()%10 * 0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    BZTestObjectA *obj = [BZTestObjectA new];
                    obj.stringAttr = [NSString stringWithFormat:@":%@", @(i)];
                    [tsArray addObject:obj];
                    NSLog(@"add %@", obj.stringAttr);
                    [tsArray saveData];
                });
            }
        }]}];
        
        [array addObject:@{kCellTitleKey: @"Subarray", kCellOperationKey: [NSBlockOperation blockOperationWithBlock:^{
            TMThreadSafeArray *tsArray = [TMThreadSafeArray arrayWithArray:@[@(0), @(1), @(2), @(3), @(4)]];
            NSLog(@"%@", [tsArray subarrayWithRange:NSMakeRange(0, 4)]);
            NSLog(@"%@", [tsArray subarrayWithRange:NSMakeRange(1, 3)]);
            NSLog(@"%@", [tsArray subarrayWithRange:NSMakeRange(1, 5)]);
            NSLog(@"%@", [tsArray subarrayWithRange:NSMakeRange(0, 5)]);
            NSLog(@"%@", [tsArray subarrayWithRange:NSMakeRange(5, 5)]);
        }]}];
        
        [self.sections addObject:@{kSectionTitleKey: @"ThreadSafeArray",
                                   kCellTitleArrayKey: array}];
    }
    
    {
        NSMutableArray *array = [NSMutableArray array];
        
        [array addObject:@{kCellTitleKey: @"OnExit", kCellOperationKey: [NSBlockOperation blockOperationWithBlock:^{
            [weakSelf testOnExit];
        }]}];
        
        [self.sections addObject:@{kSectionTitleKey: @"Other",
                                   kCellTitleArrayKey: array}];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
#if 0
#warning 测试
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:2];
        if (indexPath.section < [self numberOfSectionsInTableView:self.tableView]
            && indexPath.row < [self tableView:self.tableView numberOfRowsInSection:indexPath.section]) {
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
        }
#endif
    });
}

#pragma mark - BZReceptionist
- (void)testBZReceptionistKVODispatchQueue
{
    BZTestObjectA *objA = [[BZTestObjectA alloc] init];
    BZTestObjectB *objB = [[BZTestObjectB alloc] init];
    
    dispatch_queue_t queue = dispatch_queue_create("test recepition queue", DISPATCH_QUEUE_SERIAL);
    objB.receptionist = [TMReceptionist receptionistForKeyPath:@"stringAttr" object:objA dispatchQueue:queue task:^(NSString *keyPath, id object, NSDictionary *change) {
        [objB onObjAValueChagne:change];
    }];
    
    for (NSInteger i=0; i<20; i++) {
        objA.stringAttr = [NSString stringWithFormat:@"%zd", i];
    }
    
    objB.receptionist = nil;
    
    for (NSInteger i=20; i<40; i++) {
        objA.stringAttr = [NSString stringWithFormat:@"%zd", i];
        NSLog(@" >>>>>>>> %@", objA.stringAttr);
    }
}

- (void)testBZReceptionistKVOOperationQueue
{
    BZTestObjectA *objA = [[BZTestObjectA alloc] init];
    BZTestObjectB *objB = [[BZTestObjectB alloc] init];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;
    objB.receptionist = [TMReceptionist receptionistForKeyPath:@"stringAttr" object:objA operationQueue:queue task:^(NSString *keyPath, id object, NSDictionary *change) {
        [objB onObjAValueChagne:change];
    }];
    
    for (NSInteger i=0; i<20; i++) {
        objA.stringAttr = [NSString stringWithFormat:@"%zd", i];
    }
    
    objB.receptionist = nil;
    
    for (NSInteger i=20; i<40; i++) {
        objA.stringAttr = [NSString stringWithFormat:@"%zd", i];
        NSLog(@" >>>>>>>> %@", objA.stringAttr);
    }
}

- (void)testBZReceptionistNotifyDispatchQueue
{
    BZTestObjectA *objA = [[BZTestObjectA alloc] init];
    BZTestObjectB *objB = [[BZTestObjectB alloc] init];
    
    dispatch_queue_t queue = dispatch_queue_create("test recepition queue", DISPATCH_QUEUE_SERIAL);
    objB.receptionist = [TMReceptionist receptionistForNotificationName:@"stringAttr" object:nil dispatchQueue:queue task:^(NSNotification *notification) {
        
        NSLog(@"notification.userInfo: %@", notification);
    }];
    
    for (NSInteger i=2; i<20; i++) {
        objA.stringAttr = [NSString stringWithFormat:@"%zd", i];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"stringAttr" object:objA.stringAttr];
    }
    
    objB.receptionist = nil;
    
    for (NSInteger i=20; i<40; i++) {
        objA.stringAttr = [NSString stringWithFormat:@"%zd", i];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"stringAttr" object:objA.stringAttr];
    }
}

#pragma mark - BZFileManager
- (void)testSandbox
{
    NSLog(@"DIRECTORY_HOME: %@", DIRECTORY_HOME);
    NSLog(@"DIRECTORY_DOCUMENTS: %@", DIRECTORY_DOCUMENTS);
    NSLog(@"DIRECTORY_LIBRARY: %@", DIRECTORY_LIBRARY);
    NSLog(@"DIRECTORY_CACHES: %@", DIRECTORY_CACHES);
    NSLog(@"DIRECTORY_TMP: %@", DIRECTORY_TMP);
}

- (void)testCreateDirectory
{
    NSString *path = [DIRECTORY_TMP stringByAppendingPathComponent:@"test"];
    NSLog(@"%@", path);
    NSLog(@"文件夹 %@", [TMFileManager isDirectoryAtPath:path] ? @"存在" : @"不存在");
    [TMFileManager createDirectory:path];
    NSLog(@"文件夹 %@", [TMFileManager isDirectoryAtPath:path] ? @"存在" : @"不存在");
}

- (void)testSkipICloudBackup
{
    [TMFileManager addSkipBackupAttributeToPaths:@[DIRECTORY_DOCUMENTS]];
}

- (void)testDeviceInfo
{
    NSLog(@"deviceModel: %zd", [TMDeviceInfo deviceModel]);
    NSLog(@"platform: %@", [TMDeviceInfo platform]);
    NSLog(@"deviceName: %@", [TMDeviceInfo deviceName]);
    
    NSLog(@"isiPhone: %d", [TMDeviceInfo isiPhone]);
    NSLog(@"isiPod: %d", [TMDeviceInfo isiPod]);
    NSLog(@"isiPad: %d", [TMDeviceInfo isiPad]);
    NSLog(@"isHDMachine: %d", [TMDeviceInfo isHDMachine]);
    NSLog(@"is2xMachine: %d", [TMDeviceInfo is2xMachine]);
    NSLog(@"is3xMachine: %d", [TMDeviceInfo is3xMachine]);
    NSLog(@"isSupportAVCapture: %d", [TMDeviceInfo isSupportAVCapture]);
    NSLog(@"is64bitSupported: %@\n\n", @([TMDeviceInfo is64bitSupported]));
    
    NSLog(@"osVersion: %@", [TMDeviceInfo osVersion]);
    NSLog(@"appVersion: %@", [TMDeviceInfo appVersion]);
    NSLog(@"appBuildVersion: %@\n\n", [TMDeviceInfo appBuildVersion]);
    
    NSLog(@"screenSize: %@", NSStringFromCGSize([TMDeviceInfo screenSize]));
    NSLog(@"resolutionSize: %@\n", NSStringFromCGSize([TMDeviceInfo resolutionSize]));
    
    NSLog(@"currentLanguage: %@", [TMDeviceInfo currentLanguage]);
    NSLog(@"currentLanguageIsChinese: %d", [TMDeviceInfo currentLanguageIsChinese]);
    NSLog(@"currentLanguageIsChineseSimplified: %d\n\n", [TMDeviceInfo currentLanguageIsChineseSimplified]);
    
    NSLog(@"isJailbroken: %d\n\n", [TMDeviceInfo isJailbroken]);
    
    NSLog(@"batteryLevel: %f", [TMDeviceInfo batteryLevel]);
    NSLog(@"batteryState: %zd\n\n", [TMDeviceInfo batteryState]);
}

- (NSString *)memoryString:(NSUInteger)mem
{
    NSUInteger memory = mem >> 10;
    return [NSString stringWithFormat:@"%.1fM", (CGFloat)memory/1024.f];
}

- (void)testMemory
{
    NSLog(@"%@ wiredMemory", [self memoryString:[TMDeviceInfo wiredMemory]]);
    NSLog(@"%@ activeMemory", [self memoryString:[TMDeviceInfo activeMemory]]);
    NSLog(@"%@ inactiveMemory", [self memoryString:[TMDeviceInfo inactiveMemory]]);
    NSLog(@"%@ freeMemory", [self memoryString:[TMDeviceInfo freeMemory]]);
    
    NSLog(@"%@ 计算值", [self memoryString:([TMDeviceInfo wiredMemory]+[TMDeviceInfo activeMemory]+[TMDeviceInfo inactiveMemory]+[TMDeviceInfo freeMemory])]);
    
    NSLog(@"%@ totalMemory", [self memoryString:(NSUInteger)[TMDeviceInfo totalMemory]]);
    NSLog(@"%@ totalUserMemory", [self memoryString:[TMDeviceInfo totalUserMemory]]);
    
}

- (void)testMacro
{
    NSLog(@"WINDOW: %@", WINDOW);
    
    NSLog(@"OS_VERSION: %@", OS_VERSION);
    
    NSArray *vers = @[@"8.0", @"9.0", @"10.0"];
    for (NSString *version in vers) {
        NSLog(@"isOsVersionGreaterThan %@: %d", version, isOsVersionGreaterThan(version));
        NSLog(@"isOsVersionGreaterThanOrEqualTo %@: %d", version, isOsVersionGreaterThanOrEqualTo(version));
        NSLog(@"isOsVersionLessThan %@: %d", version, isOsVersionLessThan(version));
        NSLog(@"isOsVersionLessThanOrEqualTo %@: %d\n\n", version, isOsVersionLessThanOrEqualTo(version));
    }
    
    NSLog(@"APP_VERSION: %@", APP_VERSION);
    vers = @[@"2.0.3", @"2.0.4", @"2.0.5"];
    for (NSString *version in vers) {
        NSLog(@"isAppVersionGreaterThan %@: %d", version, isAppVersionGreaterThan(version));
        NSLog(@"isAppVersionGreaterThanOrEqualTo %@: %d", version, isAppVersionGreaterThanOrEqualTo(version));
        NSLog(@"isAppVersionLessThan %@: %d", version, isAppVersionLessThan(version));
        NSLog(@"isAppVersionLessThanOrEqualTo %@: %d\n\n", version, isAppVersionLessThanOrEqualTo(version));
    }
    
    NSLog(@"APP_BUILD_VERSION: %@", APP_BUILD_VERSION);
    vers = @[@"1.1", @"1.2", @"1.3"];
    for (NSString *version in vers) {
        NSLog(@"isAppBuildVersionGreaterThan %@: %d", version, isAppBuildVersionGreaterThan(version));
        NSLog(@"isAppBuildVersionGreaterThanOrEqualTo %@: %d", version, isAppBuildVersionGreaterThanOrEqualTo(version));
        NSLog(@"isAppBuildVersionLessThan %@: %d", version, isAppBuildVersionLessThan(version));
        NSLog(@"isAppBuildVersionLessThanOrEqualTo %@: %d\n\n", version, isAppBuildVersionLessThanOrEqualTo(version));
    }
    
    NSLog(@"RGB(111, 111, 111): %@", RGB(111, 111, 111));
}

- (void)testVersionCompare
{
    NSArray *vers = @[@"1", @"2", @"3",
                      @"1.0", @"1.1", @"1.2",
                      @"1.0.3", @"1.0.1", @"1.0.2",
                      @"1.0.2.1", @"1.0.2.2", @"1.0.2.3",
                      @"1.0.1.2", @"1.0.1.1", @"1.0.1.3"];
    
    NSArray *sort = [vers sortedArrayUsingComparator:^(NSString *ver1, NSString *ver2) {
        return [NSString tm_version:ver1 compareToVersion:ver2];
    }];
    NSLog(@"%@", sort);
    
    vers = @[@"1.0", @"1.1", @"1.2"];
    for (NSString *ver1 in vers) {
        for (NSString *ver2 in vers) {
            NSLog(@"is %@ lessThan %@: %d", ver1, ver2, [NSString tm_isVersion:ver1 lessThan:ver2]);
        }
    }
    NSLog(@"\n");
    for (NSString *ver1 in vers) {
        for (NSString *ver2 in vers) {
            NSLog(@"is %@ lessThanOrEqualTo %@: %d", ver1, ver2, [NSString tm_isVersion:ver1 lessThanOrEqualTo:ver2]);
        }
    }
    NSLog(@"\n");
    for (NSString *ver1 in vers) {
        for (NSString *ver2 in vers) {
            NSLog(@"is %@ greaterThan %@: %d", ver1, ver2, [NSString tm_isVersion:ver1 greaterThan:ver2]);
        }
    }
    NSLog(@"\n");
    
    for (NSString *ver1 in vers) {
        for (NSString *ver2 in vers) {
            NSLog(@"is %@ greaterThanOrEqualTo %@: %d", ver1, ver2, [NSString tm_isVersion:ver1 greaterThanOrEqualTo:ver2]);
        }
    }
    NSLog(@"\n");
}

- (void)testOnExit {
    static dispatch_semaphore_t lock;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lock = dispatch_semaphore_create(1);
    });
    
    {
        dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
        @onExit {
            dispatch_semaphore_signal(lock);
        };
        NSLog(@"testSemaphore");
    }
    
    {
        dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
        @onExit {
            dispatch_semaphore_signal(lock);
        };
        NSLog(@"testSemaphore 2");
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *dict = [self.sections objectAtIndex:section];
    if ([dict isKindOfClass:[NSDictionary class]]) {
        return dict[kSectionTitleKey];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dict = [self.sections objectAtIndex:section];
    if ([dict isKindOfClass:[NSDictionary class]]) {
        return [dict[kCellTitleArrayKey] count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCellIDentifier" forIndexPath:indexPath];
    
    NSDictionary *dict = [self.sections objectAtIndex:indexPath.section];
    NSArray *titles = dict[kCellTitleArrayKey];
    if ([titles isKindOfClass:[NSArray class]]) {
        NSDictionary *cellDict = titles[indexPath.row];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            cell.textLabel.text = [NSString stringWithFormat:@"%zd-%zd %@", indexPath.section, indexPath.row, cellDict[kCellTitleKey]];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = [self.sections objectAtIndex:indexPath.section];
    NSArray *titles = dict[kCellTitleArrayKey];
    if ([titles isKindOfClass:[NSArray class]]) {
        NSDictionary *cellDict = titles[indexPath.row];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            NSBlockOperation *operation = cellDict[kCellOperationKey];
            for (void (^block)(void) in operation.executionBlocks) {
                block();
            }
        }
    }
}

@end
