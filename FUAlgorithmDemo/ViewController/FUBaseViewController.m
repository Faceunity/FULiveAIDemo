//
//  FUBaseViewController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/1/28.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUBaseViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "FURenderer.h"
#import <CoreMotion/CoreMotion.h>
#import <Masonry.h>
#import "FUPopupMenu.h"
#import "FUManager.h"
#import "UIViewController+CWLateralSlide.h"
#import "FUConfigController.h"
#import "FUImageHelper.h"
#import <objc/runtime.h>
#import "FUGestureHandle.h"
#import "SVProgressHUD.h"
#import "MJExtension.h"


@interface FUBaseViewController ()<
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,
FUPopupMenuDelegate
>
{
    dispatch_semaphore_t signal;
    float imageW ;
    float imageH;
}
@property (strong, nonatomic) UILabel *buglyLabel;
@property (strong, nonatomic) UIImageView *adjustImage;

@end

@implementation FUBaseViewController


- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    headView.image = [UIImage imageNamed:@"demo_bg_top_mask"];
    [self.view addSubview:headView];
    
    
    NSString *path=[[NSBundle mainBundle] pathForResource:@"AIConfig" ofType:@"json"];
    NSData *pathData=[[NSData alloc] initWithContentsOfFile:path];
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:pathData options:NSJSONReadingMutableContainers error:nil];
    [FUManager shareManager].config = [FUAISectionModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
    
    [self setupSubView];
    [self setupGestureView];
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    /* 道具切信号 */
    signal = dispatch_semaphore_create(1);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSubView) name:FUConfigControllerUpdateNotification object:nil];
    
    fuHumanProcessorSetMaxHumans(1);
}



#pragma  mark -  UI
-(void)setupSubView{
    /* opengl */
    _renderView = [[FUOpenGLView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_renderView];
    
    /* 顶部按钮 */
    _headButtonView = [[FUHeadButtonView alloc] init];
    _headButtonView.delegate = self;
    [self.view addSubview:_headButtonView];
    [_headButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(20);
        } else {
            make.top.equalTo(self.view.mas_top).offset(30);
        }
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    /* bugly信息 */
    _buglyLabel = [[UILabel alloc] init];
    _buglyLabel.layer.masksToBounds = YES;
    _buglyLabel.layer.cornerRadius = 5;
    _buglyLabel.numberOfLines = 0;
    _buglyLabel.backgroundColor = [UIColor darkGrayColor];
    _buglyLabel.textColor = [UIColor whiteColor];
    _buglyLabel.alpha = 0.74;
    _buglyLabel.font = [UIFont systemFontOfSize:15];
    _buglyLabel.hidden = YES;
    _buglyLabel.text = @" resolution:\n  720*1280\n fps: 30 \n render time:\n  10ms";
    [self.view addSubview:_buglyLabel];
    [_buglyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headButtonView.mas_bottom).offset(15);
        make.left.equalTo(self.view).offset(10);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(100);
    }];
    
    /* 点击校准知识 */
    _adjustImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_校准"]];
    _adjustImage.center = self.view.center;
    _adjustImage.hidden = YES;
    [self.view addSubview:_adjustImage];
    
    /* 未检测到人脸提示 */
    _noTrackLabel = [[UILabel alloc] init];
    _noTrackLabel = [[UILabel alloc] init];
    _noTrackLabel.textColor = [UIColor whiteColor];
    _noTrackLabel.font = [UIFont systemFontOfSize:17];
    _noTrackLabel.textAlignment = NSTextAlignmentCenter;
    _noTrackLabel.text = NSLocalizedString(@"No_Face_Tracking", @"未检测到人脸");
    _noTrackLabel.hidden = YES;
    [self.view addSubview:_noTrackLabel];
    [_noTrackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(22);
    }];
    
    /* 额外操作提示 */
    _tipLabel = [[UILabel alloc] init];
    _tipLabel.textColor = [UIColor whiteColor];
//    _tipLabel.backgroundColor = [UIColor colorWithRed:17/255.0 green:18/255.0 blue:38/255.0 alpha:0.7];
    _tipLabel.font = [UIFont systemFontOfSize:13];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.text = @"已保存至手机";
    _tipLabel.layer.cornerRadius = 4;
    _tipLabel.layer.masksToBounds = YES;
    _tipLabel.hidden = YES;
    [self.view addSubview:_tipLabel];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.noTrackLabel.mas_bottom);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(32);
    }];
    
    _mPerView = [[FUOpenGLView alloc] initWithFrame:CGRectMake(KScreenWidth - 90 - 5, KScreenHeight - 146 - 5, 90, 146)];
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanAction:)];
    [_mPerView addGestureRecognizer:panGestureRecognizer];
    _mPerView.backgroundColor = [UIColor redColor];
    _mPerView.hidden = YES;
    [self.view addSubview:_mPerView];

}

