//
//  FUManager.m
//  FULiveDemo
//
//  Created by 刘洋 on 2017/8/18.
//  Copyright © 2017年 刘洋. All rights reserved.
//

#import "FUManager.h"

#import <FURenderKit/FUFacialFeatures.h>
#import <FURenderKit/FUAvatar.h>

@interface FUManager ()

/// 骨骼需要设置Scene
@property (nonatomic, strong) FUScene *scene;
@property (nonatomic, strong) FUAvatar *avatar;
@property (nonatomic, strong) FUBackground *sceneBackground;

@end

static FUManager *shareManager = NULL;

@implementation FUManager

+ (FUManager *)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[FUManager alloc] init];
    });
    return shareManager;
}

- (instancetype)init {
    if (self = [super init]) {
        [FUConfigManager initializeSDK];
    }
    return self;
}

- (void)destoryItems {
    [[FURenderKit shareRenderKit].stickerContainer removeAllSticks];
    [FUConfigManager onCameraChange];
    
    if (_runningWholeBodySkeleton || _runningHalfBodySkeleton) {
        // 解绑骨骼相关
        [self destoryScene];
        _runningWholeBodySkeleton = NO;
        _runningHalfBodySkeleton = NO;
    }
    _runningFaceKeypoint = NO;
    _runningTongueTracking = NO;
    _runningExpressionRecognition = NO;
    _runningEmotionRecognition = NO;
    _runningWholeBodyKeypoint = NO;
    _runningHalfBodyKeypoint = NO;
    _runningGestureRecognition = NO;
    _runningPortraitSegmentation = NO;
    _runningHairSplit = NO;
    _runningHeadSplit = NO;
    _runningActionRecognition = NO;
}

- (void)destoryScene {
    [self.scene removeAvatar:self.avatar];
    _avatar = nil;
    [[FURenderKit shareRenderKit] removeScene:self.scene completion:^(BOOL success) {
        [FURenderKit shareRenderKit].currentScene = nil;
    }];
    _scene = nil;
    _sceneBackground = nil;
}

- (BOOL)isNeedFace {
    return _runningFaceKeypoint || _runningHairSplit || _runningHeadSplit;
}

- (BOOL)isNeedBody {
    return _runningPortraitSegmentation || _runningHalfBodyKeypoint || _runningWholeBodyKeypoint || _runningHalfBodySkeleton || _runningWholeBodySkeleton || _runningActionRecognition;
}

- (BOOL)isNeedGesture {
    return _runningGestureRecognition;
}

#pragma mark - Setters
- (void)setRunningFaceKeypoint:(BOOL)runningFaceKeypoint {
    if (_runningFaceKeypoint == runningFaceKeypoint) {
        return;
    }
    _runningFaceKeypoint = runningFaceKeypoint;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"landmarks" ofType:@"bundle"];
    if (runningFaceKeypoint) {
        FUFacialFeatures *item = [[FUFacialFeatures alloc] initWithPath:path name:@"landmarks"];
        item.landmarksType = FUAITYPE_FACELANDMARKS239;
        [[FURenderKit shareRenderKit].stickerContainer addSticker:item completion:nil];
    } else {
        [[FURenderKit shareRenderKit].stickerContainer removeStickerForPath:path completion:nil];
    }
}

- (void)setRunningTongueTracking:(BOOL)runningTongueTracking {
    if (_runningTongueTracking == runningTongueTracking) {
        return;
    }
    _runningTongueTracking = runningTongueTracking;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"set_tongue" ofType:@"bundle"];
    if (runningTongueTracking) {
        FUSticker *item = [[FUFacialFeatures alloc] initWithPath:path name:@"set_tongue"];
        [[FURenderKit shareRenderKit].stickerContainer addSticker:item completion:nil];
    } else {
        [[FURenderKit shareRenderKit].stickerContainer removeStickerForPath:path completion:nil];
    }
}

