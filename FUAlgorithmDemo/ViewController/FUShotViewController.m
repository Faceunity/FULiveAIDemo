//
//  FUShotViewController.m
//  FUAlgorithmDemo
//
//  Created by 孙慕 on 2020/5/26.
//  Copyright © 2020 孙慕. All rights reserved.
//

#import "FUShotViewController.h"

#import "FUPhotoButton.h"

#import "FUManager.h"
#import "FUIndexHandle.h"

#import "UIViewController+CWLateralSlide.h"

#import <SVProgressHUD.h>
#import <MJExtension.h>

@interface FUShotViewController ()<FUPhotoButtonDelegate, FURenderKitDelegate>

@property (nonatomic, strong) FUPhotoButton *photoBtn;

@property (nonatomic, strong) FUGLDisplayView *smallDisplayView;

@property (nonatomic, strong) NSMutableParagraphStyle *paragraphStyle;

@end

@implementation FUShotViewController

// 视频信息计算相关
static int rate = 0;
static NSTimeInterval startTime;
static NSTimeInterval totalRenderTime = 0;
static NSTimeInterval oldTime = 0;

#pragma mark -  Life cycle

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self setupStotSubView];
    
    [[FURenderKit shareRenderKit] startInternalCamera];
    // 摄像头默认设置为前置
    if (![FURenderKit shareRenderKit].captureCamera.isFrontCamera) {
        [[FURenderKit shareRenderKit].captureCamera changeCameraInputDeviceisFront:YES];
    }
    [FURenderKit shareRenderKit].glDisplayView = self.renderView;
    [FURenderKit shareRenderKit].delegate = self;
    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[FURenderKit shareRenderKit].captureCamera resetFocusAndExposureModes];
    [FUConfigManager onCameraChange];
    [self.photoBtn photoButtonFinishRecord];
}

- (void)dealloc {
    [[FURenderKit shareRenderKit] stopInternalCamera];
    [FURenderKit shareRenderKit].glDisplayView = nil;
}


#pragma mark -  UI

-(void)setupStotSubView{
    
    [self.view addSubview:self.smallDisplayView];
    
    [self.view addSubview:self.photoBtn];
    
    NSString *bugly = @"\nresolution:\n720*1280\nfps: 30 \nframe time:10ms\nyaw: 10.1°\npitch: 10°\nroll: 10.1°\n";
    NSMutableAttributedString *buglyString = [[NSMutableAttributedString alloc] initWithString:bugly];
    [buglyString addAttribute:NSParagraphStyleAttributeName value:self.paragraphStyle range:NSMakeRange(0, bugly.length)];
    self.buglyLabel.attributedText = buglyString;
    
}

#pragma mark - Event response

- (void)handlePanAction:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender translationInView:[sender.view superview]];
    
    CGFloat senderHalfViewWidth = sender.view.frame.size.width / 2;
    CGFloat senderHalfViewHeight = sender.view.frame.size.height / 2;
    
    __block CGPoint viewCenter = CGPointMake(sender.view.center.x + point.x, sender.view.center.y + point.y);
    // 拖拽状态结束
    if (sender.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.4 animations:^{
            if ((sender.view.center.x + point.x - senderHalfViewWidth) <= 5 || sender.view.center.x < FUScreenWidth/2) {
                viewCenter.x = senderHalfViewWidth + 5;
            }
            if ((sender.view.center.x + point.x + senderHalfViewWidth) >= FUScreenWidth - 5 || sender.view.center.x >= FUScreenWidth/2) {
                viewCenter.x = FUScreenWidth - senderHalfViewWidth - 5;
            }
            if ((sender.view.center.y + point.y - senderHalfViewHeight) <= 75) {
                viewCenter.y = senderHalfViewHeight + 75;
            }
            if ((sender.view.center.y + point.y + senderHalfViewHeight) >= (FUScreenHeight -5)) {
                viewCenter.y = FUScreenHeight - senderHalfViewHeight - 5;
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

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"保存图片失败", nil)];
    } else {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"图片已保存到相册", nil)];
    }
    [SVProgressHUD dismissWithDelay:1.5f];
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"保存视频失败", nil)];
    } else {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"视频已保存到相册", nil)];
    }
    [SVProgressHUD dismissWithDelay:1.5f];
}

