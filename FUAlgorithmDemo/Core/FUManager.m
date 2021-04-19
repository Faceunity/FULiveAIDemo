//
//  FUManager.m
//  FULiveDemo
//
//  Created by 刘洋 on 2017/8/18.
//  Copyright © 2017年 刘洋. All rights reserved.
//

#import "FUManager.h"
#import "FURenderer.h"
#import "authpack.h"
#import <sys/utsname.h>
#import <CoreMotion/CoreMotion.h>
#import "FUImageHelper.h"


@interface FUManager ()
{
    int items[12];
    
    int frameID;

}

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic) int deviceOrientation;

@property (nonatomic, copy) NSMutableDictionary* handleCache;

@property (nonatomic, copy) NSMutableDictionary* runCache;

@property(nonatomic,strong) NSMutableArray *runingItems;


@property (nonatomic, strong) FURotatedImage *mRotatedImage;

@end

static FUManager *shareManager = NULL;

@implementation FUManager

+ (FUManager *)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[FUManager alloc] init];
    });
    
    return shareManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setupDeviceMotion];
        /**这里新增了一个参数shouldCreateContext，设为YES的话，不用在外部设置context操作，我们会在内部创建并持有一个context。
         还有设置为YES,则需要调用FURenderer.h中的接口，不能再调用funama.h中的接口。*/
        [[FURenderer shareRenderer] setupWithData:nil dataSize:0 ardata:nil authPackage:&g_auth_package authSize:sizeof(g_auth_package) shouldCreateContext:YES];
        
        _handleCache = [[NSMutableDictionary alloc] init];
        
        /* 加载AI模型 */
        [self loadAIModle];
        
        // 默认竖屏
        self.deviceOrientation = 0 ;
//        fuSetDefaultOrientation(self.deviceOrientation);        
        /* 设置嘴巴灵活度 默认= 0*/
        float flexible = 0.5;
        fuSetFaceTrackParam((char *)[@"mouth_expression_more_flexible" UTF8String], &flexible);

//        fuSetLogLevel(2);
        
        _mRotatedImage = [[FURotatedImage alloc] init];
        _runingItems = [NSMutableArray array];
        
        [FURenderer setMaxFaces:8];
        
    }
    
    return self;
}


-(void)loadAIModle{
    
    NSData *ai_gesture = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ai_hand_processor.bundle" ofType:nil]];
    [FURenderer loadAIModelFromPackage:(void *)ai_gesture.bytes size:(int)ai_gesture.length aitype:FUAITYPE_HANDGESTURE];

    NSData *ai_face_processor = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ai_face_processor.bundle" ofType:nil]];
    [FURenderer loadAIModelFromPackage:(void *)ai_face_processor.bytes size:(int)ai_face_processor.length aitype:FUAITYPE_FACEPROCESSOR];
    
    NSData *ai_human_processor = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ai_human_processor.bundle" ofType:nil]];
    [FURenderer loadAIModelFromPackage:(void *)ai_human_processor.bytes size:(int)ai_human_processor.length aitype:FUAITYPE_HUMAN_PROCESSOR];

    NSData *tongueData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tongue.bundle" ofType:nil]];
    int ret0 = fuLoadTongueModel((void *)tongueData.bytes, (int)tongueData.length) ;
    NSLog(@"fuLoadTongueModel %@",ret0 == 0 ? @"failure":@"success" );
    
    
}