-(void)setupGestureView{
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, 100);
    if(iPhoneXStyle){
        frame.origin.y = self.view.frame.size.height - 134;
    }else{
        frame.origin.y = self.view.frame.size.height - 100;
    }
    NSArray *images = @[@[@"demo_gesture_icon_love",@"demo_gesture_icon_one_handed",@"demo_gesture_icon_hands",@"demo_gesture_icon_clenched_fist",@"demo_gesture_icon_hands_together",@"demo_gesture_icon_hands_take_pictures"],@[@"demo_gesture_icon_one",@"demo_gesture_icon_two",@"demo_gesture_icon_three",@"demo_gesture_icon_five",@"demo_gesture_icon_six",@"demo_gesture_icon_zero",@"demo_gesture_icon_palm_up",@"demo_gesture_icon_thumb_up"]];//,@"demo_gesture_icon_hands_crossed"
    _mGestureView = [[FUGestureView alloc] initWithFrame:frame images:images];
    _mGestureView.hidden = YES;
    [self.view addSubview:_mGestureView];
    
    
    NSArray *images1 = @[@[@"demo_action_icon_0",@"demo_action_icon_1",@"demo_action_icon_2",@"demo_action_icon_3",@"demo_action_icon_4",@"demo_action_icon_5",@"demo_action_icon_6"],@[@"demo_action_icon_7",@"demo_action_icon_8",@"demo_action_icon_9",@"demo_action_icon_10",@"demo_action_icon_11",@"demo_action_icon_12",@"demo_action_icon_13",@"demo_action_icon_14"]];
    _mActionView = [[FUGestureView alloc] initWithFrame:frame images:images1];
    _mActionView.hidden = YES;
    [self.view addSubview:_mActionView];
    
}




#pragma  mark -  FUHeadButtonViewDelegate

-(void)headButtonViewBackAction:(UIButton *)btn{
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    [self.navigationController popViewControllerAnimated:YES];
    dispatch_semaphore_signal(signal);
    [[FUManager shareManager] destoryItems];
    [FUManager shareManager].currentToast = nil;
    /* 清一下信息，防止快速切换有人脸信息缓存 */
    [FURenderer onCameraChange];
}


-(void)headButtonViewBuglyAction:(UIButton *)btn{
    self.buglyLabel.hidden = !self.buglyLabel.hidden;
}


-(void)headButtonViewMoreAction:(UIButton *)btn{
    btn.userInteractionEnabled = NO ;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
        btn.userInteractionEnabled = YES ;
    });
    FUConfigController *vc = [[FUConfigController alloc] init];
    
    /* 配置数据 */
    NSMutableArray *configs = [NSMutableArray array];
    for (FUAISectionModel *model in [FUManager shareManager].config) {
        [configs addObject:[model copy]];
    }
    vc.config = configs;
    
    CWLateralSlideConfiguration *config = [CWLateralSlideConfiguration configurationWithDistance:kCWSCREENWIDTH * 0.75 maskAlpha:0.4 scaleY:1.0 direction:CWDrawerTransitionFromRight backImage:nil];
    [self cw_showDrawerViewController:vc animationType:CWDrawerAnimationTypeDefault configuration:config];
    
    vc.weakVC = self;
}


#pragma  mark -  FUConfigControllerUpdateNotification

-(void)updateSubView{
     _mGestureView.hidden = YES;
    _mActionView.hidden = YES;
    _mPerView.hidden = YES;
    for (FUAISectionModel *modle in [FUManager shareManager].config) {
        if (modle.moudleType == FUMoudleTypeGesture && modle.aiMenu[0].state == FUAICellstateSel ) {//手势选中
            _mGestureView.hidden = NO;
        }
        
        if (modle.moudleType == FUMoudleTypeAction && modle.aiMenu[0].state == FUAICellstateSel ) {//动作选中
            _mActionView.hidden = NO;
        }
        
        if(modle.aiMenu.count > 1){//是否有骨骼
            if (modle.moudleType == FUMoudleTypeBody && modle.aiMenu[1].state == FUAICellstateSel ) {//动作选中
                _mPerView.hidden = NO;
            }
        }
    }
}

#pragma mark - FUCameraDelegate
static int rate = 0;
static NSTimeInterval totalRenderTime = 0;
static  NSTimeInterval oldTime = 0;
-(void)didOutputVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    
//    fuSetTrackFaceAIType(FUAITYPE_HUMAN_RPOCESSOR);
    
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) ;
    float h = CVPixelBufferGetHeight(pixelBuffer);
    float w = CVPixelBufferGetWidth(pixelBuffer);

    [_mPerView displayPixelBuffer:pixelBuffer];
    
    NSTimeInterval startTime =  [[NSDate date] timeIntervalSince1970];
    
