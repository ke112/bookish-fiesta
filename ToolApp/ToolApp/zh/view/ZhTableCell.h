//
//  BaseTableCell.h
//  GoodLife_New
//
//  Created by hshs on 2021/1/5.
//  Copyright © 2021 好生活. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZhTableCell : UITableViewCell

///子类去重写
- (void)setUI;


@end

NS_ASSUME_NONNULL_END
