//
//  FUTongueView.h
//  FUAlgorithmDemo
//
//  Created by 孙慕 on 2020/8/4.
//  Copyright © 2020 孙慕. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    FUViewTypeTongue,
    FUViewTypeEmotion,
} FUViewType;

@interface FUTongueViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *itemLabel;
@property (nonatomic, strong) UILabel *detailsLabel;

@end


@interface FUTongueView : UIView

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSArray<NSString *>*>*)iamges;

-(void)setTongueViewSel:(int)selIndex;

-(void)setViewSelArray:(NSArray <NSNumber *>*)array;

-(void)setViewType:(FUViewType)type;

@end


NS_ASSUME_NONNULL_END
