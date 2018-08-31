//
//  DistNaviSegment.h
//  JRYD
//
//  Created by 吴定如 on 2018/8/14.
//  Copyright © 2018年 Dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DistNaviSegment : UIView


/**
 导航栏分段滑动组件:SlideSegment
 
 @param frame  frame
 @param titles 标题数组
 @param views  视图数组
 @param controller 父控制器
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame titlesArray:(NSArray *)titles viewsArray:(NSArray *)views controller:(UIViewController *)controller;

@end