-(void)loadBoudleWithConfig:(FUAISectionModel *)config{
    for (FUAIConfigCellModel *model in config.aiMenu) {
        for (int i = 0; i < model.bundleNames.count; i ++) {
            if([self getHandleWithName:model.bundleNames[i]]) return; //如果缓存有
            NSString *filePath = [[NSBundle mainBundle] pathForResource:model.bundleNames[i] ofType:@"bundle"];
            int handel =  [FURenderer itemWithContentsOfFile:filePath];
            [self setCacheBundleName:model.bundleNames[i] value:handel];
            
            NSLog(@"加载道具-----%@（%d）",model.bundleNames[i],handel);
        }
    }
}
static int cunt;
-(void)setNeedRenderHandle{
    _currentToast = nil;
    cunt = 0;
    for (int i = 0; i < sizeof(items)/sizeof(int); i ++) {
        items[i] = 0;
    }
    
    /* 动态加载的道具 */
    int index = 1;
    [_runingItems removeAllObjects];
    for (FUAISectionModel *config in self.config) {
        for (FUAIConfigCellModel *model in config.aiMenu) {
            if (model.state == FUAICellstateSel) {// 选中的道具
                [self addHandleItems:model index:&index];
                [_runingItems addObject:@(model.aiType)];
            }
        }
    }
    
    if ([_runingItems containsObject:@(FUNamaAITypeBodyKeyPoints)] && [_runingItems containsObject:@(FUNamaAITypeActionRecognition)]){
        _currentToast = @"未检测到人体";
    }
    
    if ([_runingItems containsObject:@(FUNamaAITypeExpression)] || [_runingItems containsObject:@(FUNamaAITypeKeypoint)] || [_runingItems containsObject:@(FUNamaAITypeTongue)] || [_runingItems containsObject:@(FUNamaAITypeEmotionRecognition)]) {
        _currentToast = @"未检测到人脸";
        
        /*人脸道具 */
        items[0]  = [self loadItemwWithItemName:@"aitype"];
//        [FURenderer itemSetParam:items[0] withName:@"aitype" value:@(FUAITYPE_FACEPROCESSOR)];
        

        
        if ([_runingItems containsObject:@(FUNamaAITypeEmotionRecognition)]&&[_runingItems containsObject:@(FUNamaAITypeExpression)]) {
            int res = (FUAITYPE_FACEPROCESSOR_EMOTION_RECOGNIZER)|(FUAITYPE_FACEPROCESSOR_EXPRESSION_RECOGNIZER);
            [FURenderer itemSetParam:items[0] withName:@"aitype" value:@(res)];
        }else{
            if ([_runingItems containsObject:@(FUNamaAITypeExpression)]) {
                [FURenderer itemSetParam:items[0] withName:@"aitype" value:@(FUAITYPE_FACEPROCESSOR_EXPRESSION_RECOGNIZER)];
            }
            if ([_runingItems containsObject:@(FUNamaAITypeEmotionRecognition)]) {
                [FURenderer itemSetParam:items[0] withName:@"aitype" value:@(FUAITYPE_FACEPROCESSOR_EMOTION_RECOGNIZER)];
            }
        }
        
    }
}

-(void)addHandleItems:(FUAIConfigCellModel *)model index:(int *)index{
    cunt++;
    
    if (model.aiType == FUNamaAITypeBodyKeyPoints || model.aiType == FUNamaAITypeHairSplit || model.aiType == FUNamaAITypePortraitSegmentation || model.aiType == FUNamaAITypeHeadSplit) {//人体关键点,特殊
         if (model.footSelInde == 0) {
                items[*index] = [self loadItemwWithItemName:model.bundleNames[0]];
                *index = *index + 1;
            }else{
                items[*index] = [self loadItemwWithItemName:model.bundleNames[1]];
                *index = *index + 1;
             _currentToast = model.mToasts[1];
            }
            _currentToast = model.mToasts[model.footSelInde];
    }else if (model.aiType == FUNamaAITypeBodySkeleton) {//骨骼
            _currentToast = model.mToasts[model.footSelInde];
            items[*index] = [self loadItemwWithItemName:model.bundleNames[0]];
            [FURenderer itemSetParam:items[*index] withName:@"enable_human_processor" value:@(1)];
        for (NSString *strName in model.bindItemNames) {
            int subHandel = [self loadItemwWithItemName:strName];
            [FURenderer bindItems:items[*index] items:&subHandel itemsCount:1];
        }
         if (model.footSelInde == 0) {//全
             double position[3] = {0.0, 53.14, -537.94};
             [FURenderer itemSetParamdv:items[*index] withName:@"target_position" value:position length:3];
             [FURenderer itemSetParam:items[*index] withName:@"target_angle" value:@(0)];
             [FURenderer itemSetParam:items[*index] withName:@"reset_all" value:@(3)];
             [FURenderer itemSetParam:items[*index] withName:@"human_3d_track_set_scene" value:@(1)];
          }else{//半身
              [FURenderer itemSetParam:items[*index] withName:@"human_3d_track_set_scene" value:@(0)];
              double position[3] = {0.0, 0, -183.89};
              [FURenderer itemSetParamdv:items[*index] withName:@"target_position" value:position length:3];
              [FURenderer itemSetParam:items[*index] withName:@"target_angle" value:@(0)];
              [FURenderer itemSetParam:items[*index] withName:@"reset_all" value:@(3)];
          }
            *index = *index + 1;
    }else if(model.aiType == FUNamaAITypeKeypoint){
        _currentToast = model.mToasts[0];
        items[*index] = [self loadItemwWithItemName:model.bundleNames[0]];
        [FURenderer itemSetParam:items[*index] withName:@"landmarks_type" value:@(FUAITYPE_FACELANDMARKS239)];
        *index = *index + 1;
    }
    else{
        _currentToast = model.mToasts[0];
        for (int i = 0; i < model.bundleNames.count; i ++) {
           items[*index] = [self loadItemwWithItemName:model.bundleNames[i]];
           *index = *index + 1;
        }
    }
    
    if (cunt > 1) { // 多个选中不提示
        
        _currentToast = nil;
    }
    
}


