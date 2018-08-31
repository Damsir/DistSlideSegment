//
//  DistNaviSegment.m
//  JRYD
//
//  Created by 吴定如 on 2018/8/14.
//  Copyright © 2018年 Dist. All rights reserved.
//

#import "DistNaviSegment.h"
#import "DistSlideCollectionCell.h"

#define Margin 0
#define HeaderHeight 44.0
#define BigSize 17.0
#define NormalSize 17.0
#define Font(size) [UIFont systemFontOfSize:size]
#define MaskColor [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:0.5]
#define NormalColor [UIColor blackColor]
#define BLUECOLOR [UIColor colorWithRed:34.0/255.0 green:152.0/255.0 blue:239.0/255.0 alpha:1.0] //#2298ef
#define SKYBLUECOLOR [UIColor colorWithRed:60.0/255.0 green:186.0/255.0 blue:255.0/255.0 alpha:1.0] //#3CBAFF

#define DSS_SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define DSS_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SlideSegmentWidth 200
#define ItemCount 3

static NSString *cellId = @"DistSlideCollectionCell";

@interface DistNaviSegment () <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,UIGestureRecognizerDelegate>

{
    CGFloat segmentWidth;
    CGFloat scrollViewHeight;
}

@property (nonatomic, strong) UIViewController *controller;
@property (nonatomic, assign) NSInteger itemNum; //控制器个数
@property (nonatomic, strong) NSArray *items; //控制器标题
@property (nonatomic, strong) NSArray *views; //控制器视图
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectView; //顶部滑动视图
@property (nonatomic, assign) NSInteger segmentToIndex; //顶部滑动偏移
@property (nonatomic, strong) UIScrollView *scrollView; //控制器滑动
@property (nonatomic, assign) NSInteger selectedIndex; //记录当前选择的按钮
@property (nonatomic, strong) UIView *underlineView; //下划线
@property (nonatomic, assign) CGFloat underlineX; //下划线的x位置
@property (nonatomic, assign) CGFloat underlineWidth; //下划线的宽度

@end

@implementation DistNaviSegment

