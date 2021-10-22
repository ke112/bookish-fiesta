//
//  UIButton+ZhEdge.h
//  OriginalPro
//
//  Created by zhangzhihua on 2019/2/15.
//  Copyright © 2019 zhangzhihua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZhImagePositionType) {
    ZhImagePositionTypeLeft,   //图片在左，标题在右，默认风格
    ZhImagePositionTypeRight,  //图片在右，标题在左
    ZhImagePositionTypeTop,    //图片在上，标题在下
    ZhImagePositionTypeBottom  //图片在下，标题在上
};

typedef NS_ENUM(NSInteger, ZhEdgeInsetsType) {
    ZhEdgeInsetsTypeTitle,//标题
    ZhEdgeInsetsTypeImage//图片
};

typedef NS_ENUM(NSInteger, ZhMarginType) {
    ZhMarginTypeTop         ,
    ZhMarginTypeBottom      ,
    ZhMarginTypeLeft        ,
    ZhMarginTypeRight       ,
    ZhMarginTypeTopLeft     ,
    ZhMarginTypeTopRight    ,
    ZhMarginTypeBottomLeft  ,
    ZhMarginTypeBottomRight
};

/**
 默认情况下，imageEdgeInsets和titleEdgeInsets都是0。先不考虑height,
 
 if (button.width小于imageView上image的width){图像会被压缩，文字不显示}
 
 if (button.width < imageView.width + label.width){图像正常显示，文字显示不全}
 
 if (button.width >＝ imageView.width + label.width){图像和文字都居中显示，imageView在左，label在右，中间没有空隙}
 */


@interface UIButton (ZhEdge)

/**
 *  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现图片和标题的自由排布
 *  注意：1.该方法需在设置图片和标题之后才调用;
         2.图片和标题改变后需再次调用以重新计算titleEdgeInsets和imageEdgeInsets
 *
 *  @param type    图片位置类型
 *  @param spacing 图片和标题之间的间隙
 */
- (void)zh_setImagePositionWithType:(ZhImagePositionType)type spacing:(CGFloat)spacing;

/**
 *  按钮只设置了title or image，该方法可以改变它们的位置
 *
 *  @param edgeInsetsType edgeInsetsType description
 *  @param marginType     marginType description
 *  @param margin         margin description
 */
- (void)zh_setEdgeInsetsWithType:(ZhEdgeInsetsType)edgeInsetsType marginType:(ZhMarginType)marginType margin:(CGFloat)margin;


@end

NS_ASSUME_NONNULL_END
