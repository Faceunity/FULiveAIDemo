//
//  FUActionModel.m
//  FUAlgorithmDemo
//
//  Created by 孙慕 on 2020/5/29.
//  Copyright © 2020 孙慕. All rights reserved.
//

#import "FUActionModel.h"

@implementation FUActionModel

-(void)setJoint2ds:(NSArray *)joint2ds{
    _joint2ds = joint2ds;
    float *ref_posa = malloc(sizeof(float) *50);
    for (int i = 0; i < _joint2ds.count; i ++) {
        ref_posa[i] = [_joint2ds[i] doubleValue];
    }
    ref_pos = ref_posa;
}

-(float *)getRefpos{
    return ref_pos;
}

-(void)dealloc{
    free(ref_pos);
}

@end
