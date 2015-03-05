//
//  ZXWaterflowView.m
//  zxWaterFallFlow
//
//  Created by zx on 15/2/17.
//  Copyright (c) 2015年 zx. All rights reserved.
//

#import "ZXWaterflowView.h"
#import "ZXWaterflowViewCell.h"

#define ZXWaterflowViewDefaultNumberOfColumns 3
#define ZXWaterflowViewDefaultCellHeight 100
#define ZXWaterflowViewDefaultCellMargin 10


/**
 *  存储每个cell的frame====>判断谁该进入复用池(reusableCells) | 谁该显示在屏幕上(displingCells)
 *
 */
@interface ZXWaterflowView ()
@property (nonatomic,strong) NSMutableArray    *cellFrames;
@property (nonatomic,strong) NSMutableDictionary    *displingCells;
@property (nonatomic,strong) NSMutableSet    *reusableCells;
@end

@implementation ZXWaterflowView

#pragma mark - 懒加载数

-(NSMutableArray *)cellFrames{
    if (_cellFrames == nil) {
        _cellFrames = [NSMutableArray array];
    }
    return _cellFrames;
}

-(NSMutableDictionary *)displingCells{
    if (_displingCells == nil) {
        _displingCells = [NSMutableDictionary dictionary];
    }
    return _displingCells;
}

-(NSMutableSet *)reusableCells{
    if (_reusableCells == nil) {
        _reusableCells = [NSMutableSet set];
    }
    return _reusableCells;
}


/**
 *  重写:当前视图显示到最前的时候
 *
 *  @param newSuperview 父视图
 */
-(void)willMoveToSuperview:(UIView *)newSuperview{
    [self reloadData];
}

/**
 *  cell宽度
 *  宽度计算 (总宽度- 左右间距- 列间距- cell宽度*(cell数-1)) / cell数
 *  @return cell宽度
 */
-(CGFloat)cellWidth{
    
    int numberOfColumns =  [self numberOfColumns];
    
    CGFloat leftMargin      = [self marginForType:ZXWaterFlowViewMarginTypeLeft];
    CGFloat rightMargin     = [self marginForType:ZXWaterFlowViewMarginTypeRight];
    CGFloat columnMagrin    = [self marginForType:ZXWaterFlowViewMarginTypeColumn];
    
    return (self.frame.size.width - leftMargin - rightMargin - (numberOfColumns-1)*columnMagrin)/numberOfColumns;
}


#pragma mark 刷新数据
/**
 *  刷新数据
 *  需要定的数据:cell的高度,cell的宽度,cell的x坐标,cell的坐标
 *  添加到滚动视图上,设置滚动视图的内容的高度
 */
