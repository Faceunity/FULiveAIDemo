//
//  FUAIConfig.h
//  FUAlgorithmDemo
//
//  Created by 孙慕 on 2020/6/5.
//  Copyright © 2020 孙慕. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUAIConfig : NSObject

@property (assign, nonatomic) FUMoudleType moudleType;
@property (nonatomic, strong) NSArray <FUAIConfigCellModel *>* aiMenu;


@end

NS_ASSUME_NONNULL_END
