//
//  FUConfigController.m
//  FUAlgorithmDemo
//
//  Created by 孙慕 on 2020/5/21.
//  Copyright © 2020 孙慕. All rights reserved.
//

#import "FUConfigController.h"
#import "FUConfigCell.h"
#import "FUHeadReusableView.h"
#import "FUFootReusableView.h"
#import "MJExtension.h"
#import "FUManager.h"
#import "UIViewController+CWLateralSlide.h"

@interface FUConfigController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *collectionView;


@end
#define sw [UIScreen mainScreen].bounds.size.width

NSString *const FUConfigControllerUpdateNotification = @"FUConfigControllerNotification";

@implementation FUConfigController

static NSString *cellID = @"Cell";
static NSString *headerViewID = @"MGHeaderView";
static NSString *footViewID = @"footView";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self setupCollectionView];
    [self subView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:)name:UIApplicationBackgroundRefreshStatusDidChangeNotification object:nil];
    
    

    for (FUAISectionModel*config in self.config) {
        [[FUManager shareManager] loadBoudleWithConfig:config];//创建所有用到道具
    }
}

-(void)subView{
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(16,52,200,20);
    label.numberOfLines = 0;
    [self.view addSubview:label];
    label.text = @"人体AI技术";
    label.textColor = [UIColor colorWithRed:28/255.0 green:24/255.0 blue:46/255.0 alpha:1.0];
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentLeft;
    label.alpha = 1.0;
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0,88,sw,1/[UIScreen mainScreen].scale);
    view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    [self.view addSubview:view];
    
    UIButton *restBtn = [[UIButton alloc] init];
    restBtn.frame = CGRectMake(16,[UIScreen mainScreen].bounds.size.height - 40 - 34 ,96,40);

    restBtn.layer.backgroundColor = [UIColor colorWithRed:247/255.0 green:248/255.0 blue:250/255.0 alpha:1.0].CGColor;
    [restBtn addTarget:self action:@selector(restBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    restBtn.layer.cornerRadius = 4;
    [restBtn setTitle:@"重置" forState:UIControlStateNormal];
    restBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [restBtn setTitleColor:[UIColor colorWithRed:100/255.0 green:103/255.0 blue:122/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.view addSubview:restBtn];
    
    UIButton *donBtn = [[UIButton alloc] init];
    donBtn.frame = CGRectMake(CGRectGetMaxX(restBtn.frame) + 4,[UIScreen mainScreen].bounds.size.height - 40 - 34 ,self.collectionView.frame.size.width - CGRectGetMaxX(restBtn.frame) - 16 - 8,40);;
     [donBtn addTarget:self action:@selector(donBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    donBtn.layer.backgroundColor = [UIColor colorWithRed:108/255.0 green:82/255.0 blue:255/255.0 alpha:1.0].CGColor;
    donBtn.layer.cornerRadius = 4;
    [donBtn setTitle:@"确定" forState:UIControlStateNormal];
    [donBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    donBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:donBtn];
}


-(void)setupCollectionView{
    // 设置 flowLayout
       UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
       flowLayout.minimumInteritemSpacing = 16;
       flowLayout.minimumLineSpacing = 8;
       flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
       flowLayout.itemSize = CGSizeMake(80, 50);
       

       // 添加 collectionView，记得要设置 delegate 和 dataSource 的代理对象
       CGRect frame = self.view.frame;
       frame.size.width = frame.size.width * 0.75;
       frame.origin.y = 89;
       _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
       _collectionView.delegate = self;
       _collectionView.dataSource = self;
      _collectionView.backgroundColor = [UIColor whiteColor];
       [self.view addSubview:_collectionView];
       
       // 注册 cell
       [_collectionView registerClass:[FUConfigCell class] forCellWithReuseIdentifier:cellID];
       [self.collectionView registerClass:[FUHeadReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID];
        [self.collectionView registerClass:[FUFootReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footViewID];
}


#pragma  mark -  action
-(void)restBtnClick:(UIButton *)btn{
    for (FUAISectionModel *config in _config) {
            for(int i = 0;i < config.aiMenu.count;i ++){
            FUAIConfigCellModel *model = config.aiMenu[i];
            model.state = FUAICellstateNol;
                model.footSelInde = 0;
        }
    }
    [_collectionView reloadData];
    
    /* 确认修改，同步数据 */
    [FUManager shareManager].config = self.config;
    [[FUManager shareManager] setNeedRenderHandle];
    
    NSNotification *notification  = [NSNotification notificationWithName:FUConfigControllerUpdateNotification object:nil userInfo:nil];
     [[NSNotificationCenter defaultCenter] postNotification:notification];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)donBtnClick:(UIButton *)btn{
    [FUManager shareManager].config = self.config;
    [[FUManager shareManager] setNeedRenderHandle];
    NSNotification *notification  = [NSNotification notificationWithName:FUConfigControllerUpdateNotification object:nil userInfo:nil];
     [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _config.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _config[section].aiMenu.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FUConfigCell *cell = (FUConfigCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    FUAIConfigCellModel *model = _config[indexPath.section].aiMenu[indexPath.row];
    cell.model = model;
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 32);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}


//通过设置SupplementaryViewOfKind 来设置头部或者底部的view，其中 ReuseIdentifier 的值必须和 注册是填写的一致，本例都为 “reusableView”
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{

    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
    FUHeadReusableView *headerView= (FUHeadReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID forIndexPath:indexPath];
        FUAISectionModel *model = _config[indexPath.section];
        headerView.titleLabel.text = model.sectionTitel;
        headerView.mImageView.image = [UIImage imageNamed:model.sectionImageName];
    return headerView;
    }
    
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
    FUFootReusableView *fView= (FUFootReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footViewID forIndexPath:indexPath];
        
        int selIndex = [self isShowFootView:indexPath.section];
        if (_config[indexPath.section].aiMenu[selIndex]) {
            fView.model = _config[indexPath.section].aiMenu[selIndex];
        }
        fView.userInteractionEnabled = YES;
    
    return fView;
    }
    return nil;

}


// 设置Header的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
 CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
 return CGSizeMake(screenWidth, 44);
}
 
// 设置Footer的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if ([self isShowFootView:section] >= 0){
        CGFloat screenWidth = collectionView.bounds.size.width;
        return CGSizeMake(screenWidth, 50);
    }
 return CGSizeMake(0, 0);
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FUAIConfigCellModel *modle =  _config[indexPath.section].aiMenu[indexPath.row];
    if (modle.state == FUAICellstateDisable) {
        return;
    }

    FUConfigCell *cell = (FUConfigCell *)[collectionView cellForItemAtIndexPath:indexPath];
    modle.state = modle.state?0:1;
    
    if (modle.aiType == FUNamaAITypegestureRecognition || modle.aiType == FUNamaAITypeBodySkeleton ||modle.aiType == FUNamaAITypePortraitSegmentation || modle.aiType == FUNamaAITypeHairSplit || modle.aiType == FUNamaAITypeHeadSplit) {//单选
        if (modle.state == FUAICellstateSel) {
            [self changeEnableOther:modle state:FUAICellstateDisable];
        }else{
            [self changeEnableOther:modle state:FUAICellstateNol];
        }
        
    }
    if (modle.aiType == FUNamaAITypeBodyDetection || modle.aiType == FUNamaAITypeBodyKeyPoints || modle.aiType == FUNamaAITypeActionRecognition) {
        [self disEnableOne];
    }

    [collectionView reloadData];
}


-(int)isShowFootView:(NSInteger)section{
    FUAISectionModel *config =  _config[section];
    
    for(int i = 0;i < config.aiMenu.count;i ++){
        FUAIConfigCellModel *model = config.aiMenu[i];
        if (model.state == FUAICellstateSel && model.subFootes > 0) {
            return i;
        }
    }
    return  -1;
    
}


-(void)changeEnableOther:(FUAIConfigCellModel *)currentModle state:(FUAICellState)state{
    
    for (FUAISectionModel *config in _config) {
            for(int i = 0;i < config.aiMenu.count;i ++){

            FUAIConfigCellModel *model = config.aiMenu[i];
            if (currentModle == model) {
                continue;
            }
            model.state = state;
        }

    }
}

-(void)disEnableOne{//隐藏单选
    BOOL isHave = NO;
    for (FUAISectionModel *config in _config) {
            for(int i = 0;i < config.aiMenu.count;i ++){
            FUAIConfigCellModel *modle = config.aiMenu[i];
                if (modle.aiType == FUNamaAITypeBodyDetection || modle.aiType == FUNamaAITypeBodyKeyPoints || modle.aiType == FUNamaAITypeActionRecognition) {
                    if (modle.state == FUAICellstateSel) {//置灰其他单选项目
                        isHave = YES;
                        break;
                    }
                }

            }
        }

    for (FUAISectionModel *config in _config) {
            for(int i = 0;i < config.aiMenu.count;i ++){
            FUAIConfigCellModel *modle = config.aiMenu[i];
            if (modle.aiType == FUNamaAITypegestureRecognition || modle.aiType == FUNamaAITypeBodySkeleton ||modle.aiType == FUNamaAITypePortraitSegmentation || modle.aiType == FUNamaAITypeHairSplit || modle.aiType == FUNamaAITypeHeadSplit) {
                if (isHave) {
                    modle.state = FUAICellstateDisable;
                }else{
                    modle.state = FUAICellstateNol;
                }
                
            }
        }

    }
}



@end