-(void)reloadData{
    
    /* 
        上下拉刷新数据部分:
     （1）把字典中的所有的值，都从屏幕上移除
     （2）清除字典中的所有元素
     （3）清除cell的frame,每个位置的cell的frame都要重新计算
     （4）清除可复用的缓存池。
     */

    [self.displingCells.allValues makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.displingCells removeAllObjects];
    [self.cellFrames removeAllObjects];
    [self.reusableCells removeAllObjects];
    
    
#pragma mark 必须实现的协议方法1
    //cell总数
    int numberOfCells = [self.dataSource numberOfCellsInWaterflowView:self];
    
    //cell列数
    int numberOfColumns = [self numberOfColumns];
    
    //cell边距
    CGFloat leftMargin      = [self marginForType:ZXWaterFlowViewMarginTypeLeft];
    CGFloat rightMargin     = [self marginForType:ZXWaterFlowViewMarginTypeRight];
    CGFloat topMargin       = [self marginForType:ZXWaterFlowViewMarginTypeTop];
    CGFloat bottomMargin    = [self marginForType:ZXWaterFlowViewMarginTypeBottom];
    CGFloat columnMagrin    = [self marginForType:ZXWaterFlowViewMarginTypeColumn];
    CGFloat rowMargin       = [self marginForType:ZXWaterFlowViewMarginTypeRow];
    
    //1-->cell宽度
    //cell宽度 = (视图宽度 - 左间距 - 右间距 - (列数-1)*列间距) / 列数
//    CGFloat cellWidth = (self.frame.size.width - leftMargin - rightMargin - (numberOfColumns-1)*columnMagrin)/numberOfColumns;
    CGFloat cellWidth = [self cellWidth];
    
    //数组:存储每列cell的高度
    CGFloat heightOfColumns[numberOfColumns];
    for (int i  = 0 ; i < numberOfColumns; i++) {
        heightOfColumns[i] = 0.0f;
    }
    
    //确定cell的frame
    for (int index = 0 ; index < numberOfCells; index++) {
        
        //2-->cell的高度
        //默认第0列最短,遍历数组,找出最短的列
        CGFloat cellHeight = [self heightAtIndex:index];
        NSUInteger shortestCellAtColumn = 0;
        CGFloat shortestCellHeight = heightOfColumns[shortestCellAtColumn];
        for (int j = 0 ; j < numberOfColumns; j++) {
            if (heightOfColumns[j] < shortestCellHeight) {
                shortestCellAtColumn = j;
                shortestCellHeight = heightOfColumns[j];
            }
        }
        //3-->cell的位置(X,Y)
        //x坐标 = 左间距 + 列号*(cell宽度+cell间距)
        CGFloat cellXpos = leftMargin + shortestCellAtColumn*(cellWidth + columnMagrin);
        CGFloat cellYpos = 0;
        
        //y坐标 = 最短cell高度 +  cell行间距
        if (shortestCellHeight == 0.0) {
            cellYpos = topMargin;
        }
        else{
            cellYpos = shortestCellHeight + rowMargin;
        }
        
        //确定frame,存入数组
        CGRect cellFrame = CGRectMake(cellXpos, cellYpos, cellWidth,cellHeight);
        [self.cellFrames addObject:[NSValue valueWithCGRect:cellFrame]];
        
        //更新列高度数组
        heightOfColumns[shortestCellAtColumn] = CGRectGetMaxY(cellFrame);
        
#pragma mark 必须实现的协议方法2
        //滚动视图内容
        //创建cell,显示cell
//        ZXWaterflowViewCell *cell = [self.dataSource waterflowView:self cellAtIndex:index];
//        cell.frame = cellFrame;
//        [self addSubview:cell];
    }
    
    //滚动视图内容高度 = 最大cell高度 + 底部边距
    CGFloat contentHeight = heightOfColumns[0];
    for (int i = 0 ; i < numberOfColumns; i++) {
        if (heightOfColumns[i] > contentHeight) {
            contentHeight = heightOfColumns[i];
            
        }
    }
    contentHeight += bottomMargin;
    self.contentSize = CGSizeMake(0, contentHeight);
    
}

/**
 *  UIScrollView的方法
 *  每绘制一个cell就会调用这个方法.
 *  在reloadData的时候,确定好frame,在个方法里,确定cell是否加载
 */
-(void)layoutSubviews{
    [super layoutSubviews];
    
    //NSLog(@"%s [LINE:%d] %d", __func__, __LINE__,self.subviews.count);
    //> zxWaterFallFlow[9328:607] -[ZXWaterflowView layoutSubviews] [LINE:130] 102
    //cell数为100+2,其中2为scrollView水平和垂直的滑动条指示.
    
    NSUInteger numberOfCells = self.cellFrames.count;
    for (int index = 0 ; index < numberOfCells ; index++) {
        CGRect cellFrame = [self.cellFrames[index] CGRectValue];
        ZXWaterflowViewCell *cell  = [_displingCells objectForKey:@(index)];
        if ([self isCellOnScreen:cellFrame]) {
            if (cell == nil) {
                cell = [self.dataSource waterflowView:self cellAtIndex:index];
                cell.frame = cellFrame;
                [self addSubview:cell];
                [self.displingCells setObject:cell forKey:@(index)];
            }
        }
        else{
            if (cell) {
                [cell  removeFromSuperview];
                [self.displingCells removeObjectForKey:@(index)];
                [self.reusableCells addObject:cell];
            }
        }
    }
}

