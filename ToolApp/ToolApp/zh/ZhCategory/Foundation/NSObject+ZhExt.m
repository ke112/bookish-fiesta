//
//  NSObject+ZhExt.m
//  ToolApp
//
//  Created by zhangzhihua on 2021/9/29.
//

#import "NSObject+ZhExt.h"
#import <MJExtension/MJExtension.h>

@implementation NSObject (ZhExt)


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


/// 将模型数组转化成一个新的模型数组
+ (NSMutableArray *)zh_trsnsformModelsArr:(NSMutableArray *)origialModels{
    NSMutableArray *newModels = [NSMutableArray array];
    for (NSObject *model in origialModels) {
        [newModels addObject:[self mj_objectWithKeyValues:[model mj_JSONString]]];
    }
    return newModels;
}

@end