#pragma mark - Private methods

// 更新视频参数栏
- (void)updateVideoParametersText:(NSTimeInterval)startTime bufferRef:(CVPixelBufferRef)pixelBuffer{
    if (startTime - oldTime >= 1) {//一秒钟计算平均值
        oldTime = startTime;
        int diaplayRate = rate;
        NSTimeInterval diaplayRenderTime = totalRenderTime;
        
        int w = (int)CVPixelBufferGetWidth(pixelBuffer);
        int h = (int)CVPixelBufferGetHeight(pixelBuffer);
        
        float pret[3] = {0};
        [FUConfigManager faceInfoWithName:@"rotation_euler" pret:pret number:3];
        float x = pret[0] * 180 / M_PI;
        float y = pret[1] * 180 / M_PI;
        float z = pret[2] * 180 / M_PI;
    
        BOOL isTrack = [[FUManager shareManager] isRunningFaceKeypoint] && [FUConfigManager isTrackingFace];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *str = isTrack ? [NSString stringWithFormat:@"\nresolution:\n%d*%d\nfps: %d \nframe time:%.0fms\nyaw: %.2f°\npitch: %.2f°\nroll: %.2f°\n", w, h, diaplayRate, diaplayRenderTime * 1000.0 / diaplayRate, y, x, z] : [NSString stringWithFormat:@"\nresolution:\n%d*%d\nfps: %d \nframe time:%.0fms\nyaw: null\npitch: null\nroll: null\n", w, h, diaplayRate, diaplayRenderTime * 1000.0 / diaplayRate];
            NSMutableAttributedString *testStr = [[NSMutableAttributedString alloc] initWithString:str];
            [testStr addAttribute:NSParagraphStyleAttributeName value:self.paragraphStyle range:NSMakeRange(0, testStr.length)];
            
            self.buglyLabel.attributedText = testStr;
        });
        totalRenderTime = 0;
        rate = 0;
    }
}

#pragma mark - FURenderKitDelegate

- (void)renderKitWillRenderFromRenderInput:(FURenderInput *)renderInput {
    startTime = [[NSDate date] timeIntervalSince1970];
    if ([FUManager shareManager].runningHalfBodySkeleton || [FUManager shareManager].runningWholeBodySkeleton) {
        [self.smallDisplayView displayPixelBuffer:renderInput.pixelBuffer];
    }
}

- (BOOL)renderKitShouldDoRender {
    return YES;
}

- (void)renderKitDidRenderToOutput:(FURenderOutput *)renderOutput {
    // 及时刷新对应界面控件
    [self refreshOutputVideo];
    
    // 视频信息计算
    NSTimeInterval endTime =  [[NSDate date] timeIntervalSince1970];
    totalRenderTime += (endTime - startTime);
    rate ++;
    [self updateVideoParametersText:endTime bufferRef:renderOutput.pixelBuffer];
}

#pragma  mark -  FUHeadButtonViewDelegate

-(void)headButtonViewBackAction:(UIButton *)btn{
    [[FURenderKit shareRenderKit] stopInternalCamera];
    [super headButtonViewBackAction:btn];
}

-(void)headButtonViewSwitchAction:(UIButton *)sender{
    sender.userInteractionEnabled = NO ;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
        sender.userInteractionEnabled = YES ;
    });
     
    [[FURenderKit shareRenderKit].captureCamera changeCameraInputDeviceisFront:sender.selected];
    sender.selected = !sender.selected ;
    [FUConfigManager resetHumanProcessor];
    [FUConfigManager onCameraChange];
}

