//
//  FUActionModel.h
//  FUAlgorithmDemo
//
//  Created by 孙慕 on 2020/5/29.
//  Copyright © 2020 孙慕. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUActionModel : NSObject{
    float *ref_pos;
}
@property (nonatomic, copy) NSString* image;
@property (nonatomic, strong) NSArray *joint2ds;


-(float *)getRefpos;

@end

NS_ASSUME_NONNULL_END
