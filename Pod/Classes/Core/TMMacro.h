//
//  BZMacro.h
//  Pods
//
//  Created by LinXiaoBin on 15/9/23.
//
//

#ifndef BZMacro_h
#define BZMacro_h

#define WINDOW      [[[UIApplication sharedApplication] delegate] window]

#define ROOT_NAVIGATION_CONTROLLER    [TMViewControllerHelper rootNavigationController]
#define ROOT_TAB_BAR_CONTROLLER    [TMViewControllerHelper rootTabBarController]

//固件版本
#define OS_VERSION      [TMDeviceInfo osVersion]
#define isOsVersionGreaterThan(version)             [NSString tm_isVersion:OS_VERSION greaterThan:(version)]
#define isOsVersionGreaterThanOrEqualTo(version)    [NSString tm_isVersion:OS_VERSION greaterThanOrEqualTo:(version)]
#define isOsVersionLessThan(version)                [NSString tm_isVersion:OS_VERSION lessThan:(version)]
#define isOsVersionLessThanOrEqualTo(version)       [NSString tm_isVersion:OS_VERSION lessThanOrEqualTo:(version)]

//App版本
#define APP_VERSION     [TMDeviceInfo appVersion]
#define isAppVersionGreaterThan(version)            [NSString tm_isVersion:APP_VERSION greaterThan:(version)]
#define isAppVersionGreaterThanOrEqualTo(version)   [NSString tm_isVersion:APP_VERSION greaterThanOrEqualTo:(version)]
#define isAppVersionLessThan(version)               [NSString tm_isVersion:APP_VERSION lessThan:(version)]
#define isAppVersionLessThanOrEqualTo(version)      [NSString tm_isVersion:APP_VERSION lessThanOrEqualTo:(version)]

//App编译版本
#define APP_BUILD_VERSION     [TMDeviceInfo appBuildVersion]
#define isAppBuildVersionGreaterThan(version)           [NSString tm_isVersion:APP_BUILD_VERSION greaterThan:(version)]
#define isAppBuildVersionGreaterThanOrEqualTo(version)  [NSString tm_isVersion:APP_BUILD_VERSION greaterThanOrEqualTo:(version)]
#define isAppBuildVersionLessThan(version)              [NSString tm_isVersion:APP_BUILD_VERSION lessThan:(version)]
#define isAppBuildVersionLessThanOrEqualTo(version)     [NSString tm_isVersion:APP_BUILD_VERSION lessThanOrEqualTo:(version)]

//常用Size
#define SCREEN_WIDTH        ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT       ([[UIScreen mainScreen] bounds].size.height)
#define STATUSBAR_HEIGHT      ([TMDeviceInfo isAboveOrEqualToIPhoneX] ? 44 : 20)
#define NAVIGATIONBAR_HEIGHT    44
#define APP_VIEW_HEIGHT     (SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT)
#define TABBAR_HEIGHT           49
#define SUB_TABBAR_HEIGHT       44
#define AMEND_STATUSBAR_HEIGHT  ((SYSTEM_VERSION < 7.0) ? (-STATUSBAR_HEIGHT) : (0))

//UIColor
#ifndef TMRGB
#define TMRGB
#define RGB(r, g, b)        [UIColor colorWithRed: (float)(r)/255.f green: (float)(g)/255.f blue: (float)(b)/255.f alpha: 1.0f]
#define RGBA(r, g, b, a)    [UIColor colorWithRed: (float)(r)/255.f green: (float)(g)/255.f blue: (float)(b)/255.f alpha: a]

#define RGB_HEX(rgb)            [UIColor tm_colorWithRGBHex:(rgb)]
#define RGB_HEX_ALPHA(rgb, a)   [UIColor tm_colorWithRGBHex:(rgb) alpha:a]
#define RGBA_HEX(rgba)          [UIColor tm_colorWithRGBAHex:(rgba)]
#define ARGB_HEX(argb)          [UIColor tm_colorWithARGBHex:(argb)]

#define RGB_HEX_STR(rgb)            [UIColor tm_colorWithRGBHexString:(rgb)]
#define RGB_HEX_STR_ALPHA(rgb, a)   [UIColor tm_colorWithRGBHexString:(rgb) alpha:a]
#define RGBA_HEX_STR(rgba)          [UIColor tm_colorWithRGBAHexString:(rgba)]
#define ARGB_HEX_STR(argb)          [UIColor tm_colorWithARGBHexString:(argb)]
#endif

//Other
#define ValueOrEmptyString(value) ((value)?(value):@"")

#ifndef onExit

/**
 * Returns A and B concatenated after full macro expansion.
 */
#define metamacro_concat(A, B) \
metamacro_concat_(A, B)
#define metamacro_concat_(A, B) A ## B

#if DEBUG
#define rac_keywordify autoreleasepool {}
#else
#define rac_keywordify try {} @catch (...) {}
#endif

/*** implementation details follow ***/
typedef void (^tm_cleanupBlock_t)(void);

static inline void tm_executeCleanupBlock (__strong tm_cleanupBlock_t *block) {
    (*block)();
}

#define onExit \
rac_keywordify \
__strong tm_cleanupBlock_t metamacro_concat(tm_exitBlock_, __LINE__) __attribute__((cleanup(tm_executeCleanupBlock), unused)) = ^

#endif


#endif /* BZMacro_h */
