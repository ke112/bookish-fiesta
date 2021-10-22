//
//  NSString+ZhExt.h
//  OriginalPro
//
//  Created by ZhangZhihua on 2019/1/23.
//  Copyright © 2019 ZhangZhihua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ZhExt)

/// 判断是否是空串
+ (BOOL)zh_isEmptyString:(nullable NSString *)str;

/// 验证字符串是否是有效【邮箱】
- (BOOL)zh_isValidateEmail;

/// 验证字符串是否是有效【手机号码】
- (BOOL)zh_isValidateMobile;

/// 验证字符串是否是有效【身份证】
- (BOOL)zh_isValidateIDCard;

/// 验证字符串是否是有效【银行卡】
- (BOOL)zh_isValidateBankCard;

/// 判断是否是纯数字
- (BOOL)zh_isPureNum;

/// 由字母或数字组成 6-18位密码字符串（正则）
- (BOOL)zh_isValidatePassword;

/// 判断一个字符串是否包含数字
- (BOOL)zh_isStringContainNumber;

/// 判断一个字符串是否包含字母
- (BOOL)zh_isStringContainZimu;

/// 判断字符串是否只包含数字和字母
- (BOOL)zh_isContainsOnlyNumbersAndLetters;

/// 去掉字符串中的数字
- (NSString *)zh_removeNumbers;

/// 获取字符串中的数字
- (NSString *)zh_getNumbers;

/// 截取字符串（字符串都是从第0个字符开始数的哦~）
- (NSString*)zh_getSubstringFrom:(NSInteger)begin to:(NSInteger)end;

/// 新字符串替换老字符串
- (NSString *)zh_replaceCharcter:(NSString *)olderChar withCharcter:(NSString *)newerChar;

/// 格式化HTML代码
- (NSString *)zh_htmlEntityDecode;

/** 字符串倒序排列 */
- (NSString *)zh_stringInversion;

/// md5加密
- (NSString *)zh_MD5;

/// md5加密
+ (NSString *)zh_MD5String:(NSString *)str;

/// 将中文转换成UTF8编码格式
- (NSString *)zh_utf8_Encoding;

/// 将UTF8编码格式转换成中文
- (NSString *)zh_utf8_DEcoding;

/// 将中文转换成base64编码格式
- (NSString *)zh_base64_Encode;

/// 将base64编码格式转换成中文
- (NSString *)zh_base64_Decode;

/// 字符串转Data
- (NSData *)zh_utf8_Data;

/// 计算字符串高度
- (CGFloat)zh_heightForStringWithFontSize:(CGFloat)fontSize withWidthOfContent:(CGFloat)contentMaxWidth;

/// 计算字符串高度
- (CGFloat)zh_heightForStringWithFont:(UIFont *)font withWidthOfContent:(CGFloat)contentMaxWidth;

/// 计算内容文本的高度方法 可设置行高
- (CGFloat)zh_heightForStringWithFont:(UIFont *)font withWidthOfContent:(CGFloat)contentMaxWidth lineSpacing:(CGFloat)lineSpacing;

/// 计算字符串宽度度
- (CGFloat)zh_widthForStringWithFontSize:(CGFloat)fontSize;
/// 计算字符串宽度度
- (CGFloat)zh_widthForStringWithFont:(UIFont *)font;

/// 获取这个字符串中的所有要找的字符串的所在的下标
- (NSMutableArray *)zh_getRangeByFindText:(NSString *)findText;

/// 移除结尾的子字符串(会移除多个相同的)
- (NSString *)zh_removeLastSubString:(NSString *)string;

/// 移除所有子字符串
- (NSString *)zh_removeAllSubString:(NSString *)string;

/// 生成随机字符串
+ (NSString *)zh_randomStringWithLength:(NSInteger)len;

/// 移除字符串前后的空格
- (NSString *)zh_removeSpacesBeforeAndAfter;

/// 移除所有的空格
- (NSString*)zh_removeAllSpace;

/// 金钱显示
- (NSString *)zh_formatDecimalNumber:(NSString *)string;

/// 去掉字符串中的数字
- (NSString *)zh_removeNumber;

/// 获取字符串中的数字
- (NSString *)zh_getNumber;

/// 每4位加一个空格
- (NSString *)zh_splitStringByPerFour;

/// 获取数据大小 单位：KB、MB、GB
/// @param fileSize 文件字节大小,单位：字节(B)
+ (NSString *)zh_fileSizeToString:(unsigned long long)fileSize;

/// 获取数据大小 单位：KB、MB、GB
/// @param data 数据
+ (NSString *)zh_fileSizeFromData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
