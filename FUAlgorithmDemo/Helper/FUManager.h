//
//  FUManager.h
//  FULiveDemo
//
//  Created by 刘洋 on 2017/8/18.
//  Copyright © 2017年 刘洋. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FUConfigManager.h"

@interface FUManager : NSObject

/// 是否运行人脸特征点
@property (nonatomic, assign, getter=isRunningFaceKeypoint) BOOL runningFaceKeypoint;

/// 是否运行舌头检测
@property (nonatomic, assign, getter=isRunningTongueTracking) BOOL runningTongueTracking;

/// 是否运行表情识别
@property (nonatomic, assign, getter=isRunningExpressionRecognition) BOOL runningExpressionRecognition;

/// 是否运行情绪识别
@property (nonatomic, assign, getter=isRunningEmotionRecognition) BOOL runningEmotionRecognition;

/// 是否运行全身人体关键点
@property (nonatomic, assign, getter=isRunningWholeBodyKeypoint) BOOL runningWholeBodyKeypoint;

/// 是否运行半身人体关键点
@property (nonatomic, assign, getter=isRunningHalfBodyKeypoint) BOOL runningHalfBodyKeypoint;

/// 是否运行全身人体骨骼
@property (nonatomic, assign, getter=isRunningWholeBodySkeleton) BOOL runningWholeBodySkeleton;

/// 是否运行半身人体骨骼
@property (nonatomic, assign, getter=isRunningHalfBodySkeleton) BOOL runningHalfBodySkeleton;

/// 是否运行手势识别
@property (nonatomic, assign, getter=isRunningGestureRecognition) BOOL runningGestureRecognition;

/// 是否运行人像分割
@property (nonatomic, assign, getter=isRunningPortraitSegmentation) BOOL runningPortraitSegmentation;

/// 是否运行头发分割
@property (nonatomic, assign, getter=isRunningHairSplit) BOOL runningHairSplit;

/// 是否运行头部分割
@property (nonatomic, assign, getter=isRunningHeadSplit) BOOL runningHeadSplit;

/// 是否运行动作识别
@property (nonatomic, assign, getter=isRunningActionRecognition) BOOL runningActionRecognition;


+ (FUManager *)shareManager;

/// 是否需要人脸
- (BOOL)isNeedFace;

/// 是否需要人体
- (BOOL)isNeedBody;

/// 是否需要手势
- (BOOL)isNeedGesture;

/// 销毁道具，清除缓存
- (void)destoryItems;

@end
