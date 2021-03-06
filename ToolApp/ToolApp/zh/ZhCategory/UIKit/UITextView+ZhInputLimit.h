//
//  UITextView+Zh.h
//  OriginalPro
//
//  Created by zhangzhihua on 2019/3/1.
//  Copyright © 2019 zhangzhihua. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void(^textViewHeightDidChangedBlock)(CGFloat currentTextViewHeight);

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (ZhInputLimit)

@property (nonatomic, assign)  NSInteger zh_maxLength;//if <=0, no limit

/* 占位文字 */
@property (nonatomic, copy) NSString *zh_placeholder;

/* 占位文字颜色 */
@property (nonatomic, strong) UIColor *zh_placeholderColor;

/* 最大高度，如果需要随文字改变高度的时候使用 */
@property (nonatomic, assign) CGFloat zh_maxHeight;

/* 最小高度，如果需要随文字改变高度的时候使用 */
@property (nonatomic, assign) CGFloat zh_minHeight;

@property (nonatomic, copy) textViewHeightDidChangedBlock zh_textViewHeightDidChanged;

/* 获取图片数组 */
- (NSArray *)zh_getImages;

/* 单独设置UITextView行间距 */
- (void)zh_LineSpace:(CGFloat)lineSpace;

/* 自动高度的方法，maxHeight：最大高度 */
- (void)zh_autoHeightWithMaxHeight:(CGFloat)maxHeight;

/* 自动高度的方法，maxHeight：最大高度， textHeightDidChanged：高度改变的时候调用 */
- (void)zh_autoHeightWithMaxHeight:(CGFloat)maxHeight textViewHeightDidChanged:(nullable textViewHeightDidChangedBlock)textViewHeightDidChanged;

/* 添加一张图片 image:要添加的图片 */
- (void)zh_addImage:(UIImage *)image;

/* 添加一张图片 image:要添加的图片 size:图片大小 */
- (void)zh_addImage:(UIImage *)image size:(CGSize)size;

/* 插入一张图片 image:要添加的图片 size:图片大小 index:插入的位置 */
- (void)zh_insertImage:(UIImage *)image size:(CGSize)size index:(NSInteger)index;

/* 添加一张图片 image:要添加的图片 multiple:放大／缩小的倍数 */
- (void)zh_addImage:(UIImage *)image multiple:(CGFloat)multiple;

/* 插入一张图片 image:要添加的图片 multiple:放大／缩小的倍数 index:插入的位置 */
- (void)zh_insertImage:(UIImage *)image multiple:(CGFloat)multiple index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
