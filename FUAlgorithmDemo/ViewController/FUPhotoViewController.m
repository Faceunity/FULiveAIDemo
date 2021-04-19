//
//  FUPhotoViewController.m
//  FUAlgorithmDemo
//
//  Created by 孙慕 on 2020/5/26.
//  Copyright © 2020 孙慕. All rights reserved.
//

#import "FUPhotoViewController.h"
#import "FUManager.h"
#import "FUGestureHandle.h"
#import <SVProgressHUD.h>
#import "UIViewController+CWLateralSlide.h"
#import "FUConfigController.h"
#import "FUIndexHandle.h"

@interface FUPhotoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
        __block BOOL takePic ;
        dispatch_queue_t renderQueue;
}

// 定时器
@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, strong) UIButton *photoBtn;

@end

@implementation FUPhotoViewController

-(CADisplayLink *)displayLink{
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [_displayLink setFrameInterval:10];
        _displayLink.paused = NO;
    }
    
    return _displayLink;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    renderQueue = dispatch_queue_create("com.face.render", DISPATCH_QUEUE_SERIAL);
    
    self.displayLink.paused = NO;
    
    self.headButtonView.switchBtn.hidden  = YES;
    self.headButtonView.bulyBtn.hidden = YES;
    
    self.renderView.contentMode = FUOpenGLViewContentModeScaleAspectFit;
    self.renderView.backgroundColor = [UIColor blackColor];
    
        /* 录制按钮 */
    _photoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
    [_photoBtn setImage:[UIImage imageNamed:@"demo_btn_save"] forState:UIControlStateNormal];
    [_photoBtn addTarget:self action:@selector(takePictureAction:) forControlEvents:UIControlEventTouchUpInside];
    if(iPhoneXStyle){
        _photoBtn.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 150 - 50);
    }else{
        _photoBtn.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 120 - 20);
    }
    [self.view addSubview:_photoBtn];
    
    self.buglyLabel.hidden = YES;
    
}

#pragma  mark ---- process image

