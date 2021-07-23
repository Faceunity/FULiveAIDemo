//
//  FUBaseViewController.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/1/28.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//
/* 视频采集·切换，公用UI，基类控制器 */

#import <UIKit/UIKit.h>

#import "FUConfigController.h"

#import "FUHeadButtonView.h"

#import "FUManager.h"
#import "FUConfigManager.h"
#import "FUMacros.h"

NS_ASSUME_NONNULL_BEGIN


@interface FUBaseViewController : UIViewController<FUHeadButtonViewDelegate, FUConfigControllerProtocol>

@property (nonatomic, strong, readonly) FUHeadButtonView *headButtonView;

@property (nonatomic, strong, readonly) FUGLDisplayView *renderView;

@property (nonatomic, strong, readonly) UILabel *buglyLabel;

- (void)refreshOutputVideo;

@end

NS_ASSUME_NONNULL_END
