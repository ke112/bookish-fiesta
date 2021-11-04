//
//  ZhScrollView.m
//  GoodLife_New
//
//  Created by hshs on 2021/1/5.
//  Copyright © 2021 好生活. All rights reserved.
//

#import "ZhScrollView.h"

@implementation ZhScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.alwaysBounceVertical = YES;
        self.backgroundColor = kDefaultBackgrouncColor;
        self.contentView.backgroundColor = kDefaultBackgrouncColor;
        self.userInteractionEnabled = YES;
        self.contentView.userInteractionEnabled = YES;
        
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
            make.width.equalTo(self);
        }];
        
        [self setUI];
//        [self addGesture];
    }
    return self;
}

-(void)addGesture{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [self addGestureRecognizer:tapGesture];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.cancelsTouchesInView = NO;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self endEditing:YES];
}

-(void)tapGesture:(UITapGestureRecognizer*)gesture{
    [self endEditing:YES];
}


- (void)setBgColor:(UIColor *)bgColor{
    _bgColor = bgColor;
    self.backgroundColor = bgColor;
    self.contentView.backgroundColor = bgColor;
}

- (UIView *)contentView{
    if (_contentView == nil) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}


@end