- (void)setRunningExpressionRecognition:(BOOL)runningExpressionRecognition {
    if (_runningExpressionRecognition == runningExpressionRecognition) {
        return;
    }
    _runningExpressionRecognition = runningExpressionRecognition;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"aitype" ofType:@"bundle"];
    if (runningExpressionRecognition) {
        FUFacialFeatures *item = [[FUFacialFeatures alloc] initWithPath:path name:@"aitype"];
        item.aiType = _runningEmotionRecognition ? (FUAITYPE_FACEPROCESSOR_EMOTION_RECOGNIZER | FUAITYPE_FACEPROCESSOR_EXPRESSION_RECOGNIZER) : FUAITYPE_FACEPROCESSOR_EXPRESSION_RECOGNIZER;
        [[FURenderKit shareRenderKit].stickerContainer addSticker:item completion:nil];
    } else {
        if (!_runningEmotionRecognition) {
            // 表情识别和情绪识别使用同一个bundle，这里需要做判断
            [[FURenderKit shareRenderKit].stickerContainer removeStickerForPath:path completion:nil];
        }
    }
}

- (void)setRunningEmotionRecognition:(BOOL)runningEmotionRecognition {
    if (_runningEmotionRecognition == runningEmotionRecognition) {
        return;
    }
    _runningEmotionRecognition = runningEmotionRecognition;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"aitype" ofType:@"bundle"];
    if (runningEmotionRecognition) {
        FUFacialFeatures *item = [[FUFacialFeatures alloc] initWithPath:path name:@"aitype"];
        item.aiType = _runningExpressionRecognition ? (FUAITYPE_FACEPROCESSOR_EMOTION_RECOGNIZER | FUAITYPE_FACEPROCESSOR_EXPRESSION_RECOGNIZER) : FUAITYPE_FACEPROCESSOR_EMOTION_RECOGNIZER;
        [[FURenderKit shareRenderKit].stickerContainer addSticker:item completion:nil];
    } else {
        if (!_runningExpressionRecognition) {
            // 表情识别和情绪识别使用同一个bundle，这里需要做判断
            [[FURenderKit shareRenderKit].stickerContainer removeStickerForPath:path completion:nil];
        }
    }
}

- (void)setRunningGestureRecognition:(BOOL)runningGestureRecognition {
    if (_runningGestureRecognition == runningGestureRecognition) {
        return;
    }
    _runningGestureRecognition = runningGestureRecognition;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"handgesture" ofType:@"bundle"];
    if (runningGestureRecognition) {
        FUSticker *item = [[FUFacialFeatures alloc] initWithPath:path name:@"set_tongue"];
        [[FURenderKit shareRenderKit].stickerContainer addSticker:item completion:nil];
    } else {
        [[FURenderKit shareRenderKit].stickerContainer removeStickerForPath:path completion:nil];
    }
}

- (void)setRunningWholeBodyKeypoint:(BOOL)runningWholeBodyKeypoint {
    if (_runningWholeBodyKeypoint == runningWholeBodyKeypoint) {
        return;
    }
    _runningWholeBodyKeypoint = runningWholeBodyKeypoint;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"bodyLandmarks_dance" ofType:@"bundle"];
    if (runningWholeBodyKeypoint) {
        if (_runningHalfBodyKeypoint) {
            // 如果已经运行半身关键点，则先移除
            NSString *halfPath = [[NSBundle mainBundle] pathForResource:@"bodyLandmarks_selife" ofType:@"bundle"];
            [[FURenderKit shareRenderKit].stickerContainer removeStickerForPath:halfPath completion:nil];
            _runningHalfBodyKeypoint = NO;
        }
        FUSticker *item = [[FUFacialFeatures alloc] initWithPath:path name:@"bodyLandmarks_dance"];
        [[FURenderKit shareRenderKit].stickerContainer addSticker:item completion:nil];
    } else {
        [[FURenderKit shareRenderKit].stickerContainer removeStickerForPath:path completion:nil];
    }
}

