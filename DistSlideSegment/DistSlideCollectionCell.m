//
//  DistSlideCollectionCell.m
//  DJYJC
//
//  Created by 吴定如 on 17/2/28.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "DistSlideCollectionCell.h"

@implementation DistSlideCollectionCell

- (void)setFontScale:(BOOL)scale bigSize:(CGFloat)bigSize normalSize:(CGFloat)normalSize {

    if (scale) {
        // 1.3 = bigSize / normalSize
        [UIView animateWithDuration:0.3 animations:^{
            CGAffineTransform trans = CGAffineTransformScale(_title.transform, bigSize/normalSize, bigSize/normalSize);
            [_title setTransform:trans];
        } completion:^(BOOL finished) {
            [_title setTransform:CGAffineTransformIdentity];
            [_title setFont:[UIFont systemFontOfSize:bigSize]];
        }];
    } else {
        // 0.7692 = normalSize / bigSize
        [UIView animateWithDuration:0.3 animations:^{
            CGAffineTransform trans = CGAffineTransformScale(_title.transform, normalSize/bigSize, normalSize/bigSize);
            [_title setTransform:trans];
        } completion:^(BOOL finished) {
            [_title setTransform:CGAffineTransformIdentity];
            [_title setFont:[UIFont systemFontOfSize:normalSize]];
        }];
    }
}

@end
