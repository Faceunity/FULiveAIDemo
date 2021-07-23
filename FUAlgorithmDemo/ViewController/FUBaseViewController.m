//
//  FUBaseViewController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/1/28.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import "FUBaseViewController.h"
#import "FUPhotoViewController.h"

#import "FUGestureView.h"
#import "FUTongueView.h"
#import "FUExpresionView.h"

#import "FUAICollectionModel.h"

#import "FUIndexHandle.h"
#import "UIViewController+CWLateralSlide.h"

#import <MJExtension.h>
#import <Masonry.h>

@interface FUBaseViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) FUHeadButtonView *headButtonView;

@property (nonatomic, strong) FUGLDisplayView *renderView;

@property (nonatomic, strong) FUGestureView *mGestureView;

@property (nonatomic, strong) FUGestureView *mActionView;

@property (nonatomic, strong) FUExpresionView *mExpresionView;

@property (nonatomic, strong) FUTongueView *mTongueView;

@property (nonatomic, strong) FUTongueView *mEmotionView;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UILabel *buglyLabel;

@property (nonatomic, strong) NSMutableArray *dataSource;

/// 未检测到人脸或人体时的提示
@property (nonatomic, copy) NSString *noTrackingString;

@end

@implementation FUBaseViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];

    [self setupSubView];
    [self setupGestureView];
    [self setupExpressionView];
    [self setupTongueView];
    [self setupEmotionView];
    
    // 设置默认运行人脸关键点
    [FUManager shareManager].runningFaceKeypoint = YES;
}



#pragma mark - UI

-(void)setupSubView{
    [self.view addSubview:self.renderView];
    
    [self.view addSubview:self.headButtonView];
    [self.headButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(20);
        } else {
            make.top.equalTo(self.view.mas_top).offset(30);
        }
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    [self.view addSubview:self.buglyLabel];
    [self.buglyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headButtonView.mas_bottom).offset(15);
        make.left.equalTo(self.view).offset(16);
        make.width.mas_equalTo(95);
        make.height.mas_equalTo(150);
    }];
    
    [self.view addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];

}

-(void)setupGestureView{
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, 100);
    if (FUiPhoneXStyle()) {
        frame.origin.y = self.view.frame.size.height - 134;
    }else{
        frame.origin.y = self.view.frame.size.height - 100;
    }
    NSArray *images = @[@[@"demo_gesture_icon_love",@"demo_gesture_icon_one_handed",@"demo_gesture_icon_hands",@"demo_gesture_icon_clenched_fist",@"demo_gesture_icon_hands_together",@"demo_gesture_icon_hands_take_pictures"],@[@"demo_gesture_icon_one",@"demo_gesture_icon_two",@"demo_gesture_icon_three",@"demo_gesture_icon_five",@"demo_gesture_icon_six",@"demo_gesture_icon_zero",@"demo_gesture_icon_palm_up",@"demo_gesture_icon_thumb_up"]];//,@"demo_gesture_icon_hands_crossed"
    _mGestureView = [[FUGestureView alloc] initWithFrame:frame images:images];
    _mGestureView.hidden = YES;
    [self.view addSubview:_mGestureView];
    
    /* 动作 */
    NSArray *images1 = @[@[@"demo_action_icon_0",@"demo_action_icon_1",@"demo_action_icon_2",@"demo_action_icon_3",@"demo_action_icon_4",@"demo_action_icon_5",@"demo_action_icon_6"],@[@"demo_action_icon_7",@"demo_action_icon_8",@"demo_action_icon_9",@"demo_action_icon_10",@"demo_action_icon_11",@"demo_action_icon_12",@"demo_action_icon_13",@"demo_action_icon_14"]];
    _mActionView = [[FUGestureView alloc] initWithFrame:frame images:images1];
    _mActionView.hidden = YES;
    [self.view addSubview:_mActionView];
    
}


