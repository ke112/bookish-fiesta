//
//  UIBarButtonItem+ZhNavigationBar.h
//  OriginalPro
//
//  Created by ZhangZhihua on 2019/1/23.
//  Copyright © 2019 ZhangZhihua. All rights reserved.
//

#import "UIBarButtonItem+ZhNavigationBar.h"

@implementation UIBarButtonItem (ZhNavigationBar)

+ (instancetype)zh_itemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    return [self zh_itemWithTitle:title image:nil target:target action:action];
}

+ (instancetype)zh_itemWithImage:(UIImage *)image target:(id)target action:(SEL)action {
    return [self zh_itemWithTitle:nil image:image target:target action:action];
}

+ (instancetype)zh_itemWithTitle:(NSString *)title image:(UIImage *)image target:(id)target action:(SEL)action {
    return [self zh_itemWithTitle:title image:image highLightImage:image target:target action:action];
}

+ (instancetype)zh_itemWithImage:(UIImage *)image highLightImage:(UIImage *)highLightImage target:(id)target action:(SEL)action {
    return [self zh_itemWithTitle:nil image:image highLightImage:highLightImage target:target action:action];
}

+ (instancetype)zh_itemWithTitle:(NSString *)title image:(UIImage *)image highLightImage:(UIImage *)highLightImage target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(.0, -8.0, .0, 8.0);
    }
    if (highLightImage) {
        [button setImage:highLightImage forState:UIControlStateHighlighted];
    }
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    if (button.bounds.size.width < 44.0f) {
        button.bounds = CGRectMake(0, 0, 44.0f, 44.0f);
    }
    button.backgroundColor = UIColor.purpleColor;
    
    return [[self alloc] initWithCustomView:button];
}

@end
