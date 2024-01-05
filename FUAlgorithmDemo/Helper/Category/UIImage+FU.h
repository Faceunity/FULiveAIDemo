//
//  UIImage+FU.h
//  FULiveDemo
//
//  Created by 项林平 on 2021/6/21.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FUPicturePixelMaxSize ([FURenderKit devicePerformanceLevel] >= FUDevicePerformanceLevelHigh ? 12746752 : 5760000)

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (FU)

/// 压缩图片
/// @param ratio 倍率
- (UIImage *)fu_compress:(CGFloat)ratio;

/// 图片转正
- (UIImage *)fu_resetImageOrientationToUp;

/// 图片处理
- (UIImage *)fu_processedImage;

@end

NS_ASSUME_NONNULL_END
