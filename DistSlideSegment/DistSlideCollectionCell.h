//
//  DistSlideCollectionCell.h
//  DJYJC
//
//  Created by 吴定如 on 17/2/28.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DistSlideCollectionCell : UICollectionViewCell

/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel *title;

/** 设置分类标题文字字体的缩放 */
- (void)setFontScale:(BOOL)scale bigSize:(CGFloat)bigSize normalSize:(CGFloat)normalSize;

@end