- (void)displayLinkAction{
    __weak typeof(self)weakSelf  = self ;
    if (!self.mPotoImage) {
        return;
    }
    dispatch_async(renderQueue, ^{
    @autoreleasepool {//防止大图片，内存峰值过高
        [[FURenderer shareRenderer] setUpCurrentContext];
        
        __weak typeof(self)weakSelf  = self ;
                int width = (int)CGImageGetWidth(self->_mPotoImage.CGImage);
        int height = (int)CGImageGetHeight(self->_mPotoImage.CGImage);
        CFDataRef dataFromImageDataProvider = CGDataProviderCopyData(CGImageGetDataProvider(self->_mPotoImage.CGImage));
        GLubyte *imageData = (GLubyte *)CFDataGetBytePtr(dataFromImageDataProvider);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tipLabel.text = [FUManager shareManager].currentToast;
          });
        
        if([[FUManager shareManager] isRuningAitype:FUNamaAITypeBodySkeleton]) {//骨骼....
            [[FUManager shareManager] renderItemsWithPtaImageData:imageData w:width h:height];
          }else{
            [[FUManager shareManager] renderImageData:imageData w:width h:height];
          }
           
        
    if(([[FUManager shareManager] isRuningAitype:FUNamaAITypeKeypoint] && ![[FUManager shareManager] isRuningAitype:FUNamaAITypeActionRecognition] && ![[FUManager shareManager] isRuningAitype:FUNamaAITypeActionRecognition] && ![[FUManager shareManager] isRuningAitype:FUNamaAITypegestureRecognition] && !([[FUManager shareManager] isRuningAitype:FUNamaAITypeBodyKeyPoints] || [[FUManager shareManager] isRuningAitype:FUNamaAITypePortraitSegmentation])) || [[FUManager shareManager] isRuningAitype:FUNamaAITypeHeadSplit] || [[FUManager shareManager] isRuningAitype:FUNamaAITypeHairSplit]){
            BOOL isTrack = [FURenderer isTracking] > 0?YES:NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.tipLabel.text || !self.tipLabel.hidden) {
                        self.tipLabel.hidden = isTrack;
                    }
            });
        }
           
         if([[FUManager shareManager] isRuningAitype:FUNamaAITypegestureRecognition]) {//手势识别中....
                __weak typeof(self)weakSelf  = self ;
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
                        BOOL isTrackFace = [FURenderer isTracking] > 0?YES:NO;
                           [weakSelf.mGestureView setGestureViewSel:-1];;
                           if (isTrackFace && [[FUManager shareManager] isRuningAitype:FUNamaAITypeKeypoint]){
                               self.tipLabel.hidden = YES;
                           }else{
                               if (self.tipLabel.text) {
                                   self.tipLabel.hidden = NO;
                               }
                           }
                    });
                }
            }
            
            if([[FUManager shareManager] isRuningAitype:FUNamaAITypeBodySkeleton]) {//骨骼....
                BOOL isTrack = fuHumanProcessorGetNumResults() > 0?YES:NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.tipLabel.text || !self.tipLabel.hidden) {
                     self.tipLabel.hidden = isTrack;
                    }
                  });

            }
            if([[FUManager shareManager] isRuningAitype:FUNamaAITypeActionRecognition]){//动作
                __weak typeof(self)weakSelf  = self ;
                
                BOOL isTrack = fuHumanProcessorGetNumResults() > 0?YES:NO;
                BOOL isTrackFace = [FURenderer isTracking] > 0?YES:NO;
                
                 if(isTrack){
                    int  index = fuHumanProcessorGetResultActionType(0);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.mActionView setGestureViewSel:index];
                    });

                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.mActionView setGestureViewSel:-1];
                    });
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isTrack || isTrackFace) {
                        self.tipLabel.hidden = YES;
                    }else{
                        if (self.tipLabel.text || !self.tipLabel.hidden ) {
                         self.tipLabel.hidden = isTrack;
                      }
                    }
                });
            }
            
            if([[FUManager shareManager] isRuningAitype:FUNamaAITypeBodyKeyPoints] || [[FUManager shareManager] isRuningAitype:FUNamaAITypePortraitSegmentation]){//人体
                BOOL isTrack = fuHumanProcessorGetNumResults() > 0?YES:NO;
                BOOL isTrackFace = [FURenderer isTracking] > 0?YES:NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isTrack || isTrackFace) {
                        self.tipLabel.hidden = YES;
                    }else{
                        if (self.tipLabel.text || !self.tipLabel.hidden ) {
                         self.tipLabel.hidden = isTrack;
                      }
                    }
                  });
            }
            
            if([[FUManager shareManager] isRuningAitype:FUNamaAITypeTongue]){
                BOOL isTrack = [FURenderer isTracking] > 0?YES:NO;
                int tongue_direction = 0;
                [FURenderer getFaceInfo:0 name:@"tongue_direction" pret:&tongue_direction number:1];
                int index = [FUIndexHandle getAItougueIndexwith:tongue_direction];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(isTrack){
                        [self.mTongueView setTongueViewSel:index];
                    }else{
                        [self.mTongueView setTongueViewSel:-1];
                    }
                });
            }
            
            if([[FUManager shareManager] isRuningAitype:FUNamaAITypeExpression]){
                    int expression_type = 0;
                    [FURenderer getFaceInfo:0 name:@"expression_type" pret:&expression_type number:1];
                    NSArray *array = [FUIndexHandle getAarrayAIexpression:expression_type];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.mExpresionView setExpresionViewSelArray:array];
                        
                    });
            }
        
        if([[FUManager shareManager] isRuningAitype:FUNamaAITypeEmotionRecognition]){
                int emotion = 0;
                [FURenderer getFaceInfo:0 name:@"emotion" pret:&emotion number:1];
            
                NSArray *array = [FUIndexHandle getAarrayAIemotion:emotion];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mEmotionView setViewSelArray:array];
                });
        }


        [weakSelf.renderView displayImageData:imageData Size:CGSizeMake(width, height) Landmarks:NULL count:0 zoomScale:1];
        
        [[FURenderer shareRenderer] setBackCurrentContext];
        if (self->takePic) {
            self->takePic = NO ;
            UIImage *newImage =  [self convertBitmapRGBA8ToUIImage:imageData withWidth:width withHeight:height];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                if (self->_mPotoImage) {
                    UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                }
            });
        }
        
        CFRelease(dataFromImageDataProvider);
    }
    });
}

-(void)headButtonViewBackAction:(UIButton *)btn{
    [super headButtonViewBackAction:btn];
    [_displayLink invalidate];
    _displayLink = nil;
}



#pragma  mark -  UI action


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
        if(model.moudleType == FUMoudleTypeBody){//图片处理，人体只需关键点
            NSArray *newArray = [NSArray arrayWithObjects:model.aiMenu[0], nil];
            model.aiMenu = newArray;
        }
        [configs addObject:[model copy]];
    }
    vc.config = configs;
    CWLateralSlideConfiguration *config = [CWLateralSlideConfiguration configurationWithDistance:kCWSCREENWIDTH * 0.75 maskAlpha:0.4 scaleY:1.0 direction:CWDrawerTransitionFromRight backImage:nil];
    [self cw_showDrawerViewController:vc animationType:CWDrawerAnimationTypeDefault configuration:config];
    
    vc.weakVC = self;
}

-(void)takePictureAction:(UIButton *)btn{
    self->takePic = YES;
}


/* 保存成功 */
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    if(error != NULL){
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"保存图片失败", nil)];
    }else{
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"图片已保存到相册", nil)];
    }
    [SVProgressHUD dismissWithDelay:1.5f];
}



-(void)showTip:(NSString *)str{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tipLabel.hidden = str == nil;
        [FUPhotoViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissTipLabel) object:nil];
        [self performSelector:@selector(dismissTipLabel) withObject:nil afterDelay:1];
    });
}

- (void)dismissTipLabel
{
    self.tipLabel.hidden = YES;
}


- (UIImage *) convertBitmapRGBA8ToUIImage:(unsigned char *) buffer
                                withWidth:(int) width
                               withHeight:(int) height{
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(buffer,
                                                 width,
                                                 height,
                                                 8,
                                                 width * 4,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast);
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}

@end