-(void)setupExpressionView{
    CGRect frame = CGRectZero;
    
    NSLog(@"%@, %@", @(FUScreenWidth), @(FUScreenHeight));
    
    if (FUiPhoneXStyle()) {
        frame = CGRectMake(FUScreenWidth - 56, 88 + 34, 40, 460);
    } else {
        frame = CGRectMake(FUScreenWidth - 56, 88, 40, 460);
    }
    NSArray *images = @[@"demo_expression_icon_raise_eyebrows",@"demo_expression_icon_frown",@"demo_expression_icon_close_left_eye",@"demo_expression_icon_close_right_eye",@"demo_expression_icon_eyes_wide_open",@"demo_expression_icon_Left_corner_of_mouth",@"demo_expression_icon_right_corner_of_mouth",@"demo_expression_icon_smile",@"demo_expression_icon_mouth_o",@"demo_expression_icon_mouth_a",@"demo_expression_icon_pouting",@"demo_expression_icon_uting_mouth",@"demo_expression_icon_bulging",@"demo_expression_icon_twitch",@"demo_expression_icon_turn_left",@"demo_expression_icon_turn_right",@"demo_expression_icon_nod"];
    _mExpresionView = [[FUExpresionView alloc] initWithFrame:frame images:images];
    _mExpresionView.hidden = YES;
    

    CGRect frame1 = CGRectZero;
    frame1 = CGRectMake(FUScreenWidth - 160, 88, 95, 24);
    frame1.origin.y = _mExpresionView.center.y;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame1];
    imageView.image = [UIImage imageNamed:@"demo_novice_bubble.png"];
    imageView.tag = 100;
    imageView.hidden = YES;
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:imageView.bounds];
    label.text = @"上滑列表滚动";
    label.font = [UIFont systemFontOfSize:11];
    label.textColor = [UIColor whiteColor];
    [imageView addSubview:label];
    

    [self.view addSubview:_mExpresionView];
}

-(void)setupTongueView{
    CGRect frame = CGRectZero;
    if (FUiPhoneXStyle()) {
        frame = CGRectMake(16, 88 + 34, 95, 176);
    }else{
        frame = CGRectMake(16, 88, 95, 176);
    }
    NSArray *images = @[@"舌头上",@"舌头下",@"舌头左",@"舌头右",@"舌头左上",@"舌头左下",@"舌头右上",@"舌头右下"];
    _mTongueView = [[FUTongueView alloc] initWithFrame:frame titles:images];
    _mTongueView.hidden = YES;
    [self.view addSubview:_mTongueView];
}

-(void)setupEmotionView{
    CGRect frame = CGRectZero;
    if (FUiPhoneXStyle()) {
        frame = CGRectMake(16, 88 + 34, 95, 176);
    }else{
        frame = CGRectMake(16, 88, 95, 176);
    }
    NSArray *images = @[@"平静",@"惊讶",@"开心",@"厌恶",@"愤怒",@"恐惧",@"悲伤",@"困惑"];
    _mEmotionView = [[FUTongueView alloc] initWithFrame:frame titles:images];
    _mEmotionView.hidden = YES;
    [_mEmotionView setViewType:FUViewTypeEmotion];
    [self.view addSubview:_mEmotionView];
}


#pragma mark - Public methods

- (void)refreshOutputVideo {
    [self updateNoTrackingTips];
    
    if ([FUManager shareManager].isRunningTongueTracking) {
        // 舌头检测
        int tongue_direction = 0;
        [FUConfigManager faceInfoWithName:@"tongue_direction" pret:&tongue_direction number:1];
        int index = [FUIndexHandle aiTougueIndexWithType:tongue_direction];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mTongueView setTongueViewSel:index];
        });
    }
    
    if ([FUManager shareManager].isRunningExpressionRecognition) {
        // 表情识别
        int expression_type = 0;
        if ([FUConfigManager faceInfoWithName:@"expression_type" pret:&expression_type number:1]) {
            NSArray *array = [FUIndexHandle aiExpressionArray:expression_type];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mExpresionView setExpresionViewSelArray:array];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mExpresionView setExpresionViewSelArray:[NSArray new]];
            });
        }
    }
    
    
    if ([FUManager shareManager].isRunningEmotionRecognition) {
        int emotion = 0;
        if ([FUConfigManager faceInfoWithName:@"emotion" pret:&emotion number:1]) {
            NSArray *array = [FUIndexHandle aiEmotionArray:emotion];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mEmotionView setViewSelArray:array];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mEmotionView setViewSelArray:[NSArray new]];
            });
        }
    }
    
    if ([FUManager shareManager].isRunningGestureRecognition) {
        // 手势识别
        if ([FUConfigManager isTrackingHand]) {
            FUAIGESTURETYPE type = [FUAIKit fuHandDetectorGetResultGestureType:0];
            int index = [FUIndexHandle aiGestureIndexWithType:type];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mGestureView setGestureViewSel:index];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mGestureView setGestureViewSel:-1];
            });
        }
    }
    
    if ([FUManager shareManager].isRunningActionRecognition) {
        // 动作识别
        if ([FUConfigManager isTrackingBody]) {
            int index = [FUAIKit fuHumanProcessorGetResultActionType:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mActionView setGestureViewSel:index];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mActionView setGestureViewSel:-1];
            });
        }
    }
}

