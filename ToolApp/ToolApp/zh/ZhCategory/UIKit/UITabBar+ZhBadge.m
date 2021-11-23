//
//  UITabBar+ZhBadge.m
//  自定义TabBar小红点
//
//  Created by laidongling on 17/7/12.
//  Copyright © 2017年 LaiDongling. All rights reserved.
//

#import "UITabBar+ZhBadge.h"
#import <objc/runtime.h>

#define badgeTag(index) (1000 + index)

static char *kBadgeSize = "kBadgeSize";
static char *kBadgeColor = "kBadgeColor";
static char *kBadgeImage = "kBadgeImage";

@implementation UITabBar (ZhBadge)

//运行时处理分类属性
- (void)setZh_badgeSize:(CGSize)zh_badgeSize{
    objc_setAssociatedObject(self, &kBadgeSize,[NSValue valueWithCGSize:zh_badgeSize], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CGSize)zh_badgeSize{
    return [objc_getAssociatedObject(self, &kBadgeSize) CGSizeValue];
}

- (void)setZh_badgeImage:(UIImage *)zh_badgeImage{
    objc_setAssociatedObject(self, &kBadgeImage, zh_badgeImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIImage *)zh_badgeImage{
    return objc_getAssociatedObject(self, &kBadgeImage);
}

- (void)setZh_badgeColor:(UIColor *)zh_badgeColor{
    objc_setAssociatedObject(self, &kBadgeColor, zh_badgeColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIColor *)zh_badgeColor{
    return objc_getAssociatedObject(self, &kBadgeColor);
}


//显示小红点
- (void)zh_showBadgeOnItemIndex:(NSUInteger)index
{
    //移除
    [self removeRedPointOnIndex:index animation:NO];
    
    //默认值设置
    if (CGSizeEqualToSize(self.zh_badgeSize, CGSizeZero))
    {
        self.zh_badgeSize = CGSizeMake(12, 12);
    }
    if (!self.zh_badgeColor)
    {
        self.zh_badgeColor = [UIColor redColor];
    }
    
    //badgeView(小红点)
    CGSize badgeSize = self.zh_badgeSize;
    UIView *badgeView = [[UIView alloc]init];
    badgeView.backgroundColor = self.zh_badgeColor;
    badgeView.layer.cornerRadius = badgeSize.width / 2;
    badgeView.tag = badgeTag(index);
    
    //barButtonView(里面包含文字和图片)
    UIView *barButtonView = [self getBarButttonViewWithIndex:index];
    //（图片的imageView）
    UIView *iconView = nil;
    for (UIView *swappableImageView  in barButtonView.subviews)
    {
        if ([swappableImageView isKindOfClass:[UIImageView class]])
        {
            iconView = swappableImageView;
            break;
        }
    }
    CGSize iconViewSize = iconView.frame.size;
    badgeView.frame = CGRectMake(iconViewSize.width - badgeSize.width / 2, - badgeSize.width / 2, badgeSize.width, badgeSize.height);
    //添加图片到小红点上
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:badgeView.bounds];
    imageview.image = self.zh_badgeImage;
    if (self.zh_badgeImage)
    {
        self.zh_badgeColor = [UIColor clearColor];
    }
    [badgeView addSubview:imageview];
    
    //添加小红点到系统图层上
    [iconView addSubview:badgeView];
    
 }

//隐藏小红点
- (void)zh_hiddenRedPointOnIndex:(NSUInteger)index animation:(BOOL)animation
{
    [self removeRedPointOnIndex:index animation:animation];
    
}

- (void)removeRedPointOnIndex:(NSUInteger)index animation:(BOOL)animation
{
    //获取对应的barButtonView（里面包含文字和图片）
    UIView *barButtonView = [self getBarButttonViewWithIndex:index];
    for (UIView *swapView in barButtonView.subviews)
    {
        if ([swapView isKindOfClass:[UIImageView class]])       //遍历出图片类的uiview图层_iconView
        {
            for (UIView *view in swapView.subviews)
            {
                if (view.tag == badgeTag(index))                //找到了小红点
                {
                    if (animation)
                    {
                        [UIView animateWithDuration:0.2 animations:^{
                            view.transform = CGAffineTransformScale(view.transform, 2, 2);
                            view.alpha = 0;
                            
                        } completion:^(BOOL finished) {
                            [view removeFromSuperview];
                        }];
                        
                    }else
                    {
                        [view removeFromSuperview];
                    }
                }
            }
            
            
        }
    }
}


//获取barButtonView
- (UIView *)getBarButttonViewWithIndex:(NSUInteger)index
{
    UIBarButtonItem *item = (UIBarButtonItem *)[self.items  objectAtIndex:index];
    //通过runtime和KVC找到UIBarBottunItem的View，至于为什么是“view”，可在 viewController中使用【self test】方法进行调试打印
    UIView *barButtonView = [item valueForKey:@"view"];
    return barButtonView;

}

@end