//    if([[FUManager shareManager] isRuningAitype:FUNamaAITypeBodySkeleton]) {//手势识别中....
//              __weak typeof(self)weakSelf  = self ;
//          CVPixelBufferLockBaseAddress(pixelBuffer, 0);
//          char *data =  (char *)CVPixelBufferGetBaseAddress(pixelBuffer);
//          fuSetTrackFaceAIType(FUAITYPE_HUMAN_PROCESSOR_2D_DANCE);
//          [FURenderer trackFace:FU_FORMAT_BGRA_BUFFER inputData:data width:w height:h];
//          CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
//
//          if(fuHumanProcessorGetNumResults() > 0){
//              NSLog(@"人体识别index------%d",index);
//          }else{
//              dispatch_async(dispatch_get_main_queue(), ^{
//                  [weakSelf.mGestureView setGestureViewSel:-1];
//              });
//          }
//      }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tipLabel.text = [FUManager shareManager].currentToast;
    });
   
  if([[FUManager shareManager] isRuningAitype:FUNamaAITypegestureRecognition]) {//手势识别中....
            __weak typeof(self)weakSelf  = self ;
        [[FUManager shareManager] renderItemsToPixelBuffer:pixelBuffer];

        if(fuHandDetectorGetResultNumHands() > 0){
            FUAIGESTURETYPE type = fuHandDetectorGetResultGestureType(0);
            int index = [FUGestureHandle getIndexwith:type];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.mGestureView setGestureViewSel:index];
                if (self.tipLabel.text || !self.tipLabel.hidden) {
                 self.tipLabel.hidden = YES;
                }
              });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.mGestureView setGestureViewSel:-1];
                if (self.tipLabel.text) {
                    self.tipLabel.hidden = NO;
                }

            });
        }
    }else if([[FUManager shareManager] isRuningAitype:FUNamaAITypeBodySkeleton]) {//骨骼....
        [[FUManager shareManager] renderItemsWithPtaPixelBuffer:pixelBuffer];
        
        BOOL isTrack = fuHumanProcessorGetNumResults() > 0?YES:NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.tipLabel.text || !self.tipLabel.hidden) {
             self.tipLabel.hidden = isTrack;
            }
          });

    }else if([[FUManager shareManager] isRuningAitype:FUNamaAITypeActionRecognition]){//动作
        __weak typeof(self)weakSelf  = self ;
        [[FUManager shareManager] renderItemsToPixelBuffer:pixelBuffer];
        
        if(fuHumanProcessorGetNumResults() > 0){
            int  index = fuHumanProcessorGetResultActionType(0);
            NSLog(@"动作index------%d",fuHumanProcessorGetResultActionType(0));
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.mActionView setGestureViewSel:index];
                if (self.tipLabel.text || !self.tipLabel.hidden) {
                    self.tipLabel.hidden = YES;
                }
            });

        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.mActionView setGestureViewSel:-1];
                if (self.tipLabel.text) {
                    self.tipLabel.hidden = NO;
                }
            });

        }
    }else if([[FUManager shareManager] isRuningAitype:FUNamaAITypeBodyKeyPoints]){//关键点
        [[FUManager shareManager] renderItemsToPixelBuffer:pixelBuffer];
        
        BOOL isTrack = fuHumanProcessorGetNumResults() > 0?YES:NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.tipLabel.text || !self.tipLabel.hidden) {
             self.tipLabel.hidden = isTrack;
            }
          });
    }else if([[FUManager shareManager] isRuningAitype:FUNamaAITypeHairSplit] || [[FUManager shareManager] isRuningAitype:FUNamaAITypeHeadSplit]){
        [[FUManager shareManager] renderItemsToPixelBuffer:pixelBuffer];
        BOOL isTrack = [FURenderer isTracking] > 0?YES:NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.tipLabel.text || !self.tipLabel.hidden) {
                    self.tipLabel.hidden = isTrack >0?YES:NO;;
                }
            });
    }else{
        [[FUManager shareManager] renderItemsToPixelBuffer:pixelBuffer];
        BOOL isTrack = fuHumanProcessorGetNumResults() > 0?YES:NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.tipLabel.text || !self.tipLabel.hidden) {
                    self.tipLabel.hidden = isTrack >0?YES:NO;;
                }
            });
    }
    
    NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970];
    /* renderTime */
    totalRenderTime += endTime - startTime;
    rate ++;
    
    [self updateVideoParametersText:endTime bufferRef:pixelBuffer];
    
