//
//  FUTongueHandle.h
//  FUAlgorithmDemo
//
//  Created by 孙慕 on 2020/8/10.
//  Copyright © 2020 孙慕. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CNamaSDK.h"
NS_ASSUME_NONNULL_BEGIN

@interface FUIndexHandle : NSObject
+(int)getAItougueIndexwith:(FUAITONGUETYPE)type;

+(int)getAIexpressionIndexwith:(FUAIEXPRESSIONTYPE)type;

+(NSArray *)getAarrayAIexpression:(int)type;

+(NSArray *)getAarrayAIemotion:(int)type;
@end

NS_ASSUME_NONNULL_END
