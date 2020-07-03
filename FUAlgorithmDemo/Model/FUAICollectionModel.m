//
//  FUAIConfig.m
//  FUAlgorithmDemo
//
//  Created by 孙慕 on 2020/5/22.
//  Copyright © 2020 孙慕. All rights reserved.
//

#import "FUAICollectionModel.h"
#import "MJExtension.h"

@implementation FUAIConfigCellModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"bundleNames" : @"NSString",
             @"subFootes" :@"NSString",
             @"mToasts" :@"NSString"
             };
}


-(id)copyWithZone:(NSZone *)zone{
    FUAIConfigCellModel *modle = [[FUAIConfigCellModel alloc] init];
    modle.aiMenuTitel = self.aiMenuTitel;
    modle.bundleNames = self.bundleNames;
    modle.bindItemNames = self.bindItemNames;
    modle.sectionImageName = self.sectionImageName;
    modle.state = self.state;
    modle.aiType = self.aiType;
    modle.footSelInde = self.footSelInde;
    modle.subFootes = self.subFootes;
    modle.mToasts = self.mToasts;
    
    return modle;
}


@end


@implementation FUAISectionModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"aiMenu" : @"FUAIConfigCellModel",
             @"foot"   : @"FUAIConfigfootModel",
             };
}


-(id)copyWithZone:(NSZone *)zone{
    
    FUAISectionModel *mode = [[FUAISectionModel alloc] init];
    mode.sectionTitel = self.sectionTitel;
    mode.sectionImageName = self.sectionImageName;
    mode.moudleType = self.moudleType;
    NSMutableArray *tempArray = [NSMutableArray array];
    for (FUAIConfigCellModel *modle in self.aiMenu) {
        [tempArray addObject:[modle copy]];
    }
    mode.aiMenu = tempArray;
    
    return mode;
}




@end
