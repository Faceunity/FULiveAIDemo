//
//  FUVideoViewController.m
//  FUAlgorithmDemo
//
//  Created by 项林平 on 2021/7/26.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import "FUVideoViewController.h"

#import <Masonry.h>
#import <SVProgressHUD.h>
#import <FURenderKit/FUVideoProcessor.h>

static inline NSString * kFUVideoDestinationPath(void) {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"finalVideo.mp4"];
}

@interface FUVideoViewController ()<FUVideoReaderDelegate>

/// 保存视频按钮
@property (nonatomic, strong) UIButton *saveVideoButton;
/// 重新播放按钮
@property (nonatomic, strong) UIButton *playButton;

@property (nonatomic, strong) FUVideoProcessor *videoProcessor;

//@property (nonatomic, strong) FUVideoReader *videoReader;

//@property (nonatomic, strong) AVPlayer *avPlayer;

@end

@implementation FUVideoViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headButtonView.switchBtn.hidden  = YES;
    self.headButtonView.bulyBtn.hidden = YES;
    
    self.renderView.contentMode = FUGLDisplayViewContentModeScaleAspectFit;
    
    self.buglyLabel.hidden = YES;
    
    [self.view addSubview:self.saveVideoButton];
    [self.saveVideoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(- 50);
        } else {
            make.bottom.equalTo(self.view.mas_bottom).mas_offset(-50);
        }
        make.size.mas_offset(CGSizeMake(75, 75));
    }];
    
    [self.view addSubview:self.playButton];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_offset(CGSizeMake(80, 80));
    }];
    
//    [self playAction];
}

- (void)dealloc {
    NSLog(@"dealloc");
}

#pragma mark - Private methods

/// 播放音频
//- (void)startAudio {
//    if (_avPlayer) {
//        [_avPlayer pause];
//        _avPlayer = nil ;
//    }
//    _avPlayer = [[AVPlayer alloc] init];
//    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:self.videoURL];
//    [_avPlayer replaceCurrentItemWithPlayerItem:item];
//    _avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
//    [_avPlayer play];
//}


/// 读取视频
- (void)startVideo {
    self.videoProcessor = [[FUVideoProcessor alloc] initWithReadingURL:self.videoURL  writingURL:[NSURL fileURLWithPath:kFUVideoDestinationPath()]];
    @FUWeakify(self)
    self.videoProcessor.processingVideoBufferHandler = ^CVPixelBufferRef _Nonnull(CVPixelBufferRef  _Nonnull videoPixelBuffer, CGFloat time) {
        @FUStrongify(self)
        videoPixelBuffer = [self processVideoPixelBuffer:videoPixelBuffer];
        [self.renderView displayPixelBuffer:videoPixelBuffer];
        return videoPixelBuffer;
    };

    self.videoProcessor.processingFinishedHandler = ^{
        @FUStrongify(self)
        [self videoReaderDidFinishReading];
    };

    [self.videoProcessor startProcessing];
    
//    FUVideoReaderSettings *settings = [[FUVideoReaderSettings alloc] init];
//    settings.readingAutomatically = YES;
//    settings.videoOutputFormat = kCVPixelFormatType_32BGRA;
//    self.videoReader = [[FUVideoReader alloc] initWithURL:self.videoURL settings:settings];
//    self.videoReader.delegate = self;
    self.renderView.orientation = (int)self.videoProcessor.reader.videoOrientation;
//    [self.videoReader start];
}

#pragma mark - Event response

- (void)playAction {
    self.playButton.hidden = YES;
    self.saveVideoButton.hidden = YES;
    self.playButton.selected = YES;
    
//    [self startAudio];
    [self startVideo];
}

- (void)saveVideoAction {
    UISaveVideoAtPathToSavedPhotosAlbum(kFUVideoDestinationPath(), self, @selector(video:didFinishSavingWithError:contextInfo:), NULL);
    self.saveVideoButton.hidden = YES;
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"保存视频失败", nil)];
    } else {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"视频已保存到相册", nil)];
    }
    [SVProgressHUD dismissWithDelay:1.5f];
}

- (void)headButtonViewBackAction:(UIButton *)btn {
    [super headButtonViewBackAction:btn];
    [self.videoProcessor cancelProcessing];
//    [self.videoReader stop];
}

