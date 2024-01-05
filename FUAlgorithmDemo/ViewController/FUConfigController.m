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

#import "FUManager.h"
#import "FUMacros.h"

#import "UIViewController+CWLateralSlide.h"

#import <SVProgressHUD.h>
#import <MJExtension.h>

@interface FUConfigController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation FUConfigController

static NSString *cellID = @"Cell";
static NSString *headerViewID = @"MGHeaderView";
static NSString *footViewID = @"footView";

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self subView];
}

#pragma mark - UI

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
    view.frame = CGRectMake(0,88, FUScreenWidth, 1/[UIScreen mainScreen].scale);
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

- (void)showMessage:(NSString *)string{
    [SVProgressHUD showImage:[UIImage imageNamed:@"wrt424erte2342rx"] status:string];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.74]];
    [SVProgressHUD setBackgroundLayerColor:[UIColor clearColor]];
    [SVProgressHUD setCornerRadius:5];
    [SVProgressHUD dismissWithDelay:1.5];
}


#pragma mark - Private methods

-(int)isShowFootView:(NSInteger)section{
    FUAISectionModel *config =  self.configDataSource[section];
    for(int i = 0;i < config.aiMenu.count;i ++){
        FUAIConfigCellModel *model = config.aiMenu[i];
        if (model.state == FUAICellStateSel && model.subFootes > 0) {
            return i;
        }
    }
    return  -1;
}

/// 选中某项后其他可选类型
- (NSArray *)otherCanEnable:(FUNamaAIType)aitype{
    switch (aitype) {
        case FUNamaAITypeKeypoint:
        case FUNamaAITypeTongue:
        case FUNamaAITypeExpressionRecognition:
        case FUNamaAITypeEmotionRecognition:
        case FUNamaAITypeARMesh:
            return @[@(FUNamaAITypeKeypoint),@(FUNamaAITypeTongue),@(FUNamaAITypeExpressionRecognition),@(FUNamaAITypeBodyKeypoint), @(FUNamaAITypeARMesh),@(FUNamaAITypeActionRecognition),@(FUNamaAITypeBodyKeypoint),@(FUNamaAITypeHairSplit),@(FUNamaAITypeHeadSplit),@(FUNamaAITypePortraitSegmentation),@(FUNamaAITypeActionRecognition),@(FUNamaAITypeGestureRecognition),@(FUNamaAITypeEmotionRecognition)];
            break;
            
            case FUNamaAITypeBodyKeypoint:
            case FUNamaAITypeActionRecognition:
            return @[@(FUNamaAITypeKeypoint),@(FUNamaAITypeTongue),@(FUNamaAITypeExpressionRecognition),@(FUNamaAITypeARMesh),@(FUNamaAITypeBodyKeypoint),@(FUNamaAITypeActionRecognition),@(FUNamaAITypeEmotionRecognition)];
            break;
            
        case FUNamaAITypeBodySkeleton:
            return @[@(aitype)];
            break;
        default:
            return  @[@(aitype),@(FUNamaAITypeKeypoint),@(FUNamaAITypeTongue),@(FUNamaAITypeExpressionRecognition),@(FUNamaAITypeEmotionRecognition),@(FUNamaAITypeARMesh)];
            break;
    }
}

/// CellModel选中是，其他选中状态修改
-(void)changeOtherStateWithSelCellModel:(FUAIConfigCellModel *)cellModle{
    if (cellModle.aiType == FUNamaAITypeKeypoint || cellModle.aiType == FUNamaAITypeTongue ||cellModle.aiType == FUNamaAITypeExpressionRecognition || cellModle.aiType == FUNamaAITypeEmotionRecognition || cellModle.aiType == FUNamaAITypeARMesh) {//特征点默认随之选中
        FUAISectionModel *sectionModel = self.configDataSource[0];
        sectionModel.aiMenu[0].state = FUAICellStateSel;
    }
    
    NSArray *array = [self otherCanEnable:cellModle.aiType];// 可共选的数组
    for (FUAISectionModel *config in self.configDataSource) {
        for(int i = 0;i < config.aiMenu.count;i ++){
            FUAIConfigCellModel *model = config.aiMenu[i];
            if ([array containsObject:@(model.aiType)]) {// 不可共选的置灰
                continue;
            }
            model.state = FUAICellStateDisable;
        }
    }
}