//    fuHumanProcessorReset();
//    fuHumanProcessorSetMaxHumans(1);
//     int res1 = fuHumanProcessorGetNumResults()
//      bb =fuHumanProcessorGetResultJoint2ds(0, &size);

    [self.renderView displayPixelBuffer:pixelBuffer];
//    int res2 =fuHumanProcessorGetResultTrackId(0);
//   const float*aa = fuHumanProcessorGetResultRect(0);
   
//    const float*cc = fuHumanProcessorGetResultJoint3ds(0, size);
//    const float*dd= fuHumanProcessorGetResultHumanMask(0,&mask_width,&mask_height);
//    const float*ee = fuFaceProcessorGetResultHairMask(0,&mask_width,&mask_height);
//    const float*ff = fuFaceProcessorGetResultHeadMask(0, &mask_width, &mask_height);
    
    
//    [self.renderView displayPixelBuffer:pixelBuffer];
////    static float posterLandmarks[239* 2];
////    [FURenderer getFaceInfo:0 name:@"landmarks" pret:posterLandmarks number:239* 2];
//    [self.renderView displayPixelBuffer:pixelBuffer];

}

//#pragma mark - FUCameraDataSource
//-(CGPoint)faceCenterInImage:(FUCamera *)camera{
//    CGPoint center = CGPointMake(-1, -1);
////    BOOL isHaveFace = [[FUManager shareManager] isTracking];
//
//    if (isHaveFace) {
//        center = [self cameraFocusAndExposeFace];
//    }
//    return center;
//}
//
//
//-(CGPoint)cameraFocusAndExposeFace{
//    CGPoint center = [[FUManager shareManager] getFaceCenterInFrameSize:CGSizeMake(imageW, imageH)];
//   return  CGPointMake(center.y, self.mCamera.isFrontCamera ? center.x : 1 - center.x);
//}



#pragma  mark -  刷新bugly text
// 更新视频参数栏
-(void)updateVideoParametersText:(NSTimeInterval)startTime bufferRef:(CVPixelBufferRef)pixelBuffer{
    if (startTime - oldTime >= 1) {//一秒钟计算平均值
        oldTime = startTime;
        int diaplayRate = rate;
        NSTimeInterval diaplayRenderTime = totalRenderTime;
        
        float w = CVPixelBufferGetWidth(pixelBuffer);
        float h = CVPixelBufferGetHeight(pixelBuffer);
        
        NSString *ratioStr = [NSString stringWithFormat:@"%.0fX%.0f", w, h];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.buglyLabel.text = [NSString stringWithFormat:@" resolution:\n  %@\n fps: %d \n render cost:\n  %.0fms",ratioStr,diaplayRate,diaplayRenderTime * 1000.0 / diaplayRate];
        });
        totalRenderTime = 0;
        rate = 0;
    }
}


/* 该功能，是否需要开启多重采样 */
-(BOOL)needSetMultiSamples{
    return NO;
}
     

-(BOOL)onlyJumpImage{
    return NO;
}


- (void)handlePanAction:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender translationInView:[sender.view superview]];
    
    CGFloat senderHalfViewWidth = sender.view.frame.size.width / 2;
    CGFloat senderHalfViewHeight = sender.view.frame.size.height / 2;
    
    __block CGPoint viewCenter = CGPointMake(sender.view.center.x + point.x, sender.view.center.y + point.y);
    // 拖拽状态结束
    if (sender.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.4 animations:^{
            if ((sender.view.center.x + point.x - senderHalfViewWidth) <= 5 || sender.view.center.x < KScreenWidth/2) {
                viewCenter.x = senderHalfViewWidth + 5;
            }
            if ((sender.view.center.x + point.x + senderHalfViewWidth) >= KScreenWidth - 5 || sender.view.center.x >= KScreenWidth/2) {
                viewCenter.x = KScreenWidth - senderHalfViewWidth - 5;
            }
            if ((sender.view.center.y + point.y - senderHalfViewHeight) <= 75) {
                viewCenter.y = senderHalfViewHeight + 75;
            }
            if ((sender.view.center.y + point.y + senderHalfViewHeight) >= (KScreenHeight -5)) {
                viewCenter.y = KScreenHeight - senderHalfViewHeight - 5;
            }
            sender.view.center = viewCenter;
        } completion:^(BOOL finished) {

        }];
        [sender setTranslation:CGPointMake(0, 0) inView:[sender.view superview]];
    } else {
        // UIGestureRecognizerStateBegan || UIGestureRecognizerStateChanged
        viewCenter.x = sender.view.center.x + point.x;
        viewCenter.y = sender.view.center.y + point.y;
        sender.view.center = viewCenter;
        [sender setTranslation:CGPointMake(0, 0) inView:[sender.view superview]];
    }
}


@end
