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
    FUMoudleTypeBody    = 0,//人体
    FUMoudleTypeGesture = 1,//手势
    FUMoudleTypeSeg     = 2,//分割
    FUMoudleTypeAction  = 3,//动作
};

typedef NS_ENUM(NSUInteger, FUNamaAIType) {
    FUNamaAITypeBodyDetection = 0,
    FUNamaAITypeBodyKeyPoints = 1,
    FUNamaAITypeBodySkeleton = 2,
    FUNamaAITypegestureRecognition = 3,
    FUNamaAITypePortraitSegmentation = 4,
    FUNamaAITypeHeadSplit = 5,
    FUNamaAITypeHairSplit = 6,
    FUNamaAITypeActionRecognition = 7,
};


@interface FUAIConfigCellModel : NSObject<NSCopying>


@property (nonatomic, copy) NSString* aiMenuTitel;
@property (nonatomic, copy) NSArray <NSString*>* bundleNames;
@property (nonatomic, copy) NSArray <NSString*>* bindItemNames;
@property (nonatomic, copy) NSArray <NSString*> *mToasts;
@property (nonatomic, copy) NSString* sectionImageName;
@property (assign, nonatomic) FUAICellState state;
@property (assign, nonatomic) FUNamaAIType aiType;

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
