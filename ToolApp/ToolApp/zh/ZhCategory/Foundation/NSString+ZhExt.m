//
//  NSString+ZhExt.m
//  OriginalPro
//
//  Created by ZhangZhihua on 2019/1/23.
//  Copyright © 2019 ZhangZhihua. All rights reserved.
//

#import "NSString+ZhExt.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (ZhExt)


/// 判断是否是空串
+ (BOOL)zh_isEmptyString:(nullable NSString *)str{
    NSString *string = [NSString stringWithFormat:@"%@",str];
    if (string == nil || string == NULL || [string isEqualToString:@"null"] || [string isEqualToString:@"(null)"] || [string isEqualToString:@"<null>"]) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0){
        return YES;
    }
    if (string.length == 0) {
        return YES;
    }
    return NO;
}

/// 验证字符串是否是【邮箱】
- (BOOL)zh_isValidateEmail{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

/// 验证字符串是否是【手机号】
- (BOOL)zh_isValidateMobile{
    NSPredicate* phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"1[34578]([0-9]){9}"];
    return [phoneTest evaluateWithObject:self];
}

/// 验证字符串是否是【身份证】
- (BOOL)zh_isValidateIDCard{
    NSString *IDCard = self;
    IDCard = [IDCard stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([IDCard length] != 18) {
        return NO;
    }
    NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString *leapMmdd = @"0229";
    NSString *year = @"(19|20)[0-9]{2}";
    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd  , @"[0-9]{3}[0-9Xx]"];
    
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![regexTest evaluateWithObject:IDCard]) {
        return NO;
    }
    int summary = ([IDCard substringWithRange:NSMakeRange(0,1)].intValue + [IDCard substringWithRange:NSMakeRange(10,1)].intValue) *7
    + ([IDCard substringWithRange:NSMakeRange(1,1)].intValue + [IDCard substringWithRange:NSMakeRange(11,1)].intValue) *9
    + ([IDCard substringWithRange:NSMakeRange(2,1)].intValue + [IDCard substringWithRange:NSMakeRange(12,1)].intValue) *10
    + ([IDCard substringWithRange:NSMakeRange(3,1)].intValue + [IDCard substringWithRange:NSMakeRange(13,1)].intValue) *5
    + ([IDCard substringWithRange:NSMakeRange(4,1)].intValue + [IDCard substringWithRange:NSMakeRange(14,1)].intValue) *8
    + ([IDCard substringWithRange:NSMakeRange(5,1)].intValue + [IDCard substringWithRange:NSMakeRange(15,1)].intValue) *4
    + ([IDCard substringWithRange:NSMakeRange(6,1)].intValue + [IDCard substringWithRange:NSMakeRange(16,1)].intValue) *2
    + [IDCard substringWithRange:NSMakeRange(7,1)].intValue *1 + [IDCard substringWithRange:NSMakeRange(8,1)].intValue *6
    + [IDCard substringWithRange:NSMakeRange(9,1)].intValue *3;
    NSInteger remainder = summary % 11;
    NSString *checkBit = @"";
    NSString *checkString = @"10X98765432";
    checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];// 判断校验位
    return [checkBit isEqualToString:[[IDCard substringWithRange:NSMakeRange(17,1)] uppercaseString]];
}

/// 验证字符串是否是【银行卡】
- (BOOL)zh_isValidateBankCard{
    if ([self zh_isPureNum] == NO) {
        return NO;
    }
    NSString *str = self;
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[str length];
    int lastNum = [[str substringFromIndex:cardNoLength-1] intValue];
    
    str = [str substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [str substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0){
        return YES;
    }else{
        return NO;
    }
}
/// 判断是否是纯数字
-(BOOL)zh_isPureNum{
    if (self.length == 0) {
        return NO;
    }
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}
/// 由字母或数字组成 8-16位密码字符串（正则）
- (BOOL)zh_isValidatePassword{
    NSString *pattern =@"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{8,16}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}
/// 判断一个字符串是否包含数字
- (BOOL)zh_isStringContainNumber {
    NSRegularExpression *numberRegular = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSInteger count = [numberRegular numberOfMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)];
    //count是str中包含[A-Za-z]数字的个数，只要count>0，说明str中包含数字
    if (count > 0) {
        return YES;
    }
    return NO;
}

/// 判断一个字符串是否包含字母
- (BOOL)zh_isStringContainZimu {
    NSRegularExpression *numberRegular = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSInteger count = [numberRegular numberOfMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)];
    //count是str中包含[A-Za-z]数字的个数，只要count>0，说明str中包含数字
    if (count > 0) {
        return YES;
    }
    return NO;
}

/// 判断字符串是否只包含数字和字母
- (BOOL)zh_isContainsOnlyNumbersAndLetters{
    NSCharacterSet *numAndLetterCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:numAndLetterCharSet].location == NSNotFound);
}

