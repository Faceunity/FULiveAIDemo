//
//  FUGestureView.h
//  FUAlgorithmDemo
//
//  Created by 孙慕 on 2020/5/25.
//  Copyright © 2020 孙慕. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUGestureCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView *mImageV;
@end

@interface FUGestureView : UIView
-(instancetype)initWithFrame:(CGRect)frame images:(NSArray<NSArray<NSString *>*>*)iamges;

-(void)setGestureViewSel:(int)selIndex;

@end

NS_ASSUME_NONNULL_END
