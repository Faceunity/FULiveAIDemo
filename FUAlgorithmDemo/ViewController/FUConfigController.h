//
//  FUConfigController.h
//  FUAlgorithmDemo
//
//  Created by 孙慕 on 2020/5/21.
//  Copyright © 2020 孙慕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUAICollectionModel.h"
NS_ASSUME_NONNULL_BEGIN

extern NSString* const FUConfigControllerUpdateNotification;

@interface FUConfigController : UIViewController


@property(nonatomic,strong) NSMutableArray <FUAISectionModel*>*config;

@property (nonatomic,weak) UIViewController *weakVC;
@end

NS_ASSUME_NONNULL_END
