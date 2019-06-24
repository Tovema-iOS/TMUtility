//
//  ViewControllerHelper.m
//  TMUtility
//
//  Created by LinXiaoBin on 2018/8/20.
//

#import "TMViewControllerHelper.h"

@implementation TMViewControllerHelper

+ (UINavigationController *)rootNavigationController {
    UIViewController *ctrl = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    if ([ctrl isKindOfClass:UINavigationController.class]) {
        return (UINavigationController *)ctrl;
    } else {
        UITabBarController *tabCtrl = [self rootTabBarController];
        if (tabCtrl.viewControllers.count > 0) {
            UINavigationController *naviCtrl = tabCtrl.selectedViewController;
            if ([naviCtrl isKindOfClass:UINavigationController.class]) {
                return (UINavigationController *)naviCtrl;
            }
        }
    }
    return nil;
}

+ (UITabBarController *)rootTabBarController {
    UIViewController *ctrl = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    if ([ctrl isKindOfClass:UITabBarController.class]) {
        return (UITabBarController *)ctrl;
    }
    
    return nil;
}

@end