- (void)setRunningHalfBodyKeypoint:(BOOL)runningHalfBodyKeypoint {
    if (_runningHalfBodyKeypoint == runningHalfBodyKeypoint) {
        return;
    }
    _runningHalfBodyKeypoint = runningHalfBodyKeypoint;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"bodyLandmarks_selife" ofType:@"bundle"];
    if (runningHalfBodyKeypoint) {
        if (_runningWholeBodyKeypoint) {
            // 如果已经运行全身关键点，则先移除
            NSString *wholePath = [[NSBundle mainBundle] pathForResource:@"bodyLandmarks_dance" ofType:@"bundle"];
            [[FURenderKit shareRenderKit].stickerContainer removeStickerForPath:wholePath completion:nil];
            _runningWholeBodyKeypoint = NO;
        }
        FUSticker *item = [[FUFacialFeatures alloc] initWithPath:path name:@"bodyLandmarks_selife"];
        [[FURenderKit shareRenderKit].stickerContainer addSticker:item completion:nil];
    } else {
        [[FURenderKit shareRenderKit].stickerContainer removeStickerForPath:path completion:nil];
    }
}

- (void)setRunningWholeBodySkeleton:(BOOL)runningWholeBodySkeleton {
    if (_runningWholeBodySkeleton == runningWholeBodySkeleton) {
        return;
    }
    _runningWholeBodySkeleton = runningWholeBodySkeleton;
    if (runningWholeBodySkeleton) {
        if (_runningHalfBodySkeleton) {
            // 如果已经运行半身骨骼，则先设为NO
            _runningHalfBodySkeleton = NO;
        }
        if (![FURenderKit shareRenderKit].currentScene) {
            [[FURenderKit shareRenderKit] addScene:self.scene completion:^(BOOL success) {
                [FURenderKit shareRenderKit].currentScene = self.scene;
                self.scene.background = self.sceneBackground;
                [self.scene addAvatar:self.avatar];
                self.scene.AIConfig.bodyTrackMode = FUBodyTrackModeFull;
                self.avatar.position = FUPositionMake(0, 53.14, -537.94);
                [self.avatar setEnableHumanAnimDriver:YES];
            }];
        } else {
            self.scene.AIConfig.bodyTrackMode = FUBodyTrackModeFull;
            self.avatar.position = FUPositionMake(0, 53.14, -537.94);
            [self.avatar setEnableHumanAnimDriver:YES];
        }
    } else {
        [self destoryScene];
    }
}

- (void)setRunningHalfBodySkeleton:(BOOL)runningHalfBodySkeleton {
    if (_runningHalfBodySkeleton == runningHalfBodySkeleton) {
        return;
    }
    _runningHalfBodySkeleton = runningHalfBodySkeleton;
    if (runningHalfBodySkeleton) {
        if (_runningWholeBodySkeleton) {
            // 如果已经运行全身骨骼，则先设为NO
            _runningWholeBodySkeleton = NO;
        }
        if (![FURenderKit shareRenderKit].currentScene) {
            [[FURenderKit shareRenderKit] addScene:self.scene completion:^(BOOL success) {
                [FURenderKit shareRenderKit].currentScene = self.scene;
                self.scene.background = self.sceneBackground;
                [self.scene addAvatar:self.avatar];
                self.scene.AIConfig.bodyTrackMode = FUBodyTrackModeHalf;
                self.avatar.position = FUPositionMake(0, 0, -183.89);
                [self.avatar setEnableHumanAnimDriver:YES];
            }];
        } else {
            self.scene.AIConfig.bodyTrackMode = FUBodyTrackModeHalf;
            self.avatar.position = FUPositionMake(0, 0, -183.89);
            [self.avatar setEnableHumanAnimDriver:YES];
        }
    } else {
        [self destoryScene];
    }
}

