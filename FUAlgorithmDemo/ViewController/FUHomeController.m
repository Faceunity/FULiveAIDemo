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
#import <MobileCoreServices/MobileCoreServices.h>
#import <SVProgressHUD.h>

@interface FUHomeController ()
@property (weak, nonatomic) IBOutlet UIView *tapView1;
@property (weak, nonatomic) IBOutlet UIView *tapView2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mLayoutConstraintH;

@end

@implementation FUHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _mLayoutConstraintH.constant = 1/[UIScreen mainScreen].scale;
    
    self.tapView1.layer.cornerRadius = 8;
    self.tapView2.layer.cornerRadius = 8;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchesView1)];
    [self.tapView1 addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchesView2)];
    [self.tapView2 addGestureRecognizer:tapGesture2];    
    
}

-(void)touchesView1{
    
    FUShotViewController *vc = [[FUShotViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    
    [UIView animateWithDuration:0.025 animations:^{
        self.tapView1.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.025 animations:^{
                self.tapView1.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {

               [self.navigationController pushViewController:vc animated:YES];
            }];
    }];

}

-(void)touchesView2{

    [UIView animateWithDuration:0.1 animations:^{
        self.tapView2.transform = CGAffineTransformMakeScale(0.8, 0.8);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.tapView2.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                 [self showImagePickerWithMediaType:(NSString *)kUTTypeImage];
            }];
    }];

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
    [picker dismissViewControllerAnimated:NO completion:^{
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        
        if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){  //视频
            
        }else if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) { //照片
            
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            
            // 图片转正
            if (image.imageOrientation != UIImageOrientationUp && image.imageOrientation != UIImageOrientationUpMirrored) {
                
                UIGraphicsBeginImageContext(CGSizeMake(image.size.width*0.5, image.size.height*0.5));
                
                [image drawInRect:CGRectMake(0, 0, image.size.width*0.5, image.size.height*0.5)];
                
                image = UIGraphicsGetImageFromCurrentImageContext();
                
                UIGraphicsEndImageContext();
            }
            
            NSData *imageData0 = UIImageJPEGRepresentation(image, 1.0);
            
            FUPhotoViewController *vc = [[FUPhotoViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            vc.mPotoImage = [UIImage imageWithData:imageData0];
    
        }
    }];
    
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
