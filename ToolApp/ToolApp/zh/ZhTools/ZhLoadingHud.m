//
//  ZhLoadingHud.m
//  Consultant
//
//  Created by 张志华 on 5/31/20.
//  Copyright © 2020 zhangzhihua. All rights reserved.
//

#import "ZhLoadingHud.h"

#if __has_include(<MBProgressHUD/MBProgressHUD.h>)
#import <MBProgressHUD/MBProgressHUD.h>
#elif __has_include("MBProgressHUD.h")
#import "MBProgressHUD.h"
#endif

static MBProgressHUD *shareHud;
static MBProgressHUD *shareProgressHud;

@implementation ZhLoadingHud

+ (void)load{
    
}
/// 计算文字自动消息的时间
/// @param hint 文字
+ (NSTimeInterval)getHudHideTimeWithHint:(NSString *)hint{
    return 0.5 + hint.length * 0.1;
}
/// 背景色
+ (UIColor *)HudViewColor{
    return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
}
/// 窗口视图
+ (UIView *)superWindowView{
    UIView *view;
    if (@available(iOS 13.0, *)) {
        view = [UIApplication sharedApplication].windows.firstObject;
    }else {
        view = [[UIApplication sharedApplication].delegate window];
    }
    return view;
}

/// 菊花框
+ (void)showHudAddedTo:(nullable UIView *)view{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showHudWithHint:nil addedTo:view];
    });
}

/// 隐藏hud
+ (void)hideHud{
    if (shareHud) {
        [shareHud hideAnimated:YES];
        shareHud = nil;
    }
}

/// 只显示文字
+ (void)showHint:(NSString *)hint addedTo:(nullable UIView *)view{
    if (hint == nil || hint.length == 0) {
        NSLog(@"只显示文字参数不能为空");
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideHud];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view?:[self superWindowView] animated:YES];
        shareHud = hud;
        hud.mode = MBProgressHUDModeText;
        hud.label.text = hint;
    //    hud.offset = CGPointMake(0.f, MBProgressMaxOffset); //底部显示
        [hud hideAnimated:YES afterDelay:[self getHudHideTimeWithHint:hint]];
    });
}

/// 菊花框+文字
+ (void)showHudWithHint:(nullable NSString *)hint addedTo:(nullable UIView *)view{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideHud];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view?:[self superWindowView] animated:YES];
        shareHud = hud;
        if (hint) {
            hud.label.text = hint;
        }
    });
}
/// 自定义图片+文字
+ (void)showHudWithImage:(NSString *)image hint:(NSString *)hint addedTo:(nullable UIView *)view{
    if (image == nil || image.length == 0) {
        NSLog(@"自定义图片参数不能为空");
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideHud];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view?:[self superWindowView] animated:YES];
        shareHud = hud;
        hud.mode = MBProgressHUDModeCustomView;
        UIImage *imageShow = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        hud.customView = [[UIImageView alloc] initWithImage:imageShow];
        hud.square = YES;
        hud.label.text = hint;
        [hud hideAnimated:YES afterDelay:[self getHudHideTimeWithHint:hint]];
    });
}

/// 自定义hud风格图片+文字
+ (void)showHudWithImage:(NSString *)image hint:(NSString *)hint addedTo:(nullable UIView *)view yOffset:(float)yOffset{
    if (image == nil || image.length == 0) {
        NSLog(@"自定义图片参数不能为空");
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideHud];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view?:[self superWindowView] animated:YES];
        shareHud = hud;
        //下面的2行代码必须要写，如果不写就会导致指示器的背景永远都会有一层透明度为0.5的背景
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = [UIColor colorWithWhite:0.5f alpha:0.5f];
        hud.userInteractionEnabled = YES;
        //设置自定义样式的mode
        hud.mode = MBProgressHUDModeCustomView;
        
        CGRect rect = [hint boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil];
        CGFloat rectW = 120;//rect.size.width+50;
        CGFloat rectH = 100;
        hud.minSize = CGSizeMake(rectW, rectH);
        hud.bezelView.layer.masksToBounds = NO;

        UIImageView *customView1 = [[UIImageView alloc]initWithFrame:CGRectMake((rectW-36)/2, 15, 36, 36)];
        [customView1 setImage:[UIImage imageNamed:image]];
        [hud.bezelView addSubview:customView1];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 55,rectW-20 ,30)];
        titleLabel.text = hint;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        titleLabel.textColor = [UIColor whiteColor];
        [hud.bezelView addSubview:titleLabel];
        
        hud.margin = 20.f;
        hud.offset = CGPointMake(0, yOffset);
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:MAX(1.5, [self getHudHideTimeWithHint:hint])];
    });
}


/// 进度加载圆环 + 文字
+ (void)showHudWithProgress:(CGFloat)progress hint:(NSString *)hint addedTo:(nullable UIView *)view{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideHud];
        if (shareProgressHud) {
            shareProgressHud.progress = progress;
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view?:[self superWindowView] animated:YES];
            shareProgressHud = hud;
            hud.mode = MBProgressHUDModeAnnularDeterminate;
            hud.label.text = hint;
            hud.margin = 20;
            hud.removeFromSuperViewOnHide = YES;
            hud.progress = progress;
        }
        if (progress == 1.0) {
            [shareProgressHud hideAnimated:YES];
            shareProgressHud = nil;
        }
    });
}

@end
