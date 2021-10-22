//
//  ZhModel.m
//  GoodLife_New
//
//  Created by hshs on 2021/1/5.
//  Copyright © 2021 好生活. All rights reserved.
//

#import "ZhModel.h"
#import <MJExtension/MJExtension.h>

@implementation ZhModel

MJExtensionCodingImplementation

+(NSDictionary *)mj_objectClassInArray{
    return @{
             
             };
}
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"ID":@"id"
             };
}

/// 封装:通过字典来创建一个模型
+ (instancetype)zh_modelWithJSON:(id)json{
    return [self mj_objectWithKeyValues:json];
}

/// 封装:通过字典数组来创建一个模型数组
+ (NSMutableArray *)zh_modelArrayWithJsonArray:(id)jsonArray{
    NSError *error;
    return [self mj_objectArrayWithKeyValuesArray:jsonArray];
}

/// 封装:转换为JSON 字符串
- (NSString *)zh_JSONString{
    return [self mj_JSONString];
}

/// 转换为字典或者数组
- (id)zh_JSONObject{
    return [self mj_JSONObject];
}



@end
