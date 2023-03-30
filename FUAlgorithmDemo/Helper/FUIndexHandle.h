//
//  FUTongueHandle.h
//  FUAlgorithmDemo
//
//  Created by 孙慕 on 2020/8/10.
//  Copyright © 2020 孙慕. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUIndexHandle : NSObject

+ (int)aiGestureIndexWithType:(FUAIGESTURETYPE)type;

+ (int)aiTougueIndexWithType:(FUAITONGUETYPE)type;

+ (NSArray *)aiExpressionArray:(int)type;

+ (NSArray *)aiEmotionArray:(int)type;

@end

NS_ASSUME_NONNULL_END
