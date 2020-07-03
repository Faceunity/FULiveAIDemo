//
//  FUConfigCell.h
//  FUAlgorithmDemo
//
//  Created by 孙慕 on 2020/5/21.
//  Copyright © 2020 孙慕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUAICollectionModel.h"


NS_ASSUME_NONNULL_BEGIN


@interface FUConfigCell : UICollectionViewCell
@property (strong, nonatomic) UILabel *titleLabel;

@property (assign, nonatomic) FUAICellState state;
@property (strong, nonatomic) FUAIConfigCellModel *model;
@end

NS_ASSUME_NONNULL_END
