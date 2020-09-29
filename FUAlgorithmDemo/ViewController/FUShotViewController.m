//
//  FUShotViewController.m
//  FUAlgorithmDemo
//
//  Created by 孙慕 on 2020/5/26.
//  Copyright © 2020 孙慕. All rights reserved.
//

#import "FUShotViewController.h"
#import "FUImageHelper.h"
#import "FUCamera.h"
#import "FUGestureModel.h"
#import "MJExtension.h"
#import <SVProgressHUD.h>
#import <libCNamaSDK/FURenderer.h>
#import "FUManager.h"

@interface FUShotViewController ()<FUCameraDelegate,
FUCameraDataSource,FUPhotoButtonDelegate>{
    dispatch_semaphore_t semaphore;
    UIImage *mCaptureImage;
}
@property (strong, nonatomic) FUPhotoButton *photoBtn;

@property (strong, nonatomic) FUCamera *mCamera;

@end

@implementation FUShotViewController

#pragma mark -  Loading

-(FUCamera *)mCamera {
    if (!_mCamera) {
        _mCamera = [[FUCamera alloc] init];
        _mCamera.delegate = self ;
        _mCamera.dataSource = self;
    }
    return _mCamera ;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    /* 后台监听 */
    [self addObserver];

    [self setupStotSubView];
    
    [self.mCamera startCapture];
    [_mCamera changeSessionPreset:AVCaptureSessionPreset1280x720];
    
}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_photoBtn photoButtonFinishRecord];
}

#pragma  mark -  UI

-(void)setupStotSubView{
    /* 录制按钮 */
    _photoBtn = [[FUPhotoButton alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
    [_photoBtn setImage:[UIImage imageNamed:@"camera_btn_camera_normal"] forState:UIControlStateNormal];
    if(iPhoneXStyle){
        _photoBtn.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 150 - 50);
    }else{
        _photoBtn.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 120 - 20);
    }
    _photoBtn.delegate = self;
    [self.view addSubview:_photoBtn];
    
}




-(UIImage *)captureImage{
    mCaptureImage = nil;
    semaphore = dispatch_semaphore_create(0);
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return mCaptureImage;
    
}

-(void)updateSubView{
    [super updateSubView];
    _photoBtn.hidden = [[FUManager shareManager] isRuningAitype:FUNamaAITypeBodySkeleton] ? YES:NO;
}



#pragma  mark -  FUHeadButtonViewDelegate


-(void)headButtonViewBackAction:(UIButton *)btn{
    [self.mCamera stopCapture];
    [super headButtonViewBackAction:btn];
}

-(void)headButtonViewSegmentedChange:(UISegmentedControl *)sender{
    _mCamera.captureFormat = _mCamera.captureFormat == kCVPixelFormatType_32BGRA ? kCVPixelFormatType_420YpCbCr8BiPlanarFullRange:kCVPixelFormatType_32BGRA;
}


-(void)headButtonViewSwitchAction:(UIButton *)sender{
    sender.userInteractionEnabled = NO ;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
        sender.userInteractionEnabled = YES ;
    });
     
     [self.mCamera changeCameraInputDeviceisFront:sender.selected];
     sender.selected = !sender.selected ;
    fuHumanProcessorReset();
    /**切换摄像头要调用此函数*/
    [FURenderer onCameraChange];
}



#pragma mark -  PhotoButtonDelegate

/*  拍照  */
- (void)takePhoto{
    //拍照效果
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
    
    
    UIImage *image = [self captureImage];
    if (image) {
        [self takePhotoToSave:image];
    }
}

-(void)takePhotoToSave:(UIImage *)image{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

/*  开始录像    */
- (void)startRecord {
    [self.mCamera startRecord];
}

/*  停止录像    */
- (void)stopRecord {
       __weak typeof(self)weakSelf  = self ;
    [self.mCamera stopRecordWithCompletionHandler:^(NSString *videoPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UISaveVideoAtPathToSavedPhotosAlbum(videoPath, weakSelf, @selector(video:didFinishSavingWithError:contextInfo:), NULL);
        });
    }];
}


- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    if(error != NULL){
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"保存图片失败", nil)];
    }else{
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"图片已保存到相册", nil)];
    }
    [SVProgressHUD dismissWithDelay:1.5f];
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(error != NULL){
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"保存视频失败", nil)];
        
    }else{
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"视频已保存到相册", nil)];
    }
    [SVProgressHUD dismissWithDelay:1.5f];
}


- (void)dismissTipLabel
{
    self.tipLabel.hidden = YES;
}

#pragma mark - FUCameraDelegate

-(void)didOutputVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    [super didOutputVideoSampleBuffer:sampleBuffer];
    
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) ;
    /* 拍照抓图 */
    if (!mCaptureImage && semaphore) {
        mCaptureImage = [FUImageHelper imageFromPixelBuffer:pixelBuffer];
        dispatch_semaphore_signal(semaphore);
    }
}

#pragma mark -  Observer

- (void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)willResignActive{
    if (self.navigationController.visibleViewController == self) {
        [self.mCamera stopCapture];
//        self.mCamera = nil;
    }
}


- (void)didBecomeActive{
    if (self.navigationController.visibleViewController == self) {
        [self.mCamera startCapture];
    }
}



@end