- (void)setRunningPortraitSegmentation:(BOOL)runningPortraitSegmentation {
    if (_runningPortraitSegmentation == runningPortraitSegmentation) {
        return;
    }
    _runningPortraitSegmentation = runningPortraitSegmentation;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"human_mask" ofType:@"bundle"];
    if (runningPortraitSegmentation) {
        FUSticker *item = [[FUFacialFeatures alloc] initWithPath:path name:@"human_mask"];
        [[FURenderKit shareRenderKit].stickerContainer addSticker:item completion:nil];
    } else {
        [[FURenderKit shareRenderKit].stickerContainer removeStickerForPath:path completion:nil];
    }
}

- (void)setRunningHairSplit:(BOOL)runningHairSplit {
    if (_runningHairSplit == runningHairSplit) {
        return;
    }
    _runningHairSplit = runningHairSplit;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"hair_normal_algorithm" ofType:@"bundle"];
    if (runningHairSplit) {
        FUSticker *item = [[FUFacialFeatures alloc] initWithPath:path name:@"hair_normal_algorithm"];
        [[FURenderKit shareRenderKit].stickerContainer addSticker:item completion:nil];
    } else {
        [[FURenderKit shareRenderKit].stickerContainer removeStickerForPath:path completion:nil];
    }
}

- (void)setRunningHeadSplit:(BOOL)runningHeadSplit {
    if (_runningHeadSplit == runningHeadSplit) {
        return;
    }
    _runningHeadSplit = runningHeadSplit;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"head_mask" ofType:@"bundle"];
    if (runningHeadSplit) {
        FUSticker *item = [[FUFacialFeatures alloc] initWithPath:path name:@"head_mask"];
        [[FURenderKit shareRenderKit].stickerContainer addSticker:item completion:nil];
    } else {
        [[FURenderKit shareRenderKit].stickerContainer removeStickerForPath:path completion:nil];
    }
}

- (void)setRunningActionRecognition:(BOOL)runningActionRecognition {
    if (_runningActionRecognition == runningActionRecognition) {
        return;
    }
    _runningActionRecognition = runningActionRecognition;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"empty_aitpye_2d" ofType:@"bundle"];
    if (runningActionRecognition) {
        FUSticker *item = [[FUFacialFeatures alloc] initWithPath:path name:@"empty_aitpye_2d"];
        [[FURenderKit shareRenderKit].stickerContainer addSticker:item completion:nil];
    } else {
        [[FURenderKit shareRenderKit].stickerContainer removeStickerForPath:path completion:nil];
    }
}

#pragma mark - Getters
- (FUScene *)scene {
    if (!_scene) {
        _scene = [[FUScene alloc] init];
        _scene.AIConfig.bodyTrackEnable = YES;
    }
    return _scene;
}

- (FUBackground *)sceneBackground {
    if (!_sceneBackground) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"default_bg" ofType:@"bundle"];
        _sceneBackground = [[FUBackground alloc] initWithPath:path name:@"bg"];
    }
    return _sceneBackground;
}

- (FUAvatar *)avatar {
    if (!_avatar) {
        _avatar = [[FUAvatar alloc] init];
        _avatar.rotate = 0;
        // animations
        NSArray *bindItemNames = @[@"anim_eight",@"anim_fist",@"anim_greet",@"anim_gun",@"anim_heart",@"anim_hold",@"anim_korheart",@"anim_merge",@"anim_ok",@"anim_one", @"anim_palm",@"anim_rock",@"anim_six",@"anim_thumb",@"anim_two",@"anim_idle",@"fxaa"];
        for (NSString *strName in bindItemNames) {
            NSString *path = [[NSBundle mainBundle] pathForResource:strName ofType:@"bundle"];
            FUAnimation *component = [[FUAnimation alloc] initWithPath:path name:strName];
            [_avatar addAnimation:component];
        }
        // components
        NSString *bodyComponentPath = [[NSBundle mainBundle] pathForResource:@"fakeman" ofType:@"bundle"];
        [_avatar addComponent:[[FUItem alloc] initWithPath:bodyComponentPath name:@"fakeman"]];
    }
    return _avatar;
}

@end