- (CVPixelBufferRef)processVideoPixelBuffer:(CVPixelBufferRef)videoPixelBuffer {
    @autoreleasepool {
        FURenderInput *input = [[FURenderInput alloc] init];
        input.pixelBuffer = videoPixelBuffer;
        input.renderConfig.imageOrientation = FUImageOrientationUP;
        switch (self.videoProcessor.reader.videoOrientation) {
            case FUVideoOrientationPortrait:
                input.renderConfig.imageOrientation = FUImageOrientationUP;
                break;
            case FUVideoOrientationLandscapeRight:
                input.renderConfig.imageOrientation = FUImageOrientationLeft;
                break;
            case FUVideoOrientationUpsideDown:
                input.renderConfig.imageOrientation = FUImageOrientationDown;
                break;
            case FUVideoOrientationLandscapeLeft:
                input.renderConfig.imageOrientation = FUImageOrientationRight;
                break;
        }
        FURenderOutput *output = [[FURenderKit shareRenderKit] renderWithInput:input];
        videoPixelBuffer = output.pixelBuffer;
    }
    return videoPixelBuffer;
}

#pragma mark - FUVideoReaderDelegate

//- (void)videoReaderDidOutputVideoSampleBuffer:(CMSampleBufferRef)videoSampleBuffer {
//    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(videoSampleBuffer);
//    FURenderInput *input = [[FURenderInput alloc] init];
//    input.pixelBuffer = pixelBuffer;
//    input.renderConfig.imageOrientation = 0;
//    switch (self.videoReader.videoOrientation) {
//        case FUVideoOrientationPortrait:
//            input.renderConfig.imageOrientation = FUImageOrientationUP;
//            break;
//        case FUVideoOrientationLandscapeRight:
//            input.renderConfig.imageOrientation = FUImageOrientationLeft;
//            break;
//        case FUVideoOrientationUpsideDown:
//            input.renderConfig.imageOrientation = FUImageOrientationDown;
//            break;
//        case FUVideoOrientationLandscapeLeft:
//            input.renderConfig.imageOrientation = FUImageOrientationRight;
//            break;
//        default:
//            input.renderConfig.imageOrientation = FUImageOrientationUP;
//            break;
//    }
//    FURenderOutput *output = [[FURenderKit shareRenderKit] renderWithInput:input];
//    [self.renderView displayPixelBuffer:output.pixelBuffer];
//    CMSampleBufferInvalidate(videoSampleBuffer);
//    CFRelease(videoSampleBuffer);
//}

//- (CVPixelBufferRef)videoReaderDidReadVideoBuffer:(CVPixelBufferRef)pixelBuffer {
//    FURenderInput *input = [[FURenderInput alloc] init];
//    input.pixelBuffer = pixelBuffer;
//    input.renderConfig.imageOrientation = 0;
//    switch (self.videoReader.videoOrientation) {
//        case FUVideoOrientationPortrait:
//            input.renderConfig.imageOrientation = FUImageOrientationUP;
//            break;
//        case FUVideoOrientationLandscapeRight:
//            input.renderConfig.imageOrientation = FUImageOrientationLeft;
//            break;
//        case FUVideoOrientationUpsideDown:
//            input.renderConfig.imageOrientation = FUImageOrientationDown;
//            break;
//        case FUVideoOrientationLandscapeLeft:
//            input.renderConfig.imageOrientation = FUImageOrientationRight;
//            break;
//        default:
//            input.renderConfig.imageOrientation = FUImageOrientationUP;
//            break;
//    }
//    FURenderOutput *output = [[FURenderKit shareRenderKit] renderWithInput:input];
//    [self.renderView displayPixelBuffer:output.pixelBuffer];
//    return output.pixelBuffer;
//}

- (void)videoReaderDidFinishReading {
    [self.videoProcessor cancelProcessing];
//    [self.avPlayer pause];
    //[self.videoReader startReadForLastFrame];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.playButton.hidden = NO;
        self.saveVideoButton.hidden = NO;
    });
}

#pragma mark - Getters

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"play_icon"] forState:UIControlStateNormal];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"replay_icon"] forState:UIControlStateSelected];
//        _playButton.hidden = YES;
        [_playButton addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (UIButton *)saveVideoButton {
    if (!_saveVideoButton) {
        _saveVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveVideoButton setBackgroundImage:[UIImage imageNamed:@"demo_btn_save"] forState:UIControlStateNormal];
        _saveVideoButton.hidden = YES;
        [_saveVideoButton addTarget:self action:@selector(saveVideoAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveVideoButton;
}

@end
