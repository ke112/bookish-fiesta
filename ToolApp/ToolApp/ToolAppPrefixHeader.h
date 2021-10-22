//
//  ToolAppPrefixHeader.h
//  ToolApp
//
//  Created by zhangzhihua on 2021/7/20.
//

#ifndef ToolAppPrefixHeader_h
#define ToolAppPrefixHeader_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import <Masonry/Masonry.h>
#import "zhHeader.h"

//屏幕
#define kScreenWidth          ([UIApplication sharedApplication].delegate.window.bounds.size.width)
#define kScreenHeight         ([UIApplication sharedApplication].delegate.window.bounds.size.height)

//手机型号和平板
#define kIS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define kIS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

/// 判断是否为iPhone X 系列  这样写消除了在Xcode10上的警告。
#define kiPhoneXScreen \
({BOOL isPhoneX = NO;\
if (@available(iOS 13.0, *)) {\
isPhoneX = [UIApplication sharedApplication].windows.firstObject.safeAreaInsets.bottom > 0.0;\
}else if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

/// 状态栏
#define kStatusBarH \
({CGFloat statusBarHeight = 0;\
if (@available(iOS 13.0, *)) {\
    UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager;\
    statusBarHeight = statusBarManager.statusBarFrame.size.height;\
}else {\
    statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;\
}\
(statusBarHeight);})


#define kNaviBarH                      44
#define kNavAndStatusHight             (kStatusBarH + kNaviBarH)
#define kTabBarH                       (kSafeAreaBottom + 49)

#define kSafeAreaBottom \
^double(){\
if (@available(iOS 11.0, *)) { \
return [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom; \
} else { \
return 0.0; \
} \
}()\

#define kSafeBottomHeight (kSafeAreaBottom ? kSafeAreaBottom : 20)

#define kScaleOfScreen(V)     (V) * MIN(kScreenWidth, kScreenHeight) / (kIS_IPHONE ? 375.0 : 768.0)

#define KKLog(format, ...) printf("class: < %s:(%d行) > method: %s: %s\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )

#define kColorWithHex(v)     [UIColor zh_colorWithHexString:[NSString stringWithFormat:@"%@",v]]
#define kRandomColor         [UIColor zh_randomColor]

// 字符串是否为空
#define kStringIsEmpty(str)       [NSString zh_isEmptyString:str]
#define kStringIsNotEmpty(str)    ![NSString zh_isEmptyString:str]
// 设置字符串显示,附带设置默认值
#define kStringCheckEmptyShow(str,defaultStr)   (kStringIsEmpty(str)?defaultStr:str)
// 数组是否为空
#define kArrayIsEmpty(array)    (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
// 字典是否为空
#define kDictIsEmpty(dic)     (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
// 是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

/// 判断debug
#ifdef DEBUG
#define kISDebugModel YES
#else
#define kISDebugModel NO
#endif

#define kDefaultBackgrouncColor   kColorWithHex(@"f5f5f5")



#endif /* ToolAppPrefixHeader_h */
