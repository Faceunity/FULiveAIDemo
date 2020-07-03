//
//  FUGestureView.m
//  FUAlgorithmDemo
//
//  Created by 孙慕 on 2020/5/25.
//  Copyright © 2020 孙慕. All rights reserved.
//

#import "FUGestureView.h"

static NSString *gestureCellID = @"gestureCell";


@implementation FUGestureCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {

        _mImageV = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:_mImageV];
        
        self.layer.cornerRadius = 2;
        self.layer.masksToBounds = YES;
    }
    
    return self;
}
@end


@interface FUGestureView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSArray<NSArray<NSString *>*>* iamges;

@property(nonatomic,strong) NSIndexPath* selIndexPath;
@end

@implementation FUGestureView

-(instancetype)initWithFrame:(CGRect)frame images:(NSArray<NSArray<NSString *>*>*)iamges{
    if (self = [super initWithFrame:frame]) {
        _iamges = iamges;
        [self setupCollectionView];
    }
    return self;
}

-(void)setupCollectionView{
    // 设置 flowLayout
       UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
       flowLayout.minimumInteritemSpacing = 3.5;
       flowLayout.minimumLineSpacing = 3.5;
       flowLayout.sectionInset = UIEdgeInsetsMake(3.5, 0, 0, 0);
       flowLayout.itemSize = CGSizeMake(40, 40);
       

       // 添加 collectionView，记得要设置 delegate 和 dataSource 的代理对象
       _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
       _collectionView.delegate = self;
       _collectionView.dataSource = self;
      _collectionView.backgroundColor = [UIColor clearColor];
       [self addSubview:_collectionView];
       
       // 注册 cell
       [_collectionView registerClass:[FUGestureCell class] forCellWithReuseIdentifier:gestureCellID];
}


-(void)setGestureViewSel:(int)selIndex {
//    if(selIndex < 0) _selIndexPath = nil;
    if(selIndex >= _iamges[0].count){
        _selIndexPath = [NSIndexPath indexPathForRow:selIndex - _iamges[0].count inSection:1];
    }else{
        _selIndexPath = [NSIndexPath indexPathForRow:selIndex inSection:0];
    }
    [self.collectionView reloadData];

}



#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _iamges.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _iamges[section].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FUGestureCell *cell = (FUGestureCell *)[collectionView dequeueReusableCellWithReuseIdentifier:gestureCellID forIndexPath:indexPath];
    cell.mImageV.image = [UIImage imageNamed:_iamges[indexPath.section][indexPath.row]];
    if (self.selIndexPath.row == indexPath.row && self.selIndexPath.section == indexPath.section) {
        cell.mImageV.backgroundColor = [UIColor colorWithRed:108/255.0 green:82/255.0 blue:255/255.0 alpha:1.0];
    }else{
        cell.mImageV.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:77/255.0 alpha:1.0];
    }
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(40, 40);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(3.5, 10, 0, 10);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 3.5;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 3.5;
}

 


@end
