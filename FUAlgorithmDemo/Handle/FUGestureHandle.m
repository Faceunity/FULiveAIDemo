//
//  FUGesturnGHandle.m
//  FUAlgorithmDemo
//
//  Created by 孙慕 on 2020/6/15.
//  Copyright © 2020 孙慕. All rights reserved.
//

#import "FUGestureHandle.h"

@implementation FUGestureHandle

+(int)getIndexwith:(FUAIGESTURETYPE)type{
    int index = -1;
    switch (type) {
        case FUAIGESTURE_THUMB:
            index = 13;
            break;
        case FUAIGESTURE_KORHEART:
            index = 1;
            break;
        case FUAIGESTURE_SIX:
            index = 10;
            break;
        case FUAIGESTURE_FIST:
            index =  11;
            break;
        case FUAIGESTURE_PALM:
            index =  9;
            break;
        case FUAIGESTURE_ONE:
                index =  6;
                break;
        case FUAIGESTURE_TWO:
                index =  7;
                break;
        case FUAIGESTURE_OK:
            index = 8;
                break;
        case FUAIGESTURE_ROCK:
            index = 0;
                break;
            case FUAIGESTURE_HOLD:
            index = 12;
                break;
            case FUAIGESTURE_PHOTO:
            index = 5;
                break;
            case FUAIGESTURE_HEART:
            index = 2;
                break;
            case FUAIGESTURE_MERGE:
            index = 4;
                break;
            case FUAIGESTURE_GREET:
                index = 3;
            break;
            
        default:
            break;
    }
    
    return  index;
}

@end