#pragma mark - Private methods

/// 更新设置后的效果
- (void)updateConfigEffects:(NSArray<FUAISectionModel *> *)configs {
    for (FUAISectionModel *model in configs) {
        for (FUAIConfigCellModel *configModel in model.aiMenu) {
            switch (configModel.aiType) {
                case FUNamaAITypeKeypoint:{
                    [FUManager shareManager].runningFaceKeypoint = configModel.state == FUAICellStateSel;
                }
                    break;
                case FUNamaAITypeTongue:{
                    [FUManager shareManager].runningTongueTracking = configModel.state == FUAICellStateSel;
                }
                    break;
                case FUNamaAITypeExpressionRecognition:{
                    [FUManager shareManager].runningExpressionRecognition = configModel.state == FUAICellStateSel;
                }
                    break;
                case FUNamaAITypeEmotionRecognition:{
                    [FUManager shareManager].runningEmotionRecognition = configModel.state == FUAICellStateSel;
                }
                    break;
                case FUNamaAITypeBodyKeypoint:{
                    if (configModel.state == FUAICellStateDisable) {
                        [FUManager shareManager].runningWholeBodyKeypoint = NO;
                        [FUManager shareManager].runningHalfBodyKeypoint = NO;
                    } else {
                        if (configModel.footSelInde == 0) {
                            // 全身关键点
                            [FUManager shareManager].runningWholeBodyKeypoint = configModel.state == FUAICellStateSel;
                        } else {
                            // 半身关键点
                            [FUManager shareManager].runningHalfBodyKeypoint = configModel.state == FUAICellStateSel;
                        }
                    }
                }
                    break;
                case FUNamaAITypeBodySkeleton:{
                    if (configModel.state == FUAICellStateDisable) {
                        [FUManager shareManager].runningWholeBodySkeleton = NO;
                        [FUManager shareManager].runningHalfBodySkeleton = NO;
                    } else {
                        if (configModel.footSelInde == 0) {
                            // 全身骨骼
                            [FUManager shareManager].runningWholeBodySkeleton = configModel.state == FUAICellStateSel;
                        } else {
                            // 半身骨骼
                            [FUManager shareManager].runningHalfBodySkeleton = configModel.state == FUAICellStateSel;
                        }
                    }
                }
                    break;
                case FUNamaAITypeGestureRecognition:{
                    [FUManager shareManager].runningGestureRecognition = configModel.state == FUAICellStateSel;
                }
                    break;
                case FUNamaAITypePortraitSegmentation:{
                    [FUManager shareManager].runningPortraitSegmentation = configModel.state == FUAICellStateSel;
                }
                    break;
                case FUNamaAITypeHairSplit:{
                    [FUManager shareManager].runningHairSplit = configModel.state == FUAICellStateSel;
                }
                    break;
                case FUNamaAITypeHeadSplit:{
                    [FUManager shareManager].runningHeadSplit = configModel.state == FUAICellStateSel;
                }
                    break;
                case FUNamaAITypeActionRecognition:{
                    [FUManager shareManager].runningActionRecognition = configModel.state == FUAICellStateSel;
                }
                    break;
            }
        }
    }
}

