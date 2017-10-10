//
//  DistSlideCollectionCell.m
//  LYJC
//
//  Created by 吴定如 on 2017/10/10.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "DistSlideCollectionCell.h"
#define BigSize 16.0
#define NormalSize 16.0

@implementation DistSlideCollectionCell

- (void)setFontScale:(BOOL)scale{
    
    if (scale) {
        // 1.3 = bigSize / normalSize
        [UIView animateWithDuration:0.3 animations:^{
            CGAffineTransform trans = CGAffineTransformScale(_title.transform,BigSize/NormalSize,BigSize/NormalSize);
            [_title setTransform:trans];
        } completion:^(BOOL finished) {
            [_title setTransform:CGAffineTransformIdentity];
            //            [_title setFont:[UIFont fontWithName:Font_PingFangSC_Light size:BigSize]];
            [_title setFont:[UIFont systemFontOfSize:BigSize]];
        }];
    } else {
        // 0.7692 = normalSize / bigSize
        [UIView animateWithDuration:0.3 animations:^{
            CGAffineTransform trans = CGAffineTransformScale(_title.transform,NormalSize/BigSize,NormalSize/BigSize);
            [_title setTransform:trans];
        } completion:^(BOOL finished) {
            [_title setTransform:CGAffineTransformIdentity];
            //            [_title setFont:[UIFont fontWithName:Font_PingFangSC_Light size:NormalSize]];
            [_title setFont:[UIFont systemFontOfSize:NormalSize]];
        }];
    }
}

@end
