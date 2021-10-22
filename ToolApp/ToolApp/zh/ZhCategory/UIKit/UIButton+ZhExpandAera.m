//
//  UIButton+ZhExpandAera.m
//  WeDriveCoach
//
//  Created by 张志华 on 2/27/20.
//  Copyright © 2020 zhangzhihua. All rights reserved.
//

#import "UIButton+ZhExpandAera.h"
#import <objc/runtime.h>

static char zhTopKey;
static char zhLeftKey;
static char zhBottomKey;
static char zhRightKey;

@implementation UIButton (ZhExpandAera)

- (void)zh_AddClickLength:(CGFloat)length{
    
    [self zh_AddClickRange:ZHClickEdgeInsetsMake(length, length, length, length)];
}

- (void)zh_AddClickRange:(ZHClickEdgeInsets)edgeInsets{
    
    objc_setAssociatedObject(self, &zhTopKey, [NSNumber numberWithFloat:edgeInsets.top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &zhLeftKey, [NSNumber numberWithFloat:edgeInsets.left], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &zhBottomKey, [NSNumber numberWithFloat:edgeInsets.bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &zhRightKey, [NSNumber numberWithFloat:edgeInsets.right], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{

    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds))
    {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}

- (CGRect)enlargedRect
{
    NSNumber *topEdge = objc_getAssociatedObject(self, &zhTopKey);
    NSNumber *leftEdge = objc_getAssociatedObject(self, &zhLeftKey);
    NSNumber *bottomEdge = objc_getAssociatedObject(self, &zhBottomKey);
    NSNumber *rightEdge = objc_getAssociatedObject(self, &zhRightKey);
   
    if (topEdge && rightEdge && bottomEdge && leftEdge){
        
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    }else{
        
        return self.bounds;
    }
}


@end
