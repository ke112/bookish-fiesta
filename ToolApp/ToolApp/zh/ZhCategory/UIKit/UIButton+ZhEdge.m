//
//  UIButton+ZhEdge.m
//  OriginalPro
//
//  Created by zhangzhihua on 2019/2/15.
//  Copyright © 2019 zhangzhihua. All rights reserved.
//

#import "UIButton+ZhEdge.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define Zh_SINGLELINE_TEXTSIZE(text, font) [text length] > 0 ? [text \
sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;
#else
#define Zh_SINGLELINE_TEXTSIZE(text, font) [text length] > 0 ? [text sizeWithFont:font] : CGSizeZero;
#endif


@implementation UIButton (ZhEdge)


- (void)zh_setImagePositionWithType:(ZhImagePositionType)type spacing:(CGFloat)spacing {
    CGSize imageSize = [self imageForState:UIControlStateNormal].size;
    CGSize titleSize = Zh_SINGLELINE_TEXTSIZE([self titleForState:UIControlStateNormal], self.titleLabel.font);
    
    switch (type) {
        case ZhImagePositionTypeLeft: {
            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
            break;
        }
        case ZhImagePositionTypeRight: {
            self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, 0, imageSize.width + spacing);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, titleSize.width + spacing, 0, - titleSize.width);
            break;
        }
        case ZhImagePositionTypeTop: {
            self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (imageSize.height + spacing), 0);
            self.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), 0, 0, - titleSize.width);
            break;
        }
        case ZhImagePositionTypeBottom: {
            self.titleEdgeInsets = UIEdgeInsetsMake(- (imageSize.height + spacing), - imageSize.width, 0, 0);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, - (titleSize.height + spacing), - titleSize.width);
            break;
        }
    }
}

- (void)zh_setEdgeInsetsWithType:(ZhEdgeInsetsType)edgeInsetsType marginType:(ZhMarginType)marginType margin:(CGFloat)margin {
    CGSize itemSize = CGSizeZero;
    if (edgeInsetsType == ZhEdgeInsetsTypeTitle) {
        itemSize = Zh_SINGLELINE_TEXTSIZE([self titleForState:UIControlStateNormal], self.titleLabel.font);
    } else {
        itemSize = [self imageForState:UIControlStateNormal].size;
    }
    
    CGFloat horizontalDelta = (CGRectGetWidth(self.frame) - itemSize.width) / 2.f - margin;
    CGFloat vertivalDelta = (CGRectGetHeight(self.frame) - itemSize.height) / 2.f - margin;
    
    NSInteger horizontalSignFlag = 1;
    NSInteger verticalSignFlag = 1;
    
    switch (marginType) {
        case ZhMarginTypeTop: {
            horizontalSignFlag = 0;
            verticalSignFlag = - 1;
            break;
        }
        case ZhMarginTypeBottom: {
            horizontalSignFlag = 0;
            verticalSignFlag = 1;
            break;
        }
        case ZhMarginTypeLeft: {
            horizontalSignFlag = - 1;
            verticalSignFlag = 0;
            break;
        }
        case ZhMarginTypeRight: {
            horizontalSignFlag = 1;
            verticalSignFlag = 0;
            break;
        }
        case ZhMarginTypeTopLeft: {
            horizontalSignFlag = - 1;
            verticalSignFlag = - 1;
            break;
        }
        case ZhMarginTypeTopRight: {
            horizontalSignFlag = 1;
            verticalSignFlag = - 1;
            break;
        }
        case ZhMarginTypeBottomLeft: {
            horizontalSignFlag = - 1;
            verticalSignFlag = 1;
            break;
        }
        case ZhMarginTypeBottomRight: {
            horizontalSignFlag = 1;
            verticalSignFlag = 1;
            break;
        }
    }
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(vertivalDelta * verticalSignFlag, horizontalDelta * horizontalSignFlag, - vertivalDelta * verticalSignFlag, - horizontalDelta * horizontalSignFlag);
    if (edgeInsetsType == ZhEdgeInsetsTypeTitle) {
        self.titleEdgeInsets = edgeInsets;
    } else {
        self.imageEdgeInsets = edgeInsets;
    }
}

@end
