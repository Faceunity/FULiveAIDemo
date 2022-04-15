//
//  FUAIConfig.h
//  FUAlgorithmDemo
//
//  Created by 孙慕 on 2020/5/22.
//  Copyright © 2020 孙慕. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FUAICellState) {
    FUAICellStateNol = 0,
    FUAICellStateSel = 1,
    FUAICellStateDisable = 2,
};

typedef NS_ENUM(NSUInteger, FUModuleType) {
    FUModuleTypeFace    = 0,
    FUModuleTypeBody    = 1,//人体
    FUModuleTypeGesture = 2,//手势
    FUModuleTypeSegmentation     = 3,//分割
    FUModuleTypeAction  = 4,//动作
};

typedef NS_ENUM(NSUInteger, FUNamaAIType) {
    FUNamaAITypeKeypoint = 0,
    FUNamaAITypeTongue,
    FUNamaAITypeExpressionRecognition,
    FUNamaAITypeEmotionRecognition,
    FUNamaAITypeBodyKeypoint,
    FUNamaAITypeBodySkeleton,
    FUNamaAITypeGestureRecognition,
    FUNamaAITypePortraitSegmentation,
    FUNamaAITypeHairSplit,
    FUNamaAITypeHeadSplit,
    FUNamaAITypeActionRecognition
};


@interface FUAIConfigCellModel : NSObject<NSCopying>


@property (nonatomic, copy) NSString* aiMenuTitel;
@property (nonatomic, copy) NSArray <NSString*>* bundleNames;
@property (nonatomic, copy) NSArray <NSString*>* bindItemNames;
@property (nonatomic, copy) NSArray <NSString*> *mToasts;
@property (nonatomic, copy) NSString* sectionImageName;
@property (assign, nonatomic) FUAICellState state;
@property (assign, nonatomic) FUNamaAIType aiType;

/* 设置加载道具的参数，针对单个道具 */
@property (nonatomic, strong) NSDictionary* parms;

@property (assign, nonatomic) int footSelInde;

@property (nonatomic, copy) NSArray <NSString*>* subFootes;

@property (strong, nonatomic) NSArray<NSNumber *>* moduleCodes;

@end


@interface FUAISectionModel : NSObject<NSCopying>


@property (nonatomic, copy) NSString* sectionTitel;
@property (nonatomic, copy) NSString* sectionImageName;

@property (assign, nonatomic) FUModuleType moduleType;
@property (nonatomic, strong) NSArray <FUAIConfigCellModel *>* aiMenu;


@end

NS_ASSUME_NONNULL_END