/// CellModel取消选中，其他选中状态修改
-(void)changeOtherStateWithNomalCellModel:(FUAIConfigCellModel *)cellModle{
    if (cellModle.aiType == FUNamaAITypeKeypoint) {//特征点默认随之取消
        for (FUAIConfigCellModel *modle in self.configDataSource[0].aiMenu) {
            modle.state = FUAICellStateNol;
        }
    }
    
    NSArray *array = [self otherCanEnable:cellModle.aiType];//可共选的数组
    BOOL isFaceHaveSel = NO;
    BOOL isOtherHaveSel = NO;
    for (FUAISectionModel *config in self.configDataSource) {
        if (config.moduleType == FUModuleTypeFace) {
            for(int i = 0;i < config.aiMenu.count;i ++){
                FUAIConfigCellModel *model = config.aiMenu[i];
                if (model.state == FUAICellStateSel) {//  人脸还有选中
                    isFaceHaveSel = YES;
                }
            }
            continue;
        }
        for(int i = 0;i < config.aiMenu.count;i ++){
            FUAIConfigCellModel *model = config.aiMenu[i];
            if (model.state == FUAICellStateSel) {//  除人脸其他有选中
                isOtherHaveSel = YES;
            }
        }
    }
    if (isOtherHaveSel) {
        return;
    }
    
    for (FUAISectionModel *config in self.configDataSource) {
        for (int i = 0;i < config.aiMenu.count;i ++) {
            FUAIConfigCellModel *model = config.aiMenu[i];
            if ([array containsObject:@(model.aiType)]) {//  不可共选的置灰
                continue;
            }
            model.state = FUAICellStateNol;
            if (model.aiType ==  FUNamaAITypeBodySkeleton && isFaceHaveSel) {
                model.state = FUAICellStateDisable;
            }
        }
    }
}


#pragma  mark - Event response

- (void)restBtnClick:(UIButton *)btn{
    for (FUAISectionModel *config in self.configDataSource) {
        for(int i = 0; i < config.aiMenu.count; i++){
            FUAIConfigCellModel *model = config.aiMenu[i];
            model.state = FUAICellStateNol;
            model.footSelInde = 0;
        }
    }
    [_collectionView reloadData];
    
    // 移除所有道具
    [[FUManager shareManager] destoryItems];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(configController:didChangeConfigDataSource:)]) {
        [self.delegate configController:self didChangeConfigDataSource:[self.configDataSource copy]];
    }
}

- (void)donBtnClick:(UIButton *)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(configController:didChangeConfigDataSource:)]) {
        [self.delegate configController:self didChangeConfigDataSource:[self.configDataSource copy]];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Collection view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.configDataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.configDataSource[section].aiMenu.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FUConfigCell *cell = (FUConfigCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    FUAIConfigCellModel *model = self.configDataSource[indexPath.section].aiMenu[indexPath.row];
    cell.model = model;
    return cell;
}

/// 通过设置SupplementaryViewOfKind 来设置头部或者底部的view，其中 ReuseIdentifier 的值必须和 注册是填写的一致，本例都为 “reusableView”
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
    FUHeadReusableView *headerView= (FUHeadReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID forIndexPath:indexPath];
        FUAISectionModel *model = self.configDataSource[indexPath.section];
        headerView.titleLabel.text = model.sectionTitel;
        headerView.mImageView.image = [UIImage imageNamed:model.sectionImageName];
    return headerView;
    }
    
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
    FUFootReusableView *fView= (FUFootReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footViewID forIndexPath:indexPath];
        
        int selIndex = [self isShowFootView:indexPath.section];
        if (self.configDataSource[indexPath.section].aiMenu[selIndex]) {
            fView.model = self.configDataSource[indexPath.section].aiMenu[selIndex];
        }
        fView.userInteractionEnabled = YES;
    
    return fView;
    }
    return nil;

}

/// 设置Header的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    return CGSizeMake(screenWidth, 44);
}
 
/// 设置Footer的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if ([self isShowFootView:section] >= 0){
        CGFloat screenWidth = collectionView.bounds.size.width;
        return CGSizeMake(screenWidth, 50);
    }
    return CGSizeMake(0, 0);
}

#pragma mark - Collection view delegate

/// 点击item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FUAIConfigCellModel *modle =  self.configDataSource[indexPath.section].aiMenu[indexPath.row];
    if (modle.state == FUAICellStateDisable) {
        return;
    }
    modle.state = modle.state ? 0 : 1;
    
    if (modle.state == FUAICellStateSel) {
        [self changeOtherStateWithSelCellModel:modle];
          /* 证书权限 */
        int moduleCode = [FURenderKit getModuleCode:[modle.moduleCodes[0] intValue]];
        if((moduleCode & [modle.moduleCodes[1] intValue]) == 0){
            [self showMessage:@"缺少证书,功能无效"];
        }
    } else {
        [self changeOtherStateWithNomalCellModel:modle];
    }
    [collectionView reloadData];
}


#pragma mark - Collection view delegate flow layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80, 32);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

#pragma mark - Getters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 89, CGRectGetWidth(self.view.frame) * 0.75, CGRectGetHeight(self.view.frame)) collectionViewLayout:[UICollectionViewFlowLayout new]];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        // 注册 cell
        [_collectionView registerClass:[FUConfigCell class] forCellWithReuseIdentifier:cellID];
        [_collectionView registerClass:[FUHeadReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID];
        [_collectionView registerClass:[FUFootReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footViewID];
    }
    return _collectionView;
}

@end