/// 更新设置后的UI
- (void)updateConfigUI {
    self.mGestureView.hidden = YES;
    self.mActionView.hidden = YES;
    self.mTongueView.hidden = YES;
    self.mExpresionView.hidden = YES;
    self.mEmotionView.hidden = YES;
    
    if ([FUManager shareManager].isRunningTongueTracking) {
        self.mTongueView.hidden = NO;
        // 舌头检测视图位置根据视频信息视图变化
        if (self.buglyLabel.hidden) {
            [UIView animateWithDuration:0.25 animations:^{
                self.mTongueView.transform = CGAffineTransformIdentity;
            }];
        } else {
            _mTongueView.transform = CGAffineTransformIdentity;
            [UIView animateWithDuration:0.35 animations:^{
                self.mTongueView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.buglyLabel.bounds) +  10);
            }];
        }
    }
    
    if ([FUManager shareManager].isRunningExpressionRecognition) {
        // 表情识别选中
        self.mExpresionView.hidden = NO;
        // 提示上下滑动 1秒后消失
        UIImageView *tip = [self.view viewWithTag:100];
        tip.hidden = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            tip.hidden = YES;
        });
    }
    
    if ([FUManager shareManager].isRunningEmotionRecognition) {
        // 情绪识别选中
        self.mEmotionView.hidden = NO;
        if (self.buglyLabel.hidden && self.mTongueView.hidden) {
            [UIView animateWithDuration:0.25 animations:^{
                self.mEmotionView.transform = CGAffineTransformIdentity;
            }];
        } else {
            CGFloat height = self.buglyLabel.hidden ? 0 : CGRectGetHeight(self.buglyLabel.bounds) +  10;
            height = self.mTongueView.hidden ? height : (height + CGRectGetHeight(self.mTongueView.frame) + 10);
            [UIView animateWithDuration:0.35 animations:^{
                self.mEmotionView.transform = CGAffineTransformMakeTranslation(0, height);
            }];
        }
    }
    
    if ([FUManager shareManager].isRunningGestureRecognition) {
        self.mGestureView.hidden = NO;
    }
    if ([FUManager shareManager].isRunningActionRecognition) {
        self.mActionView.hidden = NO;
    }
}

/// 更新检测不到人脸/人体提示语
- (void)updateNoTrackingTips {
    
    if (![FUConfigManager isTrackingFace] && [FUManager shareManager].isNeedFace) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tipLabel.hidden = NO;
            self.tipLabel.text = @"未检测到人脸";
        });
        return;
    }
    
    if (![FUConfigManager isTrackingBody] && [FUManager shareManager].isNeedBody) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tipLabel.hidden = NO;
            if (([FUManager shareManager].isRunningWholeBodyKeypoint || [FUManager shareManager].isRunningWholeBodySkeleton) && ![FUManager shareManager].isRunningActionRecognition) {
                // 单独使用全身效果
                self.tipLabel.text = @"未检测到全身，全身入镜试试哦~";
            } else {
                self.tipLabel.text = @"未检测到人体";
            }
        });
        return;
    }
    
    if (![FUConfigManager isTrackingHand] && [FUManager shareManager].isNeedGesture) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tipLabel.hidden = NO;
            self.tipLabel.text = @"未检测到手势";
        });
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tipLabel.hidden = YES;
    });
}

#pragma mark - FUHeadButtonViewDelegate

-(void)headButtonViewBackAction:(UIButton *)btn{
    [[FUManager shareManager] destoryItems];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)headButtonViewBuglyAction:(UIButton *)btn{
    self.buglyLabel.hidden = !self.buglyLabel.hidden;
    if (_mTongueView.hidden == NO || _mEmotionView.hidden == NO) {
        if (!self.buglyLabel.hidden) {
            _mTongueView.transform = CGAffineTransformIdentity;
            [UIView animateWithDuration:0.35 animations:^{
                self.mTongueView.transform = CGAffineTransformMakeTranslation(0, self.buglyLabel.bounds.size.height + 10);
            }];
            
            _mEmotionView.transform = CGAffineTransformIdentity;
            float height = 0;
            height = self.buglyLabel.hidden? 0 : self.buglyLabel.bounds.size.height +  10;
            height = self.mTongueView.hidden?height:height + self.mTongueView.frame.size.height + 10;
            [UIView animateWithDuration:0.35 animations:^{
                self.mEmotionView.transform = CGAffineTransformMakeTranslation(0, height);
            }];
        }else{
            [UIView animateWithDuration:0.25 animations:^{
                self.mTongueView.transform = CGAffineTransformIdentity;

            }];
            float height = 0;
            height = self.mTongueView.hidden?height:height+self.mTongueView.frame.size.height + 10;
            [UIView animateWithDuration:0. animations:^{
                self.mEmotionView.transform = CGAffineTransformMakeTranslation(0, height);
            }];
        }
    }
}


