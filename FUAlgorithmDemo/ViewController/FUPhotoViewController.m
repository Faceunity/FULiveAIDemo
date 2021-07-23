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

@interface FUPhotoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
        dispatch_queue_t renderQueue;
}

/// 定时器
@property (nonatomic, strong) CADisplayLink *displayLink;
/// 保存图片按钮
@property (nonatomic, strong) UIButton *savePhotoButton;

@property (nonatomic, assign) BOOL savePhoto;

@end

@implementation FUPhotoViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    renderQueue = dispatch_queue_create("com.face.render", DISPATCH_QUEUE_SERIAL);
    
    self.displayLink.paused = NO;
    
    self.headButtonView.switchBtn.hidden  = YES;
    self.headButtonView.bulyBtn.hidden = YES;
    
    self.renderView.contentMode = FUGLDisplayViewContentModeScaleAspectFit;
    
    [self.view addSubview:self.savePhotoButton];
    
    self.buglyLabel.hidden = YES;
    
}

#pragma mark - Process image

- (void)displayLinkAction{
    if (!self.photoImage) {
        return;
    }
    dispatch_async(renderQueue, ^{
        @autoreleasepool {//防止大图片，内存峰值过高
            FUImageBuffer imageBuffer = [self.photoImage getImageBuffer];
            FURenderInput *input = [[FURenderInput alloc] init];
            input.renderConfig.imageOrientation = 0;
            switch (self.photoImage.imageOrientation) {
                case UIImageOrientationUp:
                    input.renderConfig.imageOrientation = FUImageOrientationUP;
                    break;
                case UIImageOrientationLeft:
                    input.renderConfig.imageOrientation = FUImageOrientationRight;
                    break;
                case UIImageOrientationDown:
                    input.renderConfig.imageOrientation = FUImageOrientationDown;
                    break;
                case UIImageOrientationRight:
                    input.renderConfig.imageOrientation = FUImageOrientationLeft;
                    break;
                default:
                    input.renderConfig.imageOrientation = FUImageOrientationUP;
                    break;
            }
            input.imageBuffer = imageBuffer;
            FURenderOutput *output =  [[FURenderKit shareRenderKit] renderWithInput:input];
            
            [self refreshOutputVideo];
               
            [self.renderView displayImageData:imageBuffer.buffer0 withSize:imageBuffer.size];
            
            if (self.savePhoto) {
                imageBuffer = output.imageBuffer;
                UIImage *newImage = [UIImage imageWithRGBAImageBuffer:&imageBuffer autoFreeBuffer:NO];
                self.savePhoto = NO;
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                });
            }
            [UIImage freeImageBuffer:&imageBuffer];
        }
    });
}

-(void)headButtonViewBackAction:(UIButton *)btn{
    [super headButtonViewBackAction:btn];
    [_displayLink invalidate];
    _displayLink = nil;
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

- (UIButton *)savePhotoButton {
    if (!_savePhotoButton) {
        _savePhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
        [_savePhotoButton setImage:[UIImage imageNamed:@"demo_btn_save"] forState:UIControlStateNormal];
        [_savePhotoButton addTarget:self action:@selector(savePictureAction:) forControlEvents:UIControlEventTouchUpInside];
        if(FUiPhoneXStyle()){
            _savePhotoButton.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 150 - 50);
        }else{
            _savePhotoButton.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 120 - 20);
        }
    }
    return _savePhotoButton;
}

@end