-(int)loadItemwWithItemName:(NSString *)bundleName{
    
    int handel = [self getHandleWithName:bundleName];
    if (handel == 0) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
        handel =  [FURenderer itemWithContentsOfFile:filePath];
        [self setCacheBundleName:bundleName value:handel];
    }
    
    NSLog(@"run add ---%@(%d)",bundleName,handel);
    
    return handel;
}


-(BOOL)isRuningAitype:(FUNamaAIType)aiType{
   
    if ([_runingItems containsObject:@(aiType)]) {
        return YES;
    }
    return NO;
}



/**销毁全部道具*/
- (void)destoryItems{
     NSLog(@"strat Nama destroy all items ~");
    // unbind 骨骼所有的依赖道具
    for (FUAISectionModel *config in _config) {
            for(int i = 0;i < config.aiMenu.count;i ++){
                FUAIConfigCellModel *model = config.aiMenu[i];
                if(model.aiType == FUNamaAITypeBodySkeleton){
                    int controlHandle = [self getHandleWithName:model.bundleNames[0]];
                    [FURenderer unbindAllItems:controlHandle];
                }
        }
    }
    
    /* 销毁所有道具 */
    [FURenderer destroyAllItems];
    [FURenderer onCameraChange];
    [FURenderer OnDeviceLost];
    
    for (int i = 0; i < sizeof(items)/sizeof(int); i ++) {
        items[i] = 0;
    }
}

/* 缓存 */
-(void)setCacheBundleName:(NSString *)bundleName value:(int)handle{
    if ([bundleName isEqualToString:@""] || !bundleName) {
        return;
    }
    [_handleCache setObject:@(handle) forKey:bundleName];

}

-(int)getHandleWithName:(NSString *)bundleName{
    if ([bundleName isEqualToString:@""] || !bundleName) {
        return 0;
    }
    return [_handleCache[bundleName] intValue];
}

-(void)clearManagerCache{
    [_runingItems removeAllObjects];
    /* 销毁道具缓存 */
    [_handleCache removeAllObjects];
    
    /* 重置配置模型 */
    for (FUAISectionModel *config in _config) {
            for(int i = 0;i < config.aiMenu.count;i ++){
            FUAIConfigCellModel *model = config.aiMenu[i];
            model.state = FUAICellstateNol;
            model.footSelInde = 0;
        }
    }
    
}


#pragma mark -  render
/**将道具绘制到pixelBuffer*/
- (CVPixelBufferRef)renderItemsToPixelBuffer:(CVPixelBufferRef)pixelBuffer
{
	// 在未识别到人脸时根据重力方向设置人脸检测方向
    if ([self isDeviceMotionChange]) {
        fuSetDefaultRotationMode(self.deviceOrientation);
        /* 解决旋转屏幕效果异常 onCameraChange*/
        [FURenderer onCameraChange];
        NSLog(@"-----屏幕方向----%d",self.deviceOrientation);
    }
    /*Faceunity核心接口，将道具及美颜效果绘制到pixelBuffer中，执行完此函数后pixelBuffer即包含美颜及贴纸效果*/

    CVPixelBufferRef buffer = [[FURenderer shareRenderer] renderPixelBuffer:pixelBuffer withFrameId:frameID items:items itemCount:sizeof(items)/sizeof(int) flipx:YES];//flipx 参数设为YES可以使道具做水平方向的镜像翻转
    frameID += 1;
    
    return buffer;
}

/* 静态图片 */
- (UIImage *)renderItemsToImage:(UIImage *)image{
    int postersWidth = (int)CGImageGetWidth(image.CGImage);
    int postersHeight = (int)CGImageGetHeight(image.CGImage);
    CFDataRef dataFromImageDataProvider = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    GLubyte *imageData = (GLubyte *)CFDataGetBytePtr(dataFromImageDataProvider);
    
    [[FURenderer shareRenderer] renderItems:imageData inFormat:FU_FORMAT_RGBA_BUFFER outPtr:imageData outFormat:FU_FORMAT_RGBA_BUFFER width:postersWidth height:postersHeight frameId:frameID items:items itemCount:sizeof(items)/sizeof(int) flipx:YES];
    
    frameID++;
    /* 转回image */
    image = [FUImageHelper convertBitmapRGBA8ToUIImage:imageData withWidth:postersWidth withHeight:postersHeight];
    CFRelease(dataFromImageDataProvider);
    
    return image;
}


