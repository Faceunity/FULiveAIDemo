//
//  AppDelegate.m
//  FUAlgorithmDemo
//
//  Created by 孙慕 on 2020/5/20.
//  Copyright © 2020 孙慕. All rights reserved.
//

#import "AppDelegate.h"
#import "FUManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [UIApplication sharedApplication].statusBarHidden = YES;
    [FUManager shareManager];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    return YES;
}




@end
