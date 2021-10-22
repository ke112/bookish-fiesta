//
//  UILabel+Zhext.h
//  GoodLife_New
//
//  Created by hshs on 2021/4/20.
//  Copyright © 2021 好生活. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Zhext)

/// 把label的每行文字数组返回
- (NSArray *)getLinesArrayOfStringInLabel;

/// 改变行间距
- (void)changeLineSpace:(float)space;

/// 改变字间距
- (void)changeWordSpace:(float)space;

/// 改变行间距和字间距
- (void)changeWithLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

@end

NS_ASSUME_NONNULL_END
