//
//  DistSlideSegment.h
//  DJYJC
//
//  Created by 吴定如 on 17/2/28.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DistSlideSegment : UIView

/**
 分段滑动组件:SlideSegment

 @param frame  frame
 @param titles 标题数组
 @param views  视图数组
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame titlesArray:(NSArray *)titles viewsArray:(NSArray *)views;

@end
