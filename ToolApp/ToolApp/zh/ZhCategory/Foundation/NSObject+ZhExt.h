//
//  NSObject+ZhExt.h
//  ToolApp
//
//  Created by zhangzhihua on 2021/9/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ZhExt)


#pragma mark ====== 解析 ======
/// 封装:通过字典来创建一个模型
+ (instancetype)zh_modelWithJSON:(id)json;

/// 封装:通过字典数组来创建一个模型数组
+ (NSMutableArray *)zh_modelArrayWithJsonArray:(id)jsonArray;

/// 封装:转换为JSON 字符串
- (NSString *)zh_JSONString;

/// 转换为字典或者数组
- (id)zh_JSONObject;

/// 将模型数组转化成一个新的模型数组
+ (NSMutableArray *)zh_trsnsformModelsArr:(NSMutableArray *)origialModels;


@end

NS_ASSUME_NONNULL_END
