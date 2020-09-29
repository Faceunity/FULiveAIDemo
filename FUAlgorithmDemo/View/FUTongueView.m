//
//  FUTongueView.m
//  FUAlgorithmDemo
//
//  Created by 孙慕 on 2020/8/4.
//  Copyright © 2020 孙慕. All rights reserved.
//

#import "FUTongueView.h"

static NSString *tongueID = @"tongueID";

@implementation FUTongueViewCell

@end

@interface FUTongueView()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *mTableView;
@property(nonatomic,strong)NSArray<NSString *>* mTitles;

@property(nonatomic,strong) NSIndexPath* selIndexPath;

@end

@implementation FUTongueView

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *>*)mTitles{
    if (self = [super initWithFrame:frame]) {
        _mTitles = mTitles;
        [self setupTableView];
    }
    return self;
}

-(void)setupTableView{
    _mTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    _mTableView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _mTableView.layer.cornerRadius = 4;
    _mTableView.layer.masksToBounds = YES;
    _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mTableView.scrollEnabled = NO;
    [_mTableView registerClass:[FUTongueViewCell class] forCellReuseIdentifier:tongueID];
    
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    
    [self addSubview:_mTableView];
    
}


#pragma  mark -  tebleViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _mTitles.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FUTongueViewCell *cell = (FUTongueViewCell *)[tableView dequeueReusableCellWithIdentifier:tongueID];
    cell.textLabel.text = _mTitles[indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    cell.textLabel.font = [UIFont systemFontOfSize:11];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.selIndexPath.row == indexPath.row && self.selIndexPath.section == indexPath.section && self.selIndexPath) {
        cell.backgroundColor = [UIColor colorWithRed:108/255.0 green:82/255.0 blue:255/255.0 alpha:1.0];
    }else{
        cell.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 22;
}


-(void)setTongueViewSel:(int)selIndex{
    if (selIndex >= 0 || selIndex < _mTitles.count) {
        _selIndexPath = [NSIndexPath indexPathForRow:selIndex inSection:0];
    }else{
        _selIndexPath = nil;
    }
    
    [_mTableView reloadData];
}


@end
