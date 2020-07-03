//
//  FUConfigCell.m
//  FUAlgorithmDemo
//
//  Created by 孙慕 on 2020/5/21.
//  Copyright © 2020 孙慕. All rights reserved.
//

#import "FUConfigCell.h"

@implementation FUConfigCell

- (void)prepareForReuse {
    [super prepareForReuse];
//    self.num = @"";
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithRed:247/255.0 green:248/255.0 blue:250/255.0 alpha:1.0];
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorWithRed:100/255.0 green:103/255.0 blue:122/255.0 alpha:1.0];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.layer.cornerRadius = 4;
        _titleLabel.layer.masksToBounds = YES;
        _titleLabel.layer.borderColor = [UIColor colorWithRed:108/255.0 green:82/255.0 blue:255/255.0 alpha:1.0].CGColor;//边框颜色
        _titleLabel.layer.borderWidth = 1;//边框宽度
        [self.contentView addSubview:_titleLabel];
    }
    
    return self;
}

-(void)setState:(FUAICellState)state{
    _state = state;
    if (_state == FUAICellstateNol) {
        self.backgroundColor = [UIColor colorWithRed:247/255.0 green:248/255.0 blue:250/255.0 alpha:1.0];
        _titleLabel.textColor = [UIColor colorWithRed:100/255.0 green:103/255.0 blue:122/255.0 alpha:1.0];
        _titleLabel.layer.borderWidth = 0;//边框宽度
        _titleLabel.font = [UIFont systemFontOfSize:12];
    }else if(_state == FUAICellstateSel){
         _titleLabel.font = [UIFont boldSystemFontOfSize:12];
        self.backgroundColor = [UIColor colorWithRed:108/255.0 green:82/255.0 blue:255/255.0 alpha:0.09];
        _titleLabel.textColor = [UIColor colorWithRed:108/255.0 green:82/255.0 blue:255/255.0 alpha:1.0];
        _titleLabel.layer.borderWidth = 1;//边框宽度
    }else{
        _titleLabel.font = [UIFont systemFontOfSize:12];
        self.backgroundColor = [UIColor colorWithRed:247/255.0 green:248/255.0 blue:250/255.0 alpha:1.0];
        _titleLabel.layer.borderWidth = 0;//边框宽度
       _titleLabel.textColor = [UIColor colorWithRed:100/255.0 green:103/255.0 blue:122/255.0 alpha:0.32];
    }
}

-(void)setModel:(FUAIConfigCellModel *)model{
    _model = model;
    self.titleLabel.text = model.aiMenuTitel;
    self.state = model.state;
}


@end
