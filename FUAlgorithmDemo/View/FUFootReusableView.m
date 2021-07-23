//
//  FUFootReusableView.m
//  FUAlgorithmDemo
//
//  Created by 孙慕 on 2020/5/21.
//  Copyright © 2020 孙慕. All rights reserved.
//

#import "FUFootReusableView.h"

@interface FUFootReusableView()
@property(nonatomic,strong) UIView *bgView;

@property(nonatomic,strong) UIButton *titleBtn1;

@property(nonatomic,strong) UIButton *titleBtn2;
@end

@implementation FUFootReusableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        int w = frame.size.width;
        
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(6, 6, w - 12, 44)];
        self.bgView.backgroundColor = [UIColor colorWithRed:247/255.0 green:248/255.0 blue:250/255.0 alpha:1.0];
        self.bgView.layer.cornerRadius = 4;
        [self addSubview:self.bgView];
        
        self.titleBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(4, 4, (self.bgView.frame.size.width -8)/2, self.bgView.frame.size.height -8)];
        [self.titleBtn1 addTarget:self action:@selector(btn1click:) forControlEvents:UIControlEventTouchUpInside];
        self.titleBtn1.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleBtn1.layer.cornerRadius = 4;
        [self.bgView addSubview:self.titleBtn1];
        
        self.titleBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(4+self.titleBtn1.frame.size.width, 4, (self.bgView.frame.size.width -8)/2, self.bgView.frame.size.height -8)];
        self.titleBtn2.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleBtn2.layer.cornerRadius = 4;
        [self.titleBtn2 addTarget:self action:@selector(btn2click:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:self.titleBtn2];
        
    }
    
    return self;
}

-(void)setSelBtn:(UIButton *)btn{
    if (btn == self.titleBtn1) {
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:[UIColor colorWithRed:108/255.0 green:82/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        _titleBtn2.backgroundColor = [UIColor clearColor];
        [_titleBtn2 setTitleColor:[UIColor colorWithRed:100/255.0 green:103/255.0 blue:122/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    
    if (btn == self.titleBtn2) {
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:[UIColor colorWithRed:108/255.0 green:82/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        _titleBtn1.backgroundColor = [UIColor clearColor];
        [_titleBtn1 setTitleColor:[UIColor colorWithRed:100/255.0 green:103/255.0 blue:122/255.0 alpha:1.0] forState:UIControlStateNormal];

    }
    
}
#pragma  mark -  action

-(void)btn1click:(UIButton *)btn{
    [self setSelBtn:btn];
    _model.footSelInde = 0;
}

-(void)btn2click:(UIButton *)btn{
    [self setSelBtn:btn];
    _model.footSelInde = 1;
}


-(void)setModel:(FUAIConfigCellModel *)model{
    _model = model;
    [self.titleBtn1 setTitle:model.subFootes[0] forState:UIControlStateNormal];
    
    [self.titleBtn2 setTitle:model.subFootes[1] forState:UIControlStateNormal];
    
    if (_model.footSelInde == 0) {
        [self btn1click:self.titleBtn1];
    }
    if (_model.footSelInde == 1) {
        [self btn2click:self.titleBtn2];
    }
}




@end
