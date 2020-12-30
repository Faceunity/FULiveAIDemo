//
//  FUExpresionView.m
//  FUAlgorithmDemo
//
//  Created by 孙慕 on 2020/8/4.
//  Copyright © 2020 孙慕. All rights reserved.
//

#import "FUExpresionView.h"

static NSString *gestureCellID = @"gestureCell";


@implementation FUExpresionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {

        _mImageV = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:_mImageV];
        
//        self.layer.cornerRadius = 2;
//        self.layer.masksToBounds = YES;
    }
    
    return self;
}
@end


@interface FUExpresionView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSArray<NSString *>* iamges;

@property(nonatomic,strong) NSIndexPath* selIndexPath;

@property(nonatomic,strong) NSArray *selArray;
@end

@implementation FUExpresionView

-(instancetype)initWithFrame:(CGRect)frame images:(NSArray<NSString *>*)iamges{
    if (self = [super initWithFrame:frame]) {
        _iamges = iamges;
        [self setupCollectionView];
        
        
        [self testAlpha0];
        
    }
    return self;
}

-(void)testAlpha1{
    [self layoutIfNeeded];
    UIColor *color1 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)  alpha:0.0];
    UIColor *color2 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)  alpha:1.0];
    UIColor *color3 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)  alpha:1.0];
    UIColor *color4 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)  alpha:0.0];
    NSArray *colors = [NSArray arrayWithObjects:(id)color1.CGColor, color2.CGColor,color3.CGColor,color4.CGColor, nil];
    NSArray *locations = [NSArray arrayWithObjects:@(0.0), @(0.08),@(0.92),@(1.0), nil];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = colors;
    gradientLayer.locations = locations;
    gradientLayer.frame = self.bounds;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint   = CGPointMake(0, 1);
    self.layer.mask = gradientLayer;
}

-(void)testAlpha2{
    [self layoutIfNeeded];
    UIColor *color1 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)  alpha:0.0];
    UIColor *color2 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)  alpha:1.0];
    UIColor *color3 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)  alpha:1.0];
    UIColor *color4 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)  alpha:0.0];
    NSArray *colors = [NSArray arrayWithObjects:(id)color1.CGColor, color2.CGColor,color3.CGColor,color4.CGColor, nil];
    NSArray *locations = [NSArray arrayWithObjects:@(0.0), @(0.08),@(1.0),@(1.0), nil];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = colors;
    gradientLayer.locations = locations;
    gradientLayer.frame = self.bounds;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint   = CGPointMake(0, 1);
    self.layer.mask = gradientLayer;
}

-(void)testAlpha0{
    [self layoutIfNeeded];
    UIColor *color1 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)  alpha:0.0];
    UIColor *color2 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)  alpha:1.0];
    UIColor *color3 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)  alpha:1.0];
    UIColor *color4 = [UIColor colorWithRed:(0)  green:(0)  blue:(0)  alpha:0.0];
    NSArray *colors = [NSArray arrayWithObjects:(id)color1.CGColor, color2.CGColor,color3.CGColor,color4.CGColor, nil];
    NSArray *locations = [NSArray arrayWithObjects:@(0.0), @(0.0),@(0.92),@(1.0), nil];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = colors;
    gradientLayer.locations = locations;
    gradientLayer.frame = self.bounds;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint   = CGPointMake(0, 1);
    self.layer.mask = gradientLayer;
}



-(void)setupCollectionView{
    // 设置 flowLayout
       UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
       flowLayout.minimumInteritemSpacing = 0;
       flowLayout.minimumLineSpacing = 0;
       flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
       flowLayout.itemSize = CGSizeMake(40, 40);
       flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
       
       // 添加 collectionView，记得要设置 delegate 和 dataSource 的代理对象
       _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
       _collectionView.layer.cornerRadius = 4;
      _collectionView.layer.masksToBounds = YES;
//    _collectionView.scrollEnabled = NO;
       _collectionView.delegate = self;
       _collectionView.dataSource = self;
      _collectionView.backgroundColor = [UIColor clearColor];
       _collectionView.bounces = NO;
       [self addSubview:_collectionView];
       
       // 注册 cell
       [_collectionView registerClass:[FUExpresionCell class] forCellWithReuseIdentifier:gestureCellID];
}


-(void)setExpresionViewSel:(int)selIndex {
    _selIndexPath = [NSIndexPath indexPathForRow:selIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:_selIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    [self.collectionView reloadData];
}


-(void)setExpresionViewSelArray:(NSArray *)array {
    _selArray = array;
    [self.collectionView reloadData];
//    if(array.count > 0){
//        NSInteger aa = [array[0] integerValue];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:aa  inSection:0];
//        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
//    }

    
}


#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _iamges.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FUExpresionCell *cell = (FUExpresionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:gestureCellID forIndexPath:indexPath];
    cell.mImageV.image = [UIImage imageNamed:_iamges[indexPath.row]];
    
    if([_selArray containsObject:[NSNumber numberWithInteger:indexPath.row]]){
        cell.mImageV.backgroundColor = [UIColor colorWithRed:108/255.0 green:82/255.0 blue:255/255.0 alpha:1.0];
    }else{
        cell.mImageV.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    }

    return cell;
}

static int aa = 0;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y != scrollView.contentSize.height - scrollView.bounds.size.height && scrollView.contentOffset.y > 0.0001 && aa != 1) {
        [self testAlpha1];
        aa = 1;
    }
    
    if (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.bounds.size.height  && aa != 2) {
        aa = 2;
        [self testAlpha2];
    }
    
    if (scrollView.contentOffset.y < 0.0001 && aa != 0) {
        aa = 0;
        [self testAlpha0];
    }
    
}



@end