/**
 *  复用:
 *  根据复用标志符去复用池中取cell,如果某个cell的标志符一样,就取出来,停止遍历复用池.
 *  取出后,从复用池中删除已有的cell
 *  知识点,遍历集合(set)的方法==>使用blokc进行遍历.
 *  @param identifier cell标志符
 *
 *  @return 复用的cell
 */
-(id)dequeueReusableCellWithIdentifier:(NSString *)identifier{
    __block ZXWaterflowViewCell *resuableCell = nil;
   [self.reusableCells enumerateObjectsUsingBlock:^(ZXWaterflowViewCell *cell, BOOL *stop)
    {
        if ([cell.identifier isEqualToString:identifier]) {
            resuableCell = cell;
            *stop = YES;
        }
    }];
    
    if (resuableCell) {
        [self.reusableCells removeObject:resuableCell];
    }
    return resuableCell;
}

/**
 *  触摸事件处理
 *  触摸的点是否在某个frame上? ====> CGRectContainsPoint
 *  遍历集合,判断是否在cell上.
 *
 *  @param touches 触摸
 *  @param event   事件
 */
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (![self.delegate respondsToSelector:@selector(waterflowView:didSelectAtIndex:)]) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    __block NSNumber *selectedIndex = nil;
    
    [self.displingCells enumerateKeysAndObjectsUsingBlock:^(id key, ZXWaterflowViewCell *cell, BOOL *stop) {
        if (CGRectContainsPoint(cell.frame, point)) {
            selectedIndex = key;
            *stop = YES;
        }
    }];
    if (selectedIndex) {
        [self.delegate waterflowView:self didSelectAtIndex:selectedIndex.unsignedIntegerValue];
    }
    
#if 0
    CGPoint pointA = [touch locationInView:self];//坐标系以滚动视图为参考
    CGPoint pointB = [touch locationInView:touch.view];//坐标系以cell为参考
    NSLog(@"touch postion: %@ -- %@ ",NSStringFromCGPoint(pointA),NSStringFromCGPoint(pointB));
#endif
}


#pragma mark -私有方法(默认cell的间距,列数,高度)

/**
 *  判断cell是否在屏幕上
 *
 *  @param frame 需要判断的frame
 *
 *  @return 是否在屏幕上
 */
-(BOOL)isCellOnScreen:(CGRect)frame{
    return  (CGRectGetMaxY(frame) > self.contentOffset.y) &&
    (CGRectGetMinY(frame) < self.contentOffset.y + self.frame.size.height);
}

/**
 *  默认cell的间距
 *
 *  @param type 间距类型
 *
 *  @return cell间距
 */
-(CGFloat)marginForType:(ZXWaterFlowViewMarginType )type{
    if ([self.delegate respondsToSelector:@selector(waterflowView:marginForType:)]) {
        return [self.delegate waterflowView:self marginForType:type];
    }
    else{
        return ZXWaterflowViewDefaultCellMargin;
    }
}

/**
 *  默认cell的列数
 *
 *  @return 列数
 */
-(NSUInteger )numberOfColumns{
    if ([self.dataSource respondsToSelector:@selector(numberOfColumnsInWaterflowView:)]) {
        return [self.dataSource numberOfColumnsInWaterflowView:self];
    }
    else{
        return ZXWaterflowViewDefaultNumberOfColumns;
    }
}

/**
 *  默认cell高度
 *
 *  @param index 区分cell的标志
 *
 *  @return cell高度
 */
-(CGFloat )heightAtIndex:(NSUInteger)index{
    if ([self.delegate respondsToSelector:@selector(waterflowView:heightAtIndex:)]) {
        return [self.delegate waterflowView:self heightAtIndex:index];
    }
    else{
        return ZXWaterflowViewDefaultCellHeight;
    }
}


@end
