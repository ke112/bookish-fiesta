//
//  UIBarButtonItem+ZhNavigationBar.h
//  OriginalPro
//
//  Created by ZhangZhihua on 2019/1/23.
//  Copyright © 2019 ZhangZhihua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (ZhNavigationBar)

+ (instancetype)zh_itemWithTitle:(NSString *)title target:(id)target action:(SEL)action;

+ (instancetype)zh_itemWithImage:(UIImage *)image target:(id)target action:(SEL)action;

+ (instancetype)zh_itemWithTitle:(nullable NSString *)title image:(nullable UIImage *)image target:(id)target action:(SEL)action;

+ (instancetype)zh_itemWithImage:(nullable UIImage *)image highLightImage:(nullable UIImage *)highLightImage target:(id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