- (instancetype)initWithFrame:(CGRect)frame titlesArray:(NSArray *)titles viewsArray:(NSArray *)views controller:(UIViewController *)controller {
    self = [super initWithFrame:frame];
    if (self) {
        _controller = controller;
        _itemNum = views.count;
        _items = titles;
        _views = views;
        scrollViewHeight = frame.size.height;
        // 默认当前点击为第一个按钮
        _selectedIndex = 0;
        // segment宽度
        if (_itemNum <= ItemCount) {
            segmentWidth = SlideSegmentWidth/_itemNum;
        } else {
            segmentWidth = SlideSegmentWidth/ItemCount;
        }
        [self initSlideSegmentAndScrollView];
        [self initUnderlineView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 设置self的高度
    scrollViewHeight = self.frame.size.height;
    // segment宽度
    if (_itemNum <= ItemCount) {
        segmentWidth = SlideSegmentWidth/_itemNum;
    } else {
        segmentWidth = SlideSegmentWidth/ItemCount;
    }

    CGRect rect = CGRectMake(Margin, 0, SlideSegmentWidth, HeaderHeight);
    _layout.itemSize = CGSizeMake(segmentWidth, HeaderHeight);
    // 注意: 这个地方不是设置frame(ipad显示不居中)
    _collectView.bounds = rect;
    [_collectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    if (_selectedIndex > 2 && _selectedIndex < _itemNum - 2) {
        [_collectView setContentOffset:CGPointMake((_selectedIndex-2)*segmentWidth, 0)];
    } else if (_selectedIndex >= _itemNum -2 ) {
        [_collectView setContentOffset:CGPointMake(0, 0)];
        //        [_collectView setContentOffset:CGPointMake((_itemNum-2-2-1)*segmentWidth, 0)];
    }
    _scrollView.frame = CGRectMake(0, 0, DSS_SCREEN_WIDTH, scrollViewHeight);
    _scrollView.contentSize = CGSizeMake(DSS_SCREEN_WIDTH * _itemNum, scrollViewHeight);
    _scrollView.contentOffset = CGPointMake(_selectedIndex * DSS_SCREEN_WIDTH, 0);
    
    // 控制器的视图添加约束
    for (int i=0; i<_views.count; i++) {
        UIView *view;
        if ([_views[i] isKindOfClass:[UIViewController class]]) {
            view = [_views[i] view];
        } else {
            view = _views[i];
        }
        view.frame = CGRectMake(i*DSS_SCREEN_WIDTH, 0, DSS_SCREEN_WIDTH, scrollViewHeight);
    }
    
    // 下划线
    CGSize titleSize = [self sizeWithText:_items[_selectedIndex] font:Font(BigSize) maxSize:CGSizeMake(segmentWidth, MAXFLOAT)];
    CGFloat X = (_selectedIndex * segmentWidth) + (segmentWidth - titleSize.width)*0.5;
    // 和字体宽度一样宽的下划线
    _underlineView.frame = CGRectMake(X, HeaderHeight-2, titleSize.width, 2);
    // 和按钮宽度一样的下划线
    _underlineView.frame = CGRectMake(_selectedIndex * segmentWidth, HeaderHeight-2, segmentWidth, 2);
}

#pragma mark -- 初始化sliderSegment
- (void)initSlideSegmentAndScrollView {
    
    CGRect rect = CGRectMake(Margin, 0, SlideSegmentWidth, HeaderHeight);
    // 初始化布局类(UICollectionViewLayout的子类)
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    // 设置水平方向滑动
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _layout = layout;
    layout.itemSize = CGSizeMake(segmentWidth, HeaderHeight);
    layout.minimumInteritemSpacing = 0;//设置行间隔
    layout.minimumLineSpacing = 0;//设置列间隔
    //初始化collectionView
    UICollectionView *collectView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    collectView.backgroundColor = [UIColor whiteColor];
    //设置代理
    collectView.delegate = self;
    collectView.dataSource = self;
    collectView.showsHorizontalScrollIndicator = NO;
    collectView.bounces = NO;
    // 注册cell
    [collectView registerNib:[UINib nibWithNibName:@"DistSlideCollectionCell" bundle:nil] forCellWithReuseIdentifier:cellId];
    _collectView = collectView;
//    [self addSubview:collectView];
    _controller.navigationItem.titleView = collectView;
    
    // 底层滑动视图
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DSS_SCREEN_WIDTH, scrollViewHeight)];
    scrollView.contentSize = CGSizeMake(DSS_SCREEN_WIDTH*_itemNum, scrollViewHeight);
    scrollView.contentOffset = CGPointMake(0, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    _scrollView = scrollView;
    [self addSubview:scrollView];
    
    // 将控制器的视图添加到scrollView上
    for (int i=0; i<_views.count; i++) {
        UIView *view;
        if ([_views[i] isKindOfClass:[UIViewController class]]) {
            view = [_views[i] view];
        } else {
            view = _views[i];
        }
        view.frame = CGRectMake(i * DSS_SCREEN_WIDTH, 0, DSS_SCREEN_WIDTH, scrollViewHeight);
        [_scrollView addSubview:view];
    }
    
    // 监听contentOffset
    //[_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    /**
     *  Description
     */
    //    if (_selectedIndex == 0) {
    //        _scrollView.scrollEnabled = NO;
    //    }else{
    //        _scrollView.scrollEnabled = YES;
    //    }
}

#pragma mark -- 初始化下划线
- (void)initUnderlineView {
    // 分割线
    //    UIView *seperateLineView = [[UIView alloc] initWithFrame:CGRectMake(0, HeaderHeight-1, DSS_SCREEN_WIDTH, 1)];
    //    seperateLineView.backgroundColor = [UIColor colorWithRed:0.9686 green:0.9765 blue:0.9804 alpha:1.0];;
    //    [_collectView addSubview:seperateLineView];
    
    // CGSize titleSize = [self sizeWithText:[_items firstObject] font:Font(BigSize) maxSize:CGSizeMake(segmentWidth, MAXFLOAT)];
    // 和字体宽度一样宽的下划线
    // UIView *underlineView = [[UIView alloc] initWithFrame:CGRectMake((segmentWidth - titleSize.width)*0.5,HeaderHeight-2,titleSize.width,2)];
    // 和按钮宽度一样宽的下划线
    UIView *underlineView = [[UIView alloc] initWithFrame:CGRectMake(0, HeaderHeight-2, segmentWidth, 2)];
    underlineView.backgroundColor = BLUECOLOR;
    _underlineView = underlineView;
    [_collectView addSubview:underlineView];
}

#pragma mark -- 设置下划线的起始位置
- (void)setUnderlineX:(CGFloat)underlineX {
    _underlineX = underlineX;
    CGRect frame = _underlineView.frame;
    frame.origin.x = underlineX;
    _underlineView.frame = frame;
}

#pragma mark -- 设置下划线的宽度
- (void)setUnderlineWidth:(CGFloat)underlineWidth {
    _underlineWidth = underlineWidth;
    CGRect frame = _underlineView.frame;
    frame.size.width = underlineWidth;
    _underlineView.frame = frame;
}

#pragma mark -- 从某个item移动到另一个item
- (void)setItemColorFromIndex:(NSInteger)fromIndex to:(NSInteger)toIndex {
    
    [self scrollToWithIndexPath:[NSIndexPath indexPathForRow:toIndex inSection:0]];
    DistSlideCollectionCell *fromCell = (DistSlideCollectionCell *)[_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:fromIndex inSection:0]];
    DistSlideCollectionCell *toCell = (DistSlideCollectionCell *)[_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:toIndex inSection:0]];
    
    [fromCell.title setTextColor:NormalColor];
    [fromCell setFontScale:NO bigSize:BigSize normalSize:NormalSize];//反选字体保持原样
    [toCell.title setTextColor:BLUECOLOR];
    [toCell setFontScale:YES bigSize:BigSize normalSize:NormalSize];//选中字体放大
    
    _selectedIndex = toIndex;
}

