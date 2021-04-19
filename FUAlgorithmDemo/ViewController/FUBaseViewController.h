//
//  FUBaseViewController.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/1/28.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//
/* 视频采集·切换，公用UI，基类控制器 */

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "FUHeadButtonView.h"
#import "FUPhotoButton.h"
#import "FUOpenGLView.h"
#import "FUGestureView.h"

#import "FUTongueView.h"
#import "FUExpresionView.h"
#define KScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define KScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define  iPhoneXStyle ((KScreenWidth == 375.f && KScreenHeight == 812.f ? YES : NO) || (KScreenWidth == 414.f && KScreenHeight == 896.f ? YES : NO))

NS_ASSUME_NONNULL_BEGIN


@interface FUBaseViewController : UIViewController<FUHeadButtonViewDelegate>

@property (strong, nonatomic) FUHeadButtonView *headButtonView;
@property (strong, nonatomic) FUOpenGLView *renderView;
@property (strong, nonatomic) UILabel *noTrackLabel;
@property (strong, nonatomic) UILabel *tipLabel;

@property (strong, nonatomic) FUOpenGLView *mPerView;

@property (strong, nonatomic) FUGestureView *mGestureView;

@property (strong, nonatomic) FUGestureView *mActionView;

@property (strong, nonatomic) FUExpresionView *mExpresionView;

@property (strong, nonatomic) FUTongueView *mTongueView;

@property (strong, nonatomic) FUTongueView *mEmotionView;

@property (strong, nonatomic) UILabel *buglyLabel;
/* 子类重载，实现差异逻辑 */
-(void)takePhotoToSave:(UIImage *)image;//拍照保存
-(void)didOutputVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;
-(void)updateSubView;

@end

NS_ASSUME_NONNULL_END