- (GLubyte *)renderImageData:(GLubyte *)imageData w:(int)w h:(int)h {
    [[FURenderer shareRenderer] renderItems:imageData inFormat:FU_FORMAT_RGBA_BUFFER outPtr:imageData outFormat:FU_FORMAT_RGBA_BUFFER width:w height:h frameId:frameID items:items itemCount:sizeof(items)/sizeof(int) flipx:YES];
    
    frameID++;

    return imageData;
}

-(void)renderItemsWithPtaPixelBuffer:(CVPixelBufferRef)pixelBuffer{
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    int h = (int)CVPixelBufferGetHeight(pixelBuffer);
    int stride = (int)CVPixelBufferGetBytesPerRow(pixelBuffer);
    int w = stride/4;
    void* pixelBuffer_pod  = (void *)CVPixelBufferGetBaseAddress(pixelBuffer);
    [[FURenderer shareRenderer] renderBundles:pixelBuffer_pod inFormat:FU_FORMAT_BGRA_BUFFER outPtr:pixelBuffer_pod  outFormat:FU_FORMAT_BGRA_BUFFER width:w height:h frameId:frameID++ items:items itemCount:sizeof(items)/sizeof(int)];
    
    _mRotatedImage.mData = pixelBuffer_pod;
    _mRotatedImage.mWidth = w;
    _mRotatedImage.mHeight = h;
    [[FURenderer shareRenderer] rotateImage:_mRotatedImage inPtr:pixelBuffer_pod inFormat:FU_FORMAT_BGRA_BUFFER width:w height:h rotationMode:FURotationMode180 flipX:YES flipY:NO];
    memcpy(pixelBuffer_pod ,_mRotatedImage.mData, w*h*4);
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
}

- (GLubyte *)renderItemsWithPtaImageData:(GLubyte *)imageData w:(int)w h:(int)h {
    
    [[FURenderer shareRenderer] renderBundles:imageData inFormat:FU_FORMAT_RGBA_BUFFER outPtr:imageData  outFormat:FU_FORMAT_RGBA_BUFFER width:w height:h frameId:frameID++ items:items itemCount:sizeof(items)/sizeof(int)];
    
    _mRotatedImage.mData = imageData;
    _mRotatedImage.mWidth = w;
    _mRotatedImage.mHeight = h;
    [[FURenderer shareRenderer] rotateImage:_mRotatedImage inPtr:imageData inFormat:FU_FORMAT_BGRA_BUFFER width:w height:h rotationMode:FURotationMode180 flipX:YES flipY:NO];
    memcpy(imageData ,_mRotatedImage.mData, w*h*4);
    frameID++;

    return imageData;
}



#pragma mark -  nama查询&设置
- (void)setAsyncTrackFaceEnable:(BOOL)enable{
    [FURenderer setAsyncTrackFaceEnable:enable];
}

/**获取图像中人脸中心点*/
- (CGPoint)getFaceCenterInFrameSize:(CGSize)frameSize{
    
    static CGPoint preCenter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        preCenter = CGPointMake(0.49, 0.5);
    });
    
    // 获取人脸矩形框，坐标系原点为图像右下角，float数组为矩形框右下角及左上角两个点的x,y坐标（前两位为右下角的x,y信息，后两位为左上角的x,y信息）
    float faceRect[4];
    int ret = [FURenderer getFaceInfo:0 name:@"face_rect" pret:faceRect number:4];
    
    if (ret == 0) {
        return preCenter;
    }
    
    // 计算出中心点的坐标值
    CGFloat centerX = (faceRect[0] + faceRect[2]) * 0.5;
    CGFloat centerY = (faceRect[1] + faceRect[3]) * 0.5;
    
    // 将坐标系转换成以左上角为原点的坐标系
    centerX = centerX / frameSize.width;
    centerY = centerY / frameSize.height;
    
    CGPoint center = CGPointMake(centerX, centerY);
    
    preCenter = center;
    
    return center;
}

/**获取75个人脸特征点*/
- (void)getLandmarks:(float *)landmarks index:(int)index;
{
    int ret = [FURenderer getFaceInfo:index name:@"landmarks" pret:landmarks number:150];
    
    if (ret == 0) {
        memset(landmarks, 0, sizeof(float)*150);
    }
}

