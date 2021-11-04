//
//  BaseTableCell.m
//  GoodLife_New
//
//  Created by hshs on 2021/1/5.
//  Copyright © 2021 好生活. All rights reserved.
//

#import "ZhTableCell.h"
#import "UIView+ZhExt.h"

@interface ZhTableCell ()

@end

@implementation ZhTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setUITableViewConfig];
    [self setUI];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUITableViewConfig];
        [self setUI];
    }
    return self;
}
- (void)setUITableViewConfig{
    self.contentView.backgroundColor = kDefaultBackgrouncColor;
}



@end
