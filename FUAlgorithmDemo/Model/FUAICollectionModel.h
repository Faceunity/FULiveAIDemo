//
//  FUAIConfig.h
//  FUAlgorithmDemo
//
//  Created by 孙慕 on 2020/5/22.
//  Copyright © 2020 孙慕. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, FUAIBtnState) {
    FUAIBtn1SelState = 1 << 0,
    FUAIBtn2SelState = 1 << 1,
};
typedef NS_ENUM(NSUInteger, FUAICellState) {
    FUAICellstateNol = 0,
    FUAICellstateSel = 1,
    FUAICellstateDisable = 2,
};

typedef NS_ENUM(NSUInteger, FUMoudleType) {
    FUMoudleTypeFace    = 0,
    FUMoudleTypeBody    = 1,//人体
    FUMoudleTypeGesture = 2,//手势
    FUMoudleTypeSeg     = 3,//分割
    FUMoudleTypeAction  = 4,//动作
};

typedef NS_ENUM(NSUInteger, FUNamaAIType) {
    FUNamaAITypeKeypoint = 0,
    FUNamaAITypeTongue = 1,
    FUNamaAITypeExpression= 2,
    FUNamaAITypeBodyDetection = 3,
    FUNamaAITypeBodyKeyPoints = 4,
    FUNamaAITypeBodySkeleton = 5,
    FUNamaAITypegestureRecognition = 6,
    FUNamaAITypePortraitSegmentation = 7,
    FUNamaAITypeHeadSplit = 8,
    FUNamaAITypeHairSplit = 9,
    FUNamaAITypeActionRecognition = 10,
};


@interface FUAIConfigCellModel : NSObject<NSCopying>


@property (nonatomic, copy) NSString* aiMenuTitel;
@property (nonatomic, copy) NSArray <NSString*>* bundleNames;
@property (nonatomic, copy) NSArray <NSString*>* bindItemNames;
@property (nonatomic, copy) NSArray <NSString*> *mToasts;
@property (nonatomic, copy) NSString* sectionImageName;
@property (assign, nonatomic) FUAICellState state;
@property (assign, nonatomic) FUNamaAIType aiType;

/* 最大识别数 */
@property (assign, nonatomic) int maxNum;

/* 设置加载道具的参数，针对单个道具 */
@property (nonatomic, strong) NSDictionary* parms;

@property (assign, nonatomic) int footSelInde;
@property (nonatomic, copy) NSArray <NSString*>* subFootes;

@end


@interface FUAISectionModel : NSObject<NSCopying>


@property (nonatomic, copy) NSString* sectionTitel;
@property (nonatomic, copy) NSString* sectionImageName;

@property (assign, nonatomic) FUMoudleType moudleType;
@property (nonatomic, strong) NSArray <FUAIConfigCellModel *>* aiMenu;


@end

NS_ASSUME_NONNULL_END
