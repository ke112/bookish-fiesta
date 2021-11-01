//
//  ZhCollectionViewCell.m
//  EasyLife
//
//  Created by hshs on 2021/1/23.
//  Copyright © 2021 Hopson. All rights reserved.
//

#import "ZhCollectionViewCell.h"

@implementation ZhCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setCollectionConfig];
    [self setUI];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setCollectionConfig];
        [self setUI];
    }
    return self;
}

- (void)setCollectionConfig{
    self.contentView.backgroundColor = kDefaultBackgrouncColor;
}

@end
