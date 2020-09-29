//
//  FUTongueView.h
//  FUAlgorithmDemo
//
//  Created by 孙慕 on 2020/8/4.
//  Copyright © 2020 孙慕. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUTongueViewCell : UITableViewCell
//@property (strong, nonatomic) UIImageView *mImageV;
@end


@interface FUTongueView : UIView

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSArray<NSString *>*>*)iamges;

-(void)setTongueViewSel:(int)selIndex;

@end


NS_ASSUME_NONNULL_END
