//
//  FUHomeController.m
//  FUAlgorithmDemo
//
//  Created by 孙慕 on 2020/5/20.
//  Copyright © 2020 孙慕. All rights reserved.
//

#import "FUHomeController.h"
#import "FUShotViewController.h"
#import "FUPhotoViewController.h"
#import "FUVideoViewController.h"
#import "UIImage+FU.h"

#import <MobileCoreServices/MobileCoreServices.h>

@interface FUHomeController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *tapView1;
@property (weak, nonatomic) IBOutlet UIView *tapView2;
@property (weak, nonatomic) IBOutlet UIView *tapView3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mLayoutConstraintH;

@end

@implementation FUHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mLayoutConstraintH.constant = 1 / [UIScreen mainScreen].scale;
    
    self.tapView1.layer.cornerRadius = 8;
    self.tapView2.layer.cornerRadius = 8;
    self.tapView3.layer.cornerRadius = 8;
    
    UILongPressGestureRecognizer *tapGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(touchesView1:)];
    tapGesture.minimumPressDuration = 0;
    [self.tapView1 addGestureRecognizer:tapGesture];
    
    UILongPressGestureRecognizer *tapGesture2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(touchesView2:)];
    tapGesture2.minimumPressDuration = 0;
    [self.tapView2 addGestureRecognizer:tapGesture2];
    
    UILongPressGestureRecognizer *tapGesture3 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(touchesView3:)];
    tapGesture3.minimumPressDuration = 0;
    [self.tapView3 addGestureRecognizer:tapGesture3];
    
}

- (void)touchesView1:(UILongPressGestureRecognizer *)tap {
    switch (tap.state) {
        case UIGestureRecognizerStateBegan:{
            self.tapView1.transform = CGAffineTransformMakeScale(0.9, 0.9);
        }
            break;
        case UIGestureRecognizerStateEnded:{
            self.tapView1.transform = CGAffineTransformIdentity;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                FUShotViewController *vc = [[FUShotViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            });
        }
            break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:{
            self.tapView1.transform = CGAffineTransformIdentity;
        }
            break;
        default:
            break;
    }
}

- (void)touchesView2:(UILongPressGestureRecognizer *)tap {
    switch (tap.state) {
        case UIGestureRecognizerStateBegan:{
            self.tapView2.transform = CGAffineTransformMakeScale(0.9, 0.9);
        }
            break;
        case UIGestureRecognizerStateEnded:{
            self.tapView2.transform = CGAffineTransformIdentity;
            [self showImagePickerWithMediaType:(NSString *)kUTTypeImage];
        }
            break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:{
            self.tapView2.transform = CGAffineTransformIdentity;
        }
            break;
        default:
            break;
    }

}

- (void)touchesView3:(UILongPressGestureRecognizer *)tap {
    switch (tap.state) {
        case UIGestureRecognizerStateBegan:{
            self.tapView3.transform = CGAffineTransformMakeScale(0.9, 0.9);
        }
            break;
        case UIGestureRecognizerStateEnded:{
            self.tapView3.transform = CGAffineTransformIdentity;
            [self showImagePickerWithMediaType:(NSString *)kUTTypeMovie];
        }
            break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:{
            self.tapView3.transform = CGAffineTransformIdentity;
        }
            break;
        default:
            break;
    }
}


- (void)showImagePickerWithMediaType:(NSString *)mediaType {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.allowsEditing = NO;
    picker.mediaTypes = @[mediaType] ;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:picker animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // 关闭相册
    [picker dismissViewControllerAnimated:NO completion:nil];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // 图片处理
        image = [image fu_processedImage];
        image = [UIImage imageWithData:UIImageJPEGRepresentation(image, 1)];
        FUPhotoViewController *vc = [[FUPhotoViewController alloc] init];
        vc.photoImage = image;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        // 选择视频
        FUVideoViewController *videoController = [[FUVideoViewController alloc] init];
        videoController.videoURL = info[UIImagePickerControllerMediaURL];
        [self.navigationController pushViewController:videoController animated:YES];
    }
}


@end
