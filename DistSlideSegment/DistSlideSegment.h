//
//  DistSlideSegment.h
//  LYJC
//
//  Created by 吴定如 on 2017/10/10.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DistSlideSegment : UIView

/** 屏幕旋转 */
- (void)screenRotationWithFrame:(CGRect)frame;
/** 初始化 */
- (instancetype)initWithFrame:(CGRect)frame controllerViewsArray:(NSArray *)viewsArray titlesArray:(NSArray *)titlesArray;

@end
