//
//  FUManager.h
//  FULiveDemo
//
//  Created by 刘洋 on 2017/8/18.
//  Copyright © 2017年 刘洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "FURenderer.h"
#import "FUAICollectionModel.h"

#import "FUActionModel.h"

@class FULiveModel;


@interface FUManager : NSObject

/* 交互信息 */
@property(nonatomic,strong) NSArray <FUAISectionModel*>*config;
/* 提示 */
@property (nonatomic, copy) NSString *currentToast;
+ (FUManager *)shareManager;

/* 加载道具到内存 */
-(void)loadBoudleWithConfig:(FUAISectionModel *)config;
/* 根据配置添加running的道具 */
-(void)setNeedRenderHandle;
/* 判断是否在运行 */
-(BOOL)isRuningAitype:(FUNamaAIType)aiType;

/* 销毁道具，清除缓存 */
- (void)destoryItems;
/* 清除管理类缓存 */
-(void)clearManagerCache;


/* 将道具绘制到imager */
- (UIImage *)renderItemsToImage:(UIImage *)image;
/**将道具绘制到pixelBuffer*/
- (CVPixelBufferRef)renderItemsToPixelBuffer:(CVPixelBufferRef)pixelBuffer;

- (GLubyte *)renderItemsWithPtaImageData:(GLubyte *)imageData w:(int)w h:(int)h;
-(void)renderItemsWithPtaPixelBuffer:(CVPixelBufferRef)pixelBuffer;
- (GLubyte *)renderImageData:(GLubyte *)imageData w:(int)w h:(int)h;

-(void)setParamItemAboutType:(FUNamaAIType)type name:(NSString *)paramName value:(float)value;

/* 判断屏幕方向是否改变 */
-(BOOL)isDeviceMotionChange;





@end