- (CGRect)getFaceRectWithIndex:(int)index size:(CGSize)renderImageSize{
    CGRect rect = CGRectZero ;
    float faceRect[4];
    
    [FURenderer getFaceInfo:index name:@"face_rect" pret:faceRect number:4];
    
    CGFloat centerX = (faceRect[0] + faceRect[2]) * 0.5;
    CGFloat centerY = (faceRect[1] + faceRect[3]) * 0.5;
    CGFloat width = faceRect[2] - faceRect[0] ;
    CGFloat height = faceRect[3] - faceRect[1] ;
    
    centerX = renderImageSize.width - centerX;
    centerX = centerX / renderImageSize.width;
    
    centerY = renderImageSize.height - centerY;
    centerY = centerY / renderImageSize.height;
    
    width = width / renderImageSize.width ;
    
    height = height / renderImageSize.height ;
    
    CGPoint center = CGPointMake(centerX, centerY);
    
    CGSize size = CGSizeMake(width, height) ;
    
    rect.origin = CGPointMake(center.x - size.width / 2.0, center.y - size.height / 2.0) ;
    rect.size = size ;
    
    
    return rect ;
}


/**判断是否检测到人脸*/
- (BOOL)isTracking
{
    return [FURenderer isTracking] > 0;
}

/**切换摄像头要调用此函数*/
- (void)onCameraChange{
    [FURenderer onCameraChange];
}

/**获取错误信息*/
- (NSString *)getError
{
    // 获取错误码
    int errorCode = fuGetSystemError();
    
    if (errorCode != 0) {
        
        // 通过错误码获取错误描述
        NSString *errorStr = [NSString stringWithUTF8String:fuGetSystemErrorString(errorCode)];
        
        return errorStr;
    }
    
    return nil;
}


/**判断 SDK 是否是 lite 版本**/
- (BOOL)isLiteSDK {
    NSString *version = [FURenderer getVersion];
    return [version containsString:@"lite"];
}


//保证正脸
-(BOOL)isGoodFace:(int)index{
    // 保证正脸
    float rotation[4] ;
    float DetectionAngle = 15.0 ;
    [FURenderer getFaceInfo:index name:@"rotation" pret:rotation number:4];
    
    float q0 = rotation[0];
    float q1 = rotation[1];
    float q2 = rotation[2];
    float q3 = rotation[3];
    
    float z =  atan2(2*(q0*q1 + q2 * q3), 1 - 2*(q1 * q1 + q2 * q2)) * 180 / M_PI;
    float y =  asin(2 *(q0*q2 - q1*q3)) * 180 / M_PI;
    float x = atan(2*(q0*q3 + q1*q2)/(1 - 2*(q2*q2 + q3*q3))) * 180 / M_PI;
    if (x > DetectionAngle || x < - 5 || fabs(y) > DetectionAngle || fabs(z) > DetectionAngle) {//抬头低头角度限制：仰角不大于5°，俯角不大于15°
        return NO;
    }
    
    return YES;
}

/* 是否夸张 */
-(BOOL)isExaggeration:(int)index{
    float expression[46] ;
    [FURenderer getFaceInfo:index name:@"expression" pret:expression number:46];
    
    for (int i = 0 ; i < 46; i ++) {
        
        if (expression[i] > 0.60) {
            
            return YES;
        }
    }
    return NO;
}



#pragma mark -  重力感应
-(void)setupDeviceMotion{
    
    // 初始化陀螺仪
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = 0.5;// 1s刷新一次
    
    if ([self.motionManager isDeviceMotionAvailable]) {
       [self.motionManager startAccelerometerUpdates];
         [self.motionManager startDeviceMotionUpdates];
    }
}

#pragma mark -  陀螺仪
-(BOOL)isDeviceMotionChange{
//    if (![FURenderer isTracking]) {
        CMAcceleration acceleration = self.motionManager.accelerometerData.acceleration ;
        int orientation = 0;
        if (acceleration.x >= 0.75) {
            orientation = 3;
        } else if (acceleration.x <= -0.75) {
            orientation = 1;
        } else if (acceleration.y <= -0.75) {
            orientation = 0;
        } else if (acceleration.y >= 0.75) {
            orientation = 2;
        }
    
        if (self.deviceOrientation != orientation) {
            self.deviceOrientation = orientation ;
            
            return YES;
        }
//    }
    return NO;
}


@end