#pragma mark -- 设置移动位置
- (void)scrollToWithIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger toRow = indexPath.row;
    // 点击 字体和下划线改变
    CGSize titleSize = [self sizeWithText:_items[toRow] font:Font(BigSize) maxSize:CGSizeMake(segmentWidth, MAXFLOAT)];
    if (toRow != _selectedIndex) {
        
        [UIView animateWithDuration:0.35 animations:^{
            // 和字体宽度一样的下划线
            CGFloat X = _selectedIndex * segmentWidth + (segmentWidth - titleSize.width)*0.5;
//            [self setUnderlineX:X];
//            [self setUnderlineWidth:titleSize.width];
            // 和按钮宽度一样的下划线
            X = _selectedIndex * segmentWidth;
            [self setUnderlineX:X];
            [self setUnderlineWidth:segmentWidth];
        }];
        //        NSLog(@"item = %ld",(long)toRow);
    }
    
    //    _currentBarIndex = toRow;
    
    if (indexPath.row > _selectedIndex) {
        if ((indexPath.row+2) < _items.count) {
            toRow = indexPath.row+2;
            // NSLog(@"toRow = %ld",toRow);
        } else if ((indexPath.row+1) < _items.count) {
            toRow = indexPath.row+1;
            // NSLog(@"toRow = %ld",toRow);
        } else;
        [_collectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:toRow inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    } else if (indexPath.row < _selectedIndex){
        if ((indexPath.row-2) >= 0) {
            toRow = indexPath.row-2;
            // NSLog(@"toRow = %ld",toRow);
        } else if ((indexPath.row-1) >= 0) {
            toRow = indexPath.row-1;
            // NSLog(@"toRow = %ld",toRow);
        } else;
        [_collectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:toRow inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    } else {
        return;
    }
}

#pragma -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DistSlideCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.title.text = _items[indexPath.row];
    cell.title.font = Font(NormalSize);
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.row == _selectedIndex) {
        [cell.title setTextColor:BLUECOLOR];
        [cell.title setFont:Font(BigSize)];
    } else {
        [cell.title setTextColor:NormalColor];
        [cell.title setFont:Font(NormalSize)];
    }
    return cell;
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //[self scrollToWithIndexPath:indexPath];
    [self setItemColorFromIndex:_selectedIndex to:indexPath.row];
    _scrollView.contentOffset = CGPointMake(DSS_SCREEN_WIDTH * indexPath.row, 0);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == _scrollView) {
        int toIndex = (int)(_scrollView.contentOffset.x/_scrollView.frame.size.width + 0.5);
        //        NSLog(@"whichItem_DidScroll:%ld",(long)toIndex);
        // 设置下划线位置和宽度
        CGSize titleSize = [self sizeWithText:_items[toIndex] font:Font(BigSize) maxSize:CGSizeMake(segmentWidth, MAXFLOAT)];
        if (toIndex != _selectedIndex) {
            // **
            [self setItemColorFromIndex:_selectedIndex to:toIndex];
            [UIView animateWithDuration:0.35 animations:^{
                CGFloat X = _selectedIndex * segmentWidth + (segmentWidth - titleSize.width)*0.5;
                if (_itemNum <= ItemCount) {
                    X = (_scrollView.contentOffset.x/_itemNum) * (segmentWidth*_itemNum/DSS_SCREEN_WIDTH);
                } else {
                    X = (_scrollView.contentOffset.x/_itemNum) * (segmentWidth*ItemCount/DSS_SCREEN_WIDTH);
                }
                [self setUnderlineX:X];
                [self setUnderlineWidth:segmentWidth];
            }];
        }
        if (_scrollView.isDragging) {
            CGFloat X = segmentWidth * toIndex + (segmentWidth - titleSize.width) * 0.5;
            if (_itemNum <= ItemCount) {
                X = (_scrollView.contentOffset.x/_itemNum) * (segmentWidth*_itemNum/DSS_SCREEN_WIDTH);
            } else {
                X = (_scrollView.contentOffset.x/_itemNum) * (segmentWidth*ItemCount/DSS_SCREEN_WIDTH);
            }
            [self setUnderlineX:X];
        } else {
            [UIView animateWithDuration:0.35 animations:^{
                CGFloat X = segmentWidth * toIndex + (segmentWidth - titleSize.width) * 0.5;
                if (_itemNum <= ItemCount) {
                    X = (_scrollView.contentOffset.x/_itemNum) * (segmentWidth*_itemNum/DSS_SCREEN_WIDTH);
                } else {
                    X = (_scrollView.contentOffset.x/_itemNum) * (segmentWidth*ItemCount/DSS_SCREEN_WIDTH);
                }
                [self setUnderlineX:X];
            }];
        }
    }
    /**
     *  Description
     */
    //    if (_selectedIndex == 0) {
    //        _scrollView.scrollEnabled = NO;
    //    }else{
    //        _scrollView.scrollEnabled = YES;
    //    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == _scrollView) {
        NSInteger toIndex = (int)(_scrollView.contentOffset.x/_scrollView.frame.size.width + 0.5);
        //        NSLog(@"toIndex:%ld",(long)toIndex);
        // 设置下划线位置和宽度
        CGSize titleSize = [self sizeWithText:_items[toIndex] font:Font(BigSize) maxSize:CGSizeMake(segmentWidth, MAXFLOAT)];
        if (toIndex != _selectedIndex) {
            //[self setItemColorFromIndex:_selectedIndex to:toIndex];
            [UIView animateWithDuration:0.35 animations:^{
                // 和字体宽度一样的下划线
                CGFloat X = _selectedIndex * segmentWidth + (segmentWidth - titleSize.width)*0.5;
                // 和按钮宽度一样的下划线
                if (_itemNum <= ItemCount) {
                    X = (_scrollView.contentOffset.x/_itemNum) * (segmentWidth*_itemNum/DSS_SCREEN_WIDTH);
                } else {
                    X = (_scrollView.contentOffset.x/_itemNum) * (segmentWidth*ItemCount/DSS_SCREEN_WIDTH);
                }
//                [self setUnderlineX:X];
//                [self setUnderlineWidth:segmentWidth];
            }];
        }
        if (_scrollView.isDragging) {
            // 和字体宽度一样的下划线
            CGFloat X = _selectedIndex * segmentWidth + (segmentWidth - titleSize.width)*0.5;
            // 和按钮宽度一样的下划线
            if (_itemNum <= ItemCount) {
                X = (_scrollView.contentOffset.x/_itemNum) * (segmentWidth*_itemNum/DSS_SCREEN_WIDTH);
            } else {
                X = (_scrollView.contentOffset.x/_itemNum) * (segmentWidth*ItemCount/DSS_SCREEN_WIDTH);
            }
//            [self setUnderlineX:X];
        } else {
            [UIView animateWithDuration:0.35 animations:^{
                // 和字体宽度一样的下划线
                CGFloat X = _selectedIndex * segmentWidth + (segmentWidth - titleSize.width)*0.5;
                // 和按钮宽度一样的下划线
                if (_itemNum <= ItemCount) {
                    X = (_scrollView.contentOffset.x/_itemNum) * (segmentWidth*_itemNum/DSS_SCREEN_WIDTH);
                } else {
                    X = (_scrollView.contentOffset.x/_itemNum) * (segmentWidth*ItemCount/DSS_SCREEN_WIDTH);
                }
//                [self setUnderlineX:X];
            }];
        }
        _selectedIndex = toIndex;
    }
    /**
     *  Description
     */
    //    if (_selectedIndex == 0) {
    //        _scrollView.scrollEnabled = NO;
    //    }else{
    //        _scrollView.scrollEnabled = YES;
    //    }
}

#pragma mark -- 计算字体尺寸

/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

/**
 移除监听方法有两种:
 1.重写removeFromSuperview 方法移除监听
 */
- (void)removeFromSuperview {
    [super removeFromSuperview];
    //移除监听contentOffset
    //    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [_scrollView removeFromSuperview];
    _scrollView = nil;
}
/**
 *  2.重写dealloc 方法移除监听
 */
- (void)dealloc {
    //移除监听contentOffset
    //    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    //    [_scrollView removeFromSuperview];
    //    _scrollView = nil;
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//
//    if (gestureRecognizer.state != 0) {
//        return YES;
//    } else {
//        return NO;
//    }
//
//}

@end