#pragma mark - FUConfigControllerProtocol

- (void)configController:(FUConfigController *)controller didChangeConfigDataSource:(NSArray<FUAISectionModel *> *)configs {
    
    [super configController:controller didChangeConfigDataSource:configs];
    
    // 拍照按钮根据是否人体骨骼显示/隐藏
    self.photoBtn.hidden = [FUManager shareManager].runningHalfBodySkeleton || [FUManager shareManager].runningWholeBodySkeleton;
    // 小视图根据是否人体骨骼显示/隐藏
    self.smallDisplayView.hidden = !([FUManager shareManager].runningHalfBodySkeleton || [FUManager shareManager].runningWholeBodySkeleton);
}

#pragma mark -  PhotoButtonDelegate

/// 拍照
- (void)takePhoto {
    // 拍照效果
    self.photoBtn.enabled = NO;
    UIView *whiteView = [[UIView alloc] initWithFrame:self.view.bounds];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    whiteView.alpha = 0.3;
    [UIView animateWithDuration:0.1 animations:^{
        whiteView.alpha = 0.8;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            whiteView.alpha = 0;
        } completion:^(BOOL finished) {
            self.photoBtn.enabled = YES;
            [whiteView removeFromSuperview];
        }];
    }];
    
    UIImage *resultImage = [FURenderKit captureImage];
    if (resultImage) {
        [self takePhotoToSave:resultImage];
    }
}

-(void)takePhotoToSave:(UIImage *)image {
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

/// 开始录像
- (void)startRecord {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMddhhmmssSS"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    NSString *videoPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", dateString]];
    [FURenderKit startRecordVideoWithFilePath:videoPath];
}

/// 停止录像
- (void)stopRecord {
    [FURenderKit stopRecordVideoComplention:^(NSString * _Nonnull filePath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UISaveVideoAtPathToSavedPhotosAlbum(filePath, self, @selector(video:didFinishSavingWithError:contextInfo:), NULL);
        });
    }];
}


#pragma mark - Getters

- (FUGLDisplayView *)smallDisplayView {
    if (!_smallDisplayView) {
        _smallDisplayView = [[FUGLDisplayView alloc] initWithFrame:CGRectMake(FUScreenWidth - 95, FUScreenHeight - 151, 90, 146)];
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanAction:)];
        [_smallDisplayView addGestureRecognizer:panGestureRecognizer];
        _smallDisplayView.backgroundColor = [UIColor redColor];
        _smallDisplayView.hidden = YES;
    }
    return _smallDisplayView;
}

- (FUPhotoButton *)photoBtn {
    if (!_photoBtn) {
        _photoBtn = [[FUPhotoButton alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
        [_photoBtn setImage:[UIImage imageNamed:@"camera_btn_camera_normal"] forState:UIControlStateNormal];
        if(FUiPhoneXStyle()){
            _photoBtn.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 150 - 50);
        }else{
            _photoBtn.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 120 - 20);
        }
        _photoBtn.delegate = self;
    }
    return _photoBtn;
}

- (NSMutableParagraphStyle *)paragraphStyle {
    if (!_paragraphStyle) {
        _paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        _paragraphStyle.lineSpacing = 3;                    // 设置行间距
        _paragraphStyle.paragraphSpacing = 4;               // 设置段间距
        _paragraphStyle.alignment = NSTextAlignmentLeft;    // 设置对齐方式
        _paragraphStyle.firstLineHeadIndent = 5;            // 首行缩进距离
        _paragraphStyle.headIndent = 5;                     // 除首行之外其他行缩进
        _paragraphStyle.tailIndent = 300;                   // 每行容纳字符的宽度
        _paragraphStyle.minimumLineHeight = 2;              // 每行最小高度
        _paragraphStyle.maximumLineHeight = 10;             // 每行最大高度
        _paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;  // 换行方式
    }
    return _paragraphStyle;
}

@end
