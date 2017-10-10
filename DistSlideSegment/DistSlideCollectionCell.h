//
//  DistSlideCollectionCell.h
//  LYJC
//
//  Created by 吴定如 on 2017/10/10.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DistSlideCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *title; /**< 标题 */

- (void)setFontScale:(BOOL)scale;/**< 设置分类标题文字字体的缩放 */

@end
