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
    if (type & FUAIEXPRESSION_SMILE) {
        [mutarray addObject:[NSNumber numberWithInt:0]];
    }
    if (type & FUAIEXPRESSION_MOUTH_OPEN) {
        [mutarray addObject:[NSNumber numberWithInt:1]];
    }
    if (type & FUAIEXPRESSION_EYE_BLINK) {
        [mutarray addObject:[NSNumber numberWithInt:2]];
    }
    if (type & FUAIEXPRESSION_POUT) {
        [mutarray addObject:[NSNumber numberWithInt:3]];
    }

       return mutarray;
    
}


@end
