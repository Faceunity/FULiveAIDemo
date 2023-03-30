//
//  FUPhotoViewController.m
//  FUAlgorithmDemo
//
//  Created by 孙慕 on 2020/5/26.
//  Copyright © 2020 孙慕. All rights reserved.
//

#import "FUPhotoViewController.h"

#import "FUManager.h"
#import "FUIndexHandle.h"
#import "UIViewController+CWLateralSlide.h"

#import <SVProgressHUD.h>
#import <Masonry.h>

@interface FUPhotoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

/// 定时器
@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, strong) NSOperationQueue *renderOperationQueue;
/// 保存图片按钮
@property (nonatomic, strong) UIButton *savePhotoButton;

@property (nonatomic, assign) BOOL savePhoto;

@end

@implementation FUPhotoViewController {
    FUImageBuffer currentImageBuffer;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [FUAIKit shareKit].faceProcessorDetectMode = FUFaceProcessorDetectModeImage;
    
    self.displayLink.paused = NO;
    
    self.headButtonView.switchBtn.hidden  = YES;
    self.headButtonView.bulyBtn.hidden = YES;
    
    self.renderView.contentMode = FUGLDisplayViewContentModeScaleAspectFit;
    
    [self.view addSubview:self.savePhotoButton];
    [self.savePhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(-105);
        } else {
            make.bottom.equalTo(self.view.mas_bottom).mas_offset(-105);
        }
        make.size.mas_offset(CGSizeMake(75, 75));
    }];
    
    self.buglyLabel.hidden = YES;
    
}

- (void)dealloc {
    if (&currentImageBuffer != NULL) {
        [UIImage freeImageBuffer:&currentImageBuffer];
    }
}

#pragma mark - Process image

- (void)displayLinkAction{
    if (!self.photoImage) {
        return;
    }
    [self.renderOperationQueue addOperationWithBlock:^{
        [FUConfigManager resetHumanProcessor];
        @autoreleasepool {//防止大图片，内存峰值过高
            self->currentImageBuffer = [self.photoImage getImageBuffer];
            FURenderInput *input = [[FURenderInput alloc] init];
            switch (self.photoImage.imageOrientation) {
                case UIImageOrientationUp:
                case UIImageOrientationUpMirrored:
                    input.renderConfig.imageOrientation = FUImageOrientationUP;
                    break;
                case UIImageOrientationLeft:
                case UIImageOrientationLeftMirrored:
                    input.renderConfig.imageOrientation = FUImageOrientationRight;
                    break;
                case UIImageOrientationDown:
                case UIImageOrientationDownMirrored:
                    input.renderConfig.imageOrientation = FUImageOrientationDown;
                    break;
                case UIImageOrientationRight:
                case UIImageOrientationRightMirrored:
                    input.renderConfig.imageOrientation = FUImageOrientationLeft;
                    break;
            }
            input.imageBuffer = self->currentImageBuffer;
            FURenderOutput *output =  [[FURenderKit shareRenderKit] renderWithInput:input];
            self->currentImageBuffer = output.imageBuffer;
            [self refreshOutputVideo];
            [self.renderView displayImageData:self->currentImageBuffer.buffer0 withSize:self->currentImageBuffer.size];
            if (self.savePhoto) {
                UIImage *newImage = [UIImage imageWithRGBAImageBuffer:&self->currentImageBuffer autoFreeBuffer:NO];
                self.savePhoto = NO;
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                });
            }
            [UIImage freeImageBuffer:&self->currentImageBuffer];
        }
    }];
}

-(void)headButtonViewBackAction:(UIButton *)btn{
    [super headButtonViewBackAction:btn];
    _displayLink.paused = YES;
    [_displayLink invalidate];
    _displayLink = nil;
    [self.renderOperationQueue cancelAllOperations];
}

#pragma mark - Event response

-(void)savePictureAction:(UIButton *)btn{
    _savePhoto = YES;
}

/// 图片保存成功
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"保存图片失败", nil)];
    } else {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"图片已保存到相册", nil)];
    }
    [SVProgressHUD dismissWithDelay:1.5f];
}

#pragma mark - Getters

-(CADisplayLink *)displayLink {
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [_displayLink setFrameInterval:10];
        _displayLink.paused = NO;
    }
    return _displayLink;
}

- (NSOperationQueue *)renderOperationQueue {
    if (!_renderOperationQueue) {
        _renderOperationQueue = [[NSOperationQueue alloc] init];
        _renderOperationQueue.maxConcurrentOperationCount = 1;
    }
    return _renderOperationQueue;
}


- (UIButton *)savePhotoButton {
    if (!_savePhotoButton) {
        _savePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_savePhotoButton setBackgroundImage:[UIImage imageNamed:@"demo_btn_save"] forState:UIControlStateNormal];
        [_savePhotoButton addTarget:self action:@selector(savePictureAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _savePhotoButton;
}

@end
