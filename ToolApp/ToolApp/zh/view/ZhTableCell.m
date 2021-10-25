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
    self.contentView.backgroundColor = kDefaultBackgrouncColor;
    [self setUI];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = kDefaultBackgrouncColor;
        [self setUI];
    }
    return self;
}
///子类去重写
- (void)setUI{
    
}
///子类去重写
- (void)clearClick{
    
}
///添加顶部分割线(常用)
- (void)addTopLine{
    [self.contentView addSubview:self.topLineView];
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(0.5);
        make.left.right.top.mas_offset(0);
    }];
}
///添加底部分割线
- (void)addBottomLine{
    [self.contentView addSubview:self.bottomLineView];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(0.5);
        make.left.right.bottom.mas_offset(0);
    }];
}
///清空顶部底部分割线
- (void)clearTopBottomLine{
    [self.topLineView removeFromSuperview];
    [self.bottomLineView removeFromSuperview];
}


///添加右侧箭头
- (void)addRightArrow{
    [self.contentView addSubview:self.arrowRightImg];
    [self.arrowRightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-12);
        make.centerY.mas_equalTo(self.contentView).mas_offset(0);
    }];
    self.arrowRightImg.hidden = NO;
}
///移除右侧箭头
- (void)removeRightArrow{
    self.arrowRightImg.hidden = YES;
}

- (UIView *)whiteShadowBgView{
    if (_whiteShadowBgView == nil) {
        _whiteShadowBgView = [[UIView alloc]init];
        _whiteShadowBgView.backgroundColor = kColorWithHex(@"0x2A2D45");
        [_whiteShadowBgView setZh_CornerRadius:10];
        [_whiteShadowBgView zh_setShadowColor];
    }
    return _whiteShadowBgView;
}
- (UIView *)topLineView{
    if (_topLineView == nil) {
        _topLineView = [[UIView alloc]init];
        _topLineView.backgroundColor = kColorWithHex(@"0xe5e5e5");;
    }
    return _topLineView;
}
- (UIView *)bottomLineView{
    if (_bottomLineView == nil) {
        _bottomLineView = [[UIView alloc]init];
        _bottomLineView.backgroundColor = kColorWithHex(@"0xe5e5e5");;
    }
    return _bottomLineView;
}
- (UIImageView *)arrowRightImg{
    if (_arrowRightImg == nil) {
        _arrowRightImg = [[UIImageView alloc]init];
        _arrowRightImg.image = [UIImage imageNamed:@"rightArrow8*14"];
    }
    return _arrowRightImg;
}
- (UIButton *)clearBtn{
    if (_clearBtn == nil) {
        _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _clearBtn.backgroundColor = [UIColor clearColor];
        [_clearBtn addTarget:self action:@selector(clearClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearBtn;
}
- (UIImageView *)iconImg{
    if (_iconImg == nil) {
        _iconImg = [[UIImageView alloc]init];
        _iconImg.backgroundColor = [UIColor whiteColor];
        _iconImg.contentMode = UIViewContentModeScaleAspectFill;
        _iconImg.clipsToBounds = YES;
        _iconImg.image = [UIImage imageNamed:@"defaultUserIcon"];
    }
    return _iconImg;
}
- (UILabel *)titleLb{
    if (_titleLb == nil) {
        _titleLb = [[UILabel alloc]init];
        _titleLb.textColor = kColorWithHex(@"0x2C2C2C");
        _titleLb.font = [UIFont systemFontOfSize:15];
        _titleLb.numberOfLines = 0;
    }
    return _titleLb;
}
- (UILabel *)contentLb{
    if (_contentLb == nil) {
        _contentLb = [[UILabel alloc]init];
        _contentLb.textColor = kColorWithHex(@"0x6D6D6D");
        _contentLb.font = [UIFont systemFontOfSize:14];
        _contentLb.numberOfLines = 0;
    }
    return _contentLb;
}

@end
