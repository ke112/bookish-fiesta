//
//  ZhModel.h
//  GoodLife_New
//
//  Created by hshs on 2021/1/5.
//  Copyright © 2021 好生活. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZhModel : NSObject

#pragma mark ====== 解析 ======
/// 封装:通过字典来创建一个模型
+ (instancetype)zh_modelWithJSON:(id)json;

/// 封装:通过字典数组来创建一个模型数组
//+ (NSMutableArray *)zh_modelArrayWithJsonArray:(id)jsonArray;

/// 封装:转换为JSON 字符串
- (NSString *)zh_JSONString;

/// 转换为字典或者数组
- (id)zh_JSONObject;



@end

NS_ASSUME_NONNULL_END
