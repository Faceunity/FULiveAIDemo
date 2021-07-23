//
//  FUMacros.h
//  FUAlgorithmDemo
//
//  Created by 项林平 on 2021/5/19.
//  Copyright © 2021 FaceUnity. All rights reserved.
//

/// 屏幕宽
#define FUScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)

/// 屏幕高
#define FUScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)

/// 是否iPhone X系列机型
static inline BOOL FUiPhoneXStyle() {
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [UIApplication sharedApplication].delegate.window;
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
             return YES;
        }
    }
    return NO;
}
