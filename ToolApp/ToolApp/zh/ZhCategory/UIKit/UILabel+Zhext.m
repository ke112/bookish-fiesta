//
//  UILabel+Zhext.m
//  GoodLife_New
//
//  Created by hshs on 2021/4/20.
//  Copyright © 2021 好生活. All rights reserved.
//

#import "UILabel+Zhext.h"
#import <CoreText/CoreText.h>

@implementation UILabel (Zhext)

/// 把label的每行文字数组返回
- (NSArray *)getLinesArrayOfStringInLabel{
    NSString *text = [self text];
    if (text.length==0) {
        return @[];
    }
    UIFont *font = [self font];
    CGRect rect = [self frame];
    
    CTFontRef myFont = CTFontCreateWithName(( CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge  id)myFont range:NSMakeRange(0, attStr.length)];
    CFRelease(myFont);
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(( CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = ( NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    for (id line in lines) {
        CTLineRef lineRef = (__bridge  CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        NSString *lineString = [text substringWithRange:range];
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithFloat:0.0]));
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithInt:0.0]));
        //NSLog(@"''''''''''''''''''%@",lineString);
        [linesArray addObject:lineString];
    }
    
    CGPathRelease(path);
    CFRelease( frame );
    CFRelease(frameSetter);
    return (NSArray *)linesArray;
}

/// 改变行间距
- (void)changeLineSpace:(float)space{
    NSString *labelText = self.text;
    if (![labelText isKindOfClass:[NSString class]]) {
        return;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText]; NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init]; [paragraphStyle setLineSpacing:space]; [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])]; self.attributedText = attributedString;
    [self sizeToFit];
}

/// 改变字间距
- (void)changeWordSpace:(float)space{
    NSString *labelText = self.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(space)}]; NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init]; [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
        self.attributedText = attributedString;
    [self sizeToFit];
}

/// 改变行间距和字间距
- (void)changeWithLineSpace:(float)lineSpace WordSpace:(float)wordSpace{
    NSString *labelText = self.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(wordSpace)}]; NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init]; [paragraphStyle setLineSpacing:lineSpace]; [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
    [self sizeToFit];
}

@end
