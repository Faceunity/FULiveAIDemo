//
//  FUTongueHandle.m
//  FUAlgorithmDemo
//
//  Created by 孙慕 on 2020/8/10.
//  Copyright © 2020 孙慕. All rights reserved.
//

#import "FUIndexHandle.h"

@implementation FUIndexHandle


+(int)getAItougueIndexwith:(FUAITONGUETYPE)type{
    int index = 0;
    switch (type) {
        case FUAITONGUE_UNKNOWN:
            index = 10;
            break;
            case FUAITONGUE_UP:
                index = 0;
                break;
            case FUAITONGUE_DOWN:
                index = 1;
                break;
            case FUAITONGUE_LEFT:
                index = 2;
                break;
            case FUAITONGUE_RIGHT:
                index = 3;
                break;
            case FUAITONGUE_LEFT_UP:
                index = 4;
                break;
            case FUAITONGUE_LEFT_DOWN:
                index = 5;
                break;
            case FUAITONGUE_RIGHT_UP:
                index = 6;
                break;
            case FUAITONGUE_RIGHT_DOWN:
                index = 7;
                break;
        default:
            break;
    }
    
    return index;
    
}

+(NSArray *)getAarrayAIexpression:(int)type;
{
    NSMutableArray *mutarray = [NSMutableArray array];
    
    for (int i = 1; i < 18; i++) {
        int a = 1 << i;
        if(type & a){
            [mutarray addObject:[NSNumber numberWithInt:[self convertToExpressionIndex:a]]];
        }
    }
       return mutarray;
    
}

+(NSArray *)getAarrayAIemotion:(int)type;
{
    NSMutableArray *mutarray = [NSMutableArray array];
    
    for (int i = 1; i < 9; i++) {
        int a = 1 << i;
        if(type & a){
            [mutarray addObject:[NSNumber numberWithInt:[self convertToEmotionIndex:a]]];
        }
    }
       return mutarray;
    
}

+(int)convertToExpressionIndex:(int)type{
       switch (type) {
           case FUAIEXPRESSION_BROW_UP: {//抬眉毛
               return 0;
           }
           case FUAIEXPRESSION_MOUTH_SMILE_LEFT: {//抬左边嘴角
               return 5;
           }
           case FUAIEXPRESSION_MOUTH_SMILE_RIGHT: {//抬右边嘴角
               return 6;
           }
           case FUAIEXPRESSION_MOUTH_FUNNEL: {//o
               return 8;
           }
           case FUAIEXPRESSION_MOUTH_OPEN: {//a
               return 9;
           }
           case FUAIEXPRESSION_MOUTH_PUCKER: {//嘟嘴
               return 10;
           }
           case FUAIEXPRESSION_MOUTH_FROWN: {//抿嘴
               return 13;
           }
           case FUAIEXPRESSION_MOUTH_PUFF: {//鼓脸
               return 12;
           }
           case FUAIEXPRESSION_LEFT_EYE_CLOSE: {//左闭眼
               return 2;
           }
           case FUAIEXPRESSION_RIGHT_EYE_CLOSE: {//右闭眼
               return 3;
           }
           case FUAIEXPRESSION_HEAD_LEFT: {//左抬头
               return 14;
           }
           case FUAIEXPRESSION_HEAD_RIGHT: {//右抬头
               return 15;
           }
           case FUAIEXPRESSION_MOUTH_SMILE: {//微笑
               return 7;
           }
           case FUAIEXPRESSION_HEAD_NOD: {//点头
               return 16;
           }
           case FUAIEXPRESSION_BROW_FROWN: {//皱眉
               return 1;
           }
           case FUAIEXPRESSION_EYE_WIDE: {//大眼
               return 4;
           }
           case FUAIEXPRESSION_MOUTH_ROLL: {//撇嘴
               return 11;
           }
           default:
               return -1;
       }
   }



+(int)convertToEmotionIndex:(int)type{
       switch (type) {
//           case FUAIEMOTION_UNKNOWN: {
//               return 0;
//           }
           case FUAIEMOTION_HAPPY: {
               return 2;
           }
           case FUAIEMOTION_SAD: {
               return 6;
           }
           case FUAIEMOTION_ANGRY: {
               return 4;
           }
           case FUAIEMOTION_SURPRISE: {
               return 1;
           }
           case FUAIEMOTION_FEAR: {
               return 5;
           }
           case FUAIEMOTION_DISGUST: {
               return 3;
           }
           case FUAIEMOTION_NEUTRAL: {
               return 0;
           }
           case FUAIEMOTION_CONFUSE: {
               return 7;
           }
           default:
               return -1;
       }
   }


@end
