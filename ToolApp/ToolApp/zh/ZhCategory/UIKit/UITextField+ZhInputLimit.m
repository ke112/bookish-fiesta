//
//  UITextView+Zh.h
//  OriginalPro
//
//  Created by zhangzhihua on 2019/3/1.
//  Copyright © 2019 zhangzhihua. All rights reserved.
//

#import "UITextField+ZhInputLimit.h"
#import <objc/runtime.h>

static const void *JKTextFieldInputLimitMaxLength = &JKTextFieldInputLimitMaxLength;
@implementation UITextField (ZhInputLimit)

- (NSInteger)zh_maxLength {
    return [objc_getAssociatedObject(self, JKTextFieldInputLimitMaxLength) integerValue];
}
- (void)setzh_maxLength:(NSInteger)maxLength {
    objc_setAssociatedObject(self, JKTextFieldInputLimitMaxLength, @(maxLength), OBJC_ASSOCIATION_ASSIGN);
    [self addTarget:self action:@selector(zh_textFieldTextDidChange) forControlEvents:UIControlEventEditingChanged];
}
- (void)zh_textFieldTextDidChange {
    NSString *toBeString = self.text;
    //获取高亮部分
    UITextRange *selectedRange = [self markedTextRange];
    UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
    
    //没有高亮选择的字，则对已输入的文字进行字数统计和限制
    //在iOS7下,position对象总是不为nil
    if ( (!position ||!selectedRange) && (self.zh_maxLength > 0 && toBeString.length > self.zh_maxLength))
    {
        NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.zh_maxLength];
        if (rangeIndex.length == 1)
        {
            self.text = [toBeString substringToIndex:self.zh_maxLength];
        }
        else
        {
            NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.zh_maxLength)];
            NSInteger tmpLength;
            if (rangeRange.length > self.zh_maxLength) {
                tmpLength = rangeRange.length - rangeIndex.length;
            }else{
                tmpLength = rangeRange.length;
            }
            self.text = [toBeString substringWithRange:NSMakeRange(0, tmpLength)];
        }
    }
}
@end
