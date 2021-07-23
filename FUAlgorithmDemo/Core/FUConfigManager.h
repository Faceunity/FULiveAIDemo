//
//  FUConfigManager.h
//  FUAlgorithmDemo
//
//  Created by 项林平 on 2021/5/18.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FURenderKit/FURenderKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUConfigManager : NSObject

/// 初始化SDK
+ (void)initializeSDK;

/// 前后摄像头切换
+ (void)onCameraChange;

/// 重新设置人体模型
+ (void)resetHumanProcessor;

/// 是否检测到人脸
+ (BOOL)isTrackingFace;

/// 是否检测到人体
+ (BOOL)isTrackingBody;

/// 是否检测到手
+ (BOOL)isTrackingHand;

/// 获取人脸信息
+ (BOOL)faceInfoWithName:(NSString *)name pret:(float *)pret number:(int)number;

@end

NS_ASSUME_NONNULL_END
