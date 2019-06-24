//
//  BZTestObjectB.h
//  BZUtility
//
//  Created by LinXiaoBin on 15/9/23.
//  Copyright © 2015年 Orion777. All rights reserved.
//

#import "BZTestObjectBase.h"

@class TMReceptionist;

@interface BZTestObjectB : BZTestObjectBase

@property (nonatomic, strong) TMReceptionist *receptionist;

- (void)onObjAValueChagne:(NSDictionary *)change;

@end
