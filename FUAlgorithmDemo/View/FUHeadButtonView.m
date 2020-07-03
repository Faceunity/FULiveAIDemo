//
//  FUHeadButtonView.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/1/29.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUHeadButtonView.h"
#import <Masonry.h>


@implementation FUHeadButtonView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSubView];
        [self addLayoutConstraint];
    }
    
    return self;
}

-(void)setupSubView{
    _mHomeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_mHomeBtn setImage:[UIImage imageNamed:@"home icon"] forState:UIControlStateNormal];
    [_mHomeBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_mHomeBtn];
    
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_moreBtn setImage:[UIImage imageNamed:@"demo_nav_icon_configuration"] forState:UIControlStateNormal];
    [_moreBtn addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_moreBtn];
    
    _bulyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bulyBtn setImage:[UIImage imageNamed:@"bugly"] forState:UIControlStateNormal];
    [_bulyBtn addTarget:self action:@selector(buglyAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_bulyBtn];
    
    _switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_switchBtn setImage:[UIImage imageNamed:@"camera_btn_shotcut_normal"] forState:UIControlStateNormal];
    [_switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_switchBtn];
    
}

-(void)addLayoutConstraint{
    int length = ([UIScreen mainScreen].bounds.size.width -2*(10 + 44))/3;
    
    [_mHomeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(10);
        make.height.width.mas_equalTo(44);
    
    }];
    
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self.mHomeBtn);
        make.height.width.mas_equalTo(44);
        
    }];
    
    
    [_switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moreBtn).offset(-length);
        make.centerY.equalTo(self.mHomeBtn);
        make.height.width.mas_equalTo(44);
        
    }];
    
    [_bulyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mHomeBtn.mas_left).offset(length);
        make.centerY.equalTo(self.mHomeBtn);
        make.height.width.mas_equalTo(44);
        
    }];
    

}


#pragma  mark -  UI 交互
-(void)backAction:(UIButton *)btn{
    if ([_delegate respondsToSelector:@selector(headButtonViewBackAction:)]) {
        [_delegate headButtonViewBackAction:btn];
    }
}

-(void)moreAction:(UIButton *)btn{
    if ([_delegate respondsToSelector:@selector(headButtonViewMoreAction:)]) {
        [_delegate headButtonViewMoreAction:btn];
    }
}

-(void)buglyAction:(UIButton *)btn{
    if ([_delegate respondsToSelector:@selector(headButtonViewBuglyAction:)]) {
        [_delegate headButtonViewBuglyAction:btn];
    }
}

-(void)switchAction:(UIButton *)btn{
    if ([_delegate respondsToSelector:@selector(headButtonViewSwitchAction:)]) {
        [_delegate headButtonViewSwitchAction:btn];
    }
}





@end
