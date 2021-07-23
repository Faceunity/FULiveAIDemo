//
//  FUConfigController.h
//  FUAlgorithmDemo
//
//  Created by 孙慕 on 2020/5/21.
//  Copyright © 2020 孙慕. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FUConfigController, FUAISectionModel;

NS_ASSUME_NONNULL_BEGIN

@protocol FUConfigControllerProtocol <NSObject>

/// 设置数据发生变化（修改、重置）
/// @param controller 控制器
/// @param configs 设置数据源数组
- (void)configController:(FUConfigController *)controller didChangeConfigDataSource:(NSArray<FUAISectionModel*> *)configs;

@end

@interface FUConfigController : UIViewController

@property (nonatomic, weak) id<FUConfigControllerProtocol> delegate;

@property (nonatomic, strong) NSMutableArray<FUAISectionModel*> *configDataSource;

@end

NS_ASSUME_NONNULL_END
