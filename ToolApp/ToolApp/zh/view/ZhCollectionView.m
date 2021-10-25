//
//  ZhCollectionView.m
//  EasyLife
//
//  Created by hshs on 2021/1/23.
//  Copyright © 2021 Hopson. All rights reserved.
//

#import "ZhCollectionView.h"

@implementation ZhCollectionView


- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self config];
    }
    return self;
}

/// 统一配置
- (void)config{
    self.backgroundColor = kDefaultBackgrouncColor;
    
    if (@available(iOS 11,*)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        
    }
    
}

@end
