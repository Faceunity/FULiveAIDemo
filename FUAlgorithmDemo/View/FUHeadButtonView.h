//
//  FUHeadButtonView.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/1/29.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FUHeadButtonViewDelegate <NSObject>

@optional
/* 点击事件 */
-(void)headButtonViewBackAction:(UIButton *)btn;
-(void)headButtonViewMoreAction:(UIButton *)btn;
-(void)headButtonViewBuglyAction:(UIButton *)btn;
-(void)headButtonViewSwitchAction:(UIButton *)btn;

@end

@interface FUHeadButtonView : UIView

@property (strong, nonatomic) UIButton *mHomeBtn;
@property (strong, nonatomic) UIButton *moreBtn;
@property (strong, nonatomic) UIButton *switchBtn;
@property (strong, nonatomic) UIButton *bulyBtn;

@property (weak, nonatomic) id <FUHeadButtonViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