/// 去掉字符串中的数字
- (NSString *)zh_removeNumber{
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [[self componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
}
/// 获取字符串中的数字
- (NSString *)zh_getNumber{
    NSCharacterSet *nonDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [self stringByTrimmingCharactersInSet:nonDigits];
}

/// 截取字符串（字符串都是从第0个字符开始数的哦~）
- (NSString*)zh_getSubstringFrom:(NSInteger)begin to:(NSInteger)end{
    NSRange r;
    r.location = begin;
    r.length = end - begin;
    return [self substringWithRange:r];
}
/// 新字符串替换老字符串
- (NSString *)zh_replaceCharcter:(NSString *)olderChar withCharcter:(NSString *)newerChar{
    return  [self stringByReplacingOccurrencesOfString:olderChar withString:newerChar];
}
/// 格式化HTML代码
- (NSString *)zh_htmlEntityDecode{
    NSString *string = self;
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]; // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"
    return string;
}
/// 字符串倒序排列
- (NSString *)zh_stringInversion{
    NSMutableString *reverString = [NSMutableString stringWithCapacity:self.length];
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences  usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        [reverString appendString:substring];
    }];
    return reverString;
}
/// md5加密
- (NSString *)zh_MD5{
    return [NSString zh_MD5String:self];
}
+ (NSString *)zh_MD5String:(NSString *)str;{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (uint32_t)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
    
}
/// 将中文转换成UTF8编码格式
- (NSString *)zh_utf8_Encoding{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}
/// 将UTF8编码格式转换成中文
- (NSString *)zh_utf8_DEcoding{
    return [self stringByRemovingPercentEncoding];
}
/// 将中文转换成base64编码格式
- (NSString *)zh_base64_Encode{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}
/// 将base64编码格式转换成中文
- (NSString *)zh_base64_Decode{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
/**
 字符串转Data
 */
- (NSData *)zh_utf8_Data{
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

/// 计算内容文本的高度方法
- (CGFloat)zh_heightForStringWithFontSize:(CGFloat)fontSize withWidthOfContent:(CGFloat)contentMaxWidth{
    return [self zh_heightForStringWithFont:[UIFont systemFontOfSize:fontSize] withWidthOfContent:contentMaxWidth];
}
/// 计算内容文本的高度方法
- (CGFloat)zh_heightForStringWithFont:(UIFont *)font withWidthOfContent:(CGFloat)contentMaxWidth{
    return [self zh_heightForStringWithFont:font withWidthOfContent:contentMaxWidth lineSpacing:0];
}

/// 计算内容文本的高度方法 可设置行高
- (CGFloat)zh_heightForStringWithFont:(UIFont *)font withWidthOfContent:(CGFloat)contentMaxWidth lineSpacing:(CGFloat)lineSpacing{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = lineSpacing; //这里的行高设置小于0的数,和0的效果是一样的.无需判断大于0
    
    NSMutableDictionary *attriDict = [NSMutableDictionary dictionary];
    attriDict[NSFontAttributeName] = font;
    attriDict[NSParagraphStyleAttributeName] = paragraphStyle;
    CGSize size = CGSizeMake(contentMaxWidth, MAXFLOAT);
    CGRect frame = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attriDict context:nil];
    return frame.size.height;
}
/// 计算字符串宽度
- (CGFloat)zh_widthForStringWithFontSize:(CGFloat)fontSize{
    return [self zh_widthForStringWithFont:[UIFont systemFontOfSize:fontSize]];
}
/// 计算字符串宽度
- (CGFloat)zh_widthForStringWithFont:(UIFont *)font{
    NSDictionary *attriDict = @{NSFontAttributeName:font};
    CGSize size = [self sizeWithAttributes:attriDict];
    return size.width;
}
/// 获取这个字符串中的所有要找的字符串的所在的下标
- (NSMutableArray *)zh_getRangeByFindText:(NSString *)findText{
    NSMutableArray *arrayRanges = [NSMutableArray array];
    if (findText == nil && [findText isEqualToString:@""]){
        return nil;
    }
    if ([NSString zh_isEmptyString:self]) {
        return nil;
    }
    NSRange rang = [self rangeOfString:findText]; //获取第一次出现的range
    if (rang.location != NSNotFound && rang.length != 0){
        [arrayRanges addObject:[NSNumber numberWithInteger:rang.location]];//将第一次的加入到数组中
        NSRange rang1 = {0,0};
        NSInteger location = 0;
        NSInteger length = 0;
        for (int i = 0;; i++){
            if (0 == i){
               //去掉这个abc字符串
                location = rang.location + rang.length;
                length = self.length - rang.location - rang.length;
                rang1 = NSMakeRange(location, length);
            }else{
                location = rang1.location + rang1.length;
                length = self.length - rang1.location - rang1.length;
                rang1 = NSMakeRange(location, length);
            }
            //在一个range范围内查找另一个字符串的range
            rang1 = [self rangeOfString:findText options:NSCaseInsensitiveSearch range:rang1];
            if (rang1.location == NSNotFound && rang1.length == 0){
                break;
            }else//添加符合条件的location进数组
            [arrayRanges addObject:[NSNumber numberWithInteger:rang1.location]];
        }
        return arrayRanges;
    }
    return nil;
}

/// 生成随机字符串
+ (NSString *)zh_randomStringWithLength:(NSInteger)len{
    //定义一个包含数字，大小写字母的字符串
    NSString * strAll = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    //定义一个结果
    NSString * result = [[NSMutableString alloc]initWithCapacity:len];
    for (int i = 0; i < len; i++)
    {
        //获取随机数
        NSInteger index = arc4random() % (strAll.length-1);
        char tempStr = [strAll characterAtIndex:index];
        result = (NSMutableString *)[result stringByAppendingString:[NSString stringWithFormat:@"%c",tempStr]];
    }
    return result;
}
/// 移除字符串前后的空格
- (NSString *)zh_removeSpacesBeforeAndAfter{
    //去空格和回车
    //如果仅仅是去前后空格，用whitespaceCharacterSet
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *finalStr = [self stringByTrimmingCharactersInSet:set];
    return finalStr;
}

/// 移除所有的空格
- (NSString*)zh_removeAllSpace{
    NSString *lastString;
    if([self rangeOfString:@" "].location!= NSNotFound) {
        lastString = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    }else{
        lastString = self;
    }
    return lastString;
}

/// 移除结尾的子字符串
- (NSString *)zh_removeLastSubString:(NSString *)string{
    NSString *result = self;
    if ([result hasSuffix:string]) {
        result = [result substringToIndex:self.length - string.length];
        result = [result zh_removeLastSubString:string];
    }
    return result;
}
/// 移除所有子字符串
- (NSString *)zh_removeAllSubString:(NSString *)string{
    NSString *result = self;
    if ([result containsString:string]) {
        result = [result stringByReplacingOccurrencesOfString:string withString:@""];
    }
    return result;
}
/// 金钱显示
- (NSString *)zh_formatDecimalNumber:(NSString *)string {
    if (!string || string.length == 0) {
        return string;
    }
    NSNumber *number = @([string doubleValue]);
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    formatter.positiveFormat = @"###,##0.00";
    
    NSString *amountString = [formatter stringFromNumber:number];
    return amountString;
}

/// 去掉字符串中的数字
- (NSString *)zh_removeNumbers{
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [[self componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
}
/// 获取字符串中的数字
- (NSString *)zh_getNumbers{
    NSCharacterSet *nonDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [self stringByTrimmingCharactersInSet:nonDigits];
}

/// 每4位加一个空格
- (NSString *)zh_splitStringByPerFour{
    NSString *getString = @"";
    
    int a = (int)self.length/4;
    int b = (int)self.length%4;
    int c = a;
    if (b>0){
        c = a+1;
    }else{
        c = a;
    }
    for (int i = 0 ; i<c; i++){
        NSString *string = @"";
        if (i == (c-1)){
            if (b>0)
            {
                string = [self substringWithRange:NSMakeRange(4*(c-1), b)];
            }
            else
            {
                string = [self substringWithRange:NSMakeRange(4*i, 4)];
            }
        }
        else{
            string = [self substringWithRange:NSMakeRange(4*i, 4)];
        }
        getString = [NSString stringWithFormat:@"%@ %@",getString,string];
    }
    return getString;
}

+ (NSString *)zh_fileSizeToString:(unsigned long long)fileSize {
    NSInteger KB = 1024;
    NSInteger MB = pow(KB, 2);
    NSInteger GB = pow(KB, 3);
    
    if (fileSize < 10) {
        return @"0 B";
    }else if (fileSize < KB) {
        return [NSString stringWithFormat:@"%.1f B", (CGFloat)fileSize];
    }else if (fileSize < MB) {
        return [NSString stringWithFormat:@"%.1f KB", ((CGFloat)fileSize) / KB];
    }else if (fileSize < GB) {
        return [NSString stringWithFormat:@"%.1f MB", ((CGFloat)fileSize) / MB];
    }else {
        return [NSString stringWithFormat:@"%.1f GB", ((CGFloat)fileSize) / GB];
    }
}
/// 获取数据大小 单位：KB、MB、GB
/// @param data 数据
+ (NSString *)zh_fileSizeFromData:(NSData *)data{
    return [self zh_fileSizeToString:data.length];
}

@end
