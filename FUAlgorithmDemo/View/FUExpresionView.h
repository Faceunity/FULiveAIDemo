//
//  FUExpresionView.h
//  FUAlgorithmDemo
//
//  Created by 孙慕 on 2020/8/4.
//  Copyright © 2020 孙慕. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUExpresionCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView *mImageV;
@property (nonatomic, strong) UILabel *titleLabel ;
@end


@interface FUExpresionView : UIView

-(instancetype)initWithFrame:(CGRect)frame images:(NSArray<NSString *>*)iamges;

//-(void)setExpresionViewSel:(int)selIndex;
-(void)setExpresionViewSelArray:(NSArray *)array;
@end

NS_ASSUME_NONNULL_END
