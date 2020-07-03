//
//  FUHeadReusableView.m
//  FUAlgorithmDemo
//
//  Created by 孙慕 on 2020/5/21.
//  Copyright © 2020 孙慕. All rights reserved.
//

#import "FUHeadReusableView.h"

@implementation FUHeadReusableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        int h = frame.size.height;
        _mImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16,(h -16)/2, 16, 16)];
        _mImageView.image = [UIImage imageNamed:@"camera_btn_shotcut_normal"];
        [self addSubview:_mImageView];
        
//        self.backgroundColor = [UIColor colorWithRed:247/255.0 green:248/255.0 blue:250/255.0 alpha:1.0];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_mImageView.frame)+8, (h -32)/2, 84, 32)];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor colorWithRed:28/255.0 green:24/255.0 blue:46/255.0 alpha:1.0];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_titleLabel];
    }
    
    return self;
}

@end
