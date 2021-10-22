//
//  NSObject+DebugDescription.h
//
//
//  Created by zhangzhihua on 2021/7/20.
//
//  自动打印model的所有属性

#import "NSObject+DebugDescription.h"
#import <objc/runtime.h>

@implementation NSObject (DebugDescription)

/// 重写model的debugDescription
- (NSString *)debugDescription{
    if ([self isKindOfClass:[NSArray class]] || [self isKindOfClass:[NSDictionary class]] || [self isKindOfClass:[NSNumber class]] || [self isKindOfClass:[NSString class]]) {
        return self.debugDescription;
    }
    //初始化一个字典
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    //得到当前class的所有属性
    uint count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    //循环并用KVC得到每个属性的值
    for (int i = 0; i<count; i++) {
        objc_property_t property = properties[i];
        NSString *name = @(property_getName(property));
        id value = [self valueForKey:name]?:@"nil";//默认值为nil字符串
        [dictionary setObject:value forKey:name];//装载到字典里
    }
    //释放
    free(properties);
    //return
    return [NSString stringWithFormat:@"<%@: %p> -- %@",[self class],self,[self dic_description:dictionary]];
}

- (NSString*)dic_description:(NSDictionary *)dic{
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSString *desc = [dic description];
        desc = [NSString stringWithCString:[desc cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
        return desc;
    }
    return [dic debugDescription];
}



@end
