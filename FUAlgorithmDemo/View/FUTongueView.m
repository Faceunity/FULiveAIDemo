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

@property(nonatomic,strong) NSArray *selArray;

@property(nonatomic,assign) FUViewType current;
@end

@implementation FUTongueView

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *>*)mTitles{
    if (self = [super initWithFrame:frame]) {
        _mTitles = mTitles;
        [self setupTableView];
        _current = FUViewTypeTongue;
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
//    [_mTableView registerClass:[FUTongueViewCell class] forCellReuseIdentifier:tongueID];
    
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
    if (cell == nil) {
        cell = [[FUTongueViewCell alloc] initWithStyle: UITableViewCellStyleValue1
                                      reuseIdentifier: tongueID];
    }
    cell.textLabel.text = _mTitles[indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    cell.textLabel.font = [UIFont systemFontOfSize:11];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailTextLabel.text = @"";
    if ([_selArray containsObject:[NSNumber numberWithInteger:indexPath.row]]) {
        cell.backgroundColor = [UIColor colorWithRed:108/255.0 green:82/255.0 blue:255/255.0 alpha:1.0];
    }else{
        cell.backgroundColor = [UIColor clearColor];
    }
    
    if (_current == FUViewTypeEmotion && (indexPath.row == _mTitles.count - 1)) {
        cell.backgroundColor = [UIColor colorWithRed:17/255.0 green:18/255.0 blue:38/255.0 alpha:0.5];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
        cell.detailTextLabel.text = [_selArray containsObject:[NSNumber numberWithInteger:indexPath.row]] ? @"是":@"否";
    }
    
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 22;
}


-(void)setTongueViewSel:(int)selIndex{
    if (selIndex >= 0 || selIndex < _mTitles.count) {
        _selArray = [NSArray arrayWithObject:[NSNumber numberWithInt:selIndex]];
        [NSIndexPath indexPathForRow:selIndex inSection:0];
    }
    [_mTableView reloadData];
}

-(void)setViewSelArray:(NSArray <NSNumber *>*)array{
    _selArray = array;
    [self.mTableView reloadData];

}

-(void)setViewType:(FUViewType)type{
    _current = type;
    
    [self.mTableView reloadData];
}

@end