-(void)headButtonViewMoreAction:(UIButton *)btn{
    btn.userInteractionEnabled = NO;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
        btn.userInteractionEnabled = YES ;
    });
    
    FUConfigController *configController = [[FUConfigController alloc] init];
    // 重新生成一份数据，避免设置界面更新问题
    NSMutableArray *datas = [[NSMutableArray alloc] init];
    for (FUAISectionModel *model in self.dataSource) {
        [datas addObject:[model copy]];
    }
    configController.configDataSource = datas;
    configController.delegate = self;
    CWLateralSlideConfiguration *config = [CWLateralSlideConfiguration configurationWithDistance:kCWSCREENWIDTH * 0.75 maskAlpha:0.4 scaleY:1.0 direction:CWDrawerTransitionFromRight backImage:nil];
    [self cw_showDrawerViewController:configController animationType:CWDrawerAnimationTypeDefault configuration:config];
}

#pragma mark - FUConfigControllerProtocol

- (void)configController:(FUConfigController *)controller didChangeConfigDataSource:(NSArray<FUAISectionModel *> *)configs {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (FUAISectionModel *model in configs) {
        [tempArray addObject:[model copy]];
    }
    self.dataSource = tempArray;
    [self updateConfigEffects:self.dataSource];
    [self updateConfigUI];
}

#pragma mark - Getters

- (FUGLDisplayView *)renderView {
    if (!_renderView) {
        _renderView = [[FUGLDisplayView alloc] initWithFrame:self.view.bounds];
    }
    return _renderView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        NSString *path=[[NSBundle mainBundle] pathForResource:@"AIConfig" ofType:@"json"];
        NSData *pathData=[[NSData alloc] initWithContentsOfFile:path];
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:pathData options:NSJSONReadingMutableContainers error:nil];
        NSArray *datas = [[FUAISectionModel mj_objectArrayWithKeyValuesArray:dic[@"data"]] copy];
        if ([self isMemberOfClass:[FUPhotoViewController class]]) {
            NSMutableArray *configs = [[NSMutableArray alloc] init];
            for (FUAISectionModel *model in datas) {
                if(model.moudleType == FUMoudleTypeBody){
                    // 只需要人体关键点，不需要骨骼
                    NSArray *tempArray = [NSArray arrayWithObjects:model.aiMenu[0], nil];
                    model.aiMenu = tempArray;
                }
                [configs addObject:[model copy]];
            }
            _dataSource = [configs mutableCopy];
        } else {
            _dataSource = [datas mutableCopy];
        }
        
    }
    return _dataSource;
}

- (FUHeadButtonView *)headButtonView {
    if (!_headButtonView) {
        _headButtonView = [[FUHeadButtonView alloc] init];
        _headButtonView.delegate = self;
    }
    return _headButtonView;
}

- (UILabel *)buglyLabel {
    if (!_buglyLabel) {
        _buglyLabel = [[UILabel alloc] init];
        _buglyLabel.layer.masksToBounds = YES;
        _buglyLabel.layer.cornerRadius = 5;
        _buglyLabel.numberOfLines = 0;
        _buglyLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        _buglyLabel.textColor = [UIColor whiteColor];
        _buglyLabel.alpha = 0.74;
        _buglyLabel.font = [UIFont systemFontOfSize:11];
    }
    return _buglyLabel;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.font = [UIFont systemFontOfSize:13];
        _tipLabel.hidden = YES;
    }
    return _tipLabel;
}

@end
